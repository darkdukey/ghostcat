tick为系统的相对时间单位，也被称为系统的时基，来源于定时器的周期性中断，一次中断表示一个tick。

大家都知道，FLASH的ENTER\_FRAME的触发间隔是不确定的，受到浏览器和当时的资源分配情况影响，原因就在于FLASH是基于帧而不是基于时基的。在网站和动画中，这个缺陷的影响并不大，但在游戏里则不一样了。时基的不统一就如同开了变速齿轮一般，会造成各种未知的影响，因此，这是一个必须解决的问题。

统一时基的方法有很多，GhostCat采用的是一种更倾向与性能的方法。它的时基事件依然是由ENTER\_FRAME发出的（而不是Timer），并通过getTimer()方法获得两次事件的间隔毫秒数，并以这个间隔值为参数对不同的情况分别进行处理。这个做法稍显复杂，且触发次数依然不固定，但能够和FLASH的屏幕刷新同步，而且不会产生多余的渲染次数。

实现时基的类是Tick.as，它会不停地发布TickEvent事件，附带上作为时间间隔的interval属性。Ghostcat.display.other.BubbleCreater就有直接利用Tick来调节时基的做法。只要记得interval代表的是速度就可以了。

当然，这个利用interval的方式的确没有固定间隔的事件发布容易理解。好在一般也不怎么需要手动处理interval。运动方面只要使用内部TweenUtil（或者TweenMax）就可以自动实现时基，而动画方面，则是现在要讲的内容。GMovieClipBase。

GMovieClipBase是采用这种时基方式实现的动画。因为FLASH的动画并不是基于时基的，所以必须手动实现动画跳转。也因为如此，每一个动画都拥有了自己的frameRate，自己的播放速度。但，并不仅仅是如此。

GMovieClipBase的动画是完全自主控制的，所以，即使做一些多余的判断也不浪费性能（自主控制动画的确会消耗性能，但为了实现时基这是必须的）。GMovieClipBase会自动根据动画的标签来为动画分段，并通过加入队列来进行动画的排队播放，诸如这样的代码：

mc.setLabel("startjump",1);
mc.queueLabel("jump",1);
mc.queueLabel("slip",3);
mc.queueLabel("slipstop",1);
mc.queueLabel("normal",-1)

这段代码的结果会让动画先播放完整个标记为startjump的部分，然后挑转到jump标签播放，接着是slip,这次会播放3次，然后跳转到slipstop，最后执行循环播放normal，直到下一次setLabel。

形象地说，就是先做出起跳动作，然后跳起完成整个跳跃动作，然后开始做滑行动作，接着受身，最后回到普通状态……

好，说到这里还不明白那再说也没用了。

这种方式是有缺陷的，首先，的确会比普通的动画更耗费性能，而且这样一做，动画里的子动画也会无法正常播放，也就是说无法再在电影剪辑里继续套电影剪辑了（定义成“图形”还是可以的），动画只允许出现一层。一定要双层的话，只能让里面的内容也被GMovieClipBase控制。这是FLASH自身的缺陷，没有办法。

但它的优点也很明显。进入AS3时代要求抛弃时间线代码，这是团队开发所必须的，但stop也要抛弃的确有些麻烦。如果用GMovieClipBase管理的话，只要设置好帧标签，并用代码播放的话，怎么控制也都没有问题。每次动画完成都会发布事件，然后就可以根据事件再跳转到不同的帧并完成一段固定动画跳转，这种做法并不比时间线代码更麻烦，有些时候甚至更简单。

只是定义帧标签，相信这对美工不会是个问题。标签用中文也是一点关系都没有的。



好了，说了这么久GMovieClipBase，但GMovieClipBase实际上并不是一个允许实例化的类（但我做不到- -），使用的时候应该用GMovieClip和GBitmapMovieClip，分别对应FLASH矢量动画和BitmapData数组动画。他们的大部分方法都是完全相同的（因为是同一个基类），而且本身基本没什么代码。GBitmapMovieClip同样也支持帧标签，因为没有IDE只能手动创建数组内容，也有一个简单的办法，就是从一个空MC里直接复制currentLabels数组，这样一来，实际上失量动画和位图动画也没什么区别。

GMovieClip本身就有一个方法，可以直接转换成GBitmapMovieClip，它会自动缓存所有图形并复制Labels，可以用来处理复杂矢量动画的性能问题。但这样做，一定要做好位图的回收。动画位图的泄露可是非常严重的事情。

GMovieClip还包含一个独立的TimeLine类，可以用它来包装不需要控制播放的电影剪辑。它同样可以提供LABEL\_CHANGE,TIMELINE\_END这样的事件来辅助控制动画。
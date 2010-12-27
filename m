From: Neil Brown <neilb@suse.de>
Subject: Re: using poll on /proc/mdstat
Date: Mon, 27 Dec 2010 17:27:19 +1100
Message-ID: <20101227172719.01bae9db@notabene.brown>
References: <201012251036232181820@gmail.com>
	<201012251048579216597@gmail.com>
	<20101226224434.0c34f445@notabene.brown>
	<201012270920567187973@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201012270920567187973@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "kernel.majianpeng" <kernel.majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, 27 Dec 2010 09:21:00 +0800 "kernel.majianpeng"
<kernel.majianpeng@gmail.com> wrote:

> Hi all:
>     read Neil Brown's mail, I modified the function:
> char buff[4096] = {0};
> 	int fd = open("/proc/mdstat",O_RDONLY);
> 	if(fd < 0){
> 		printf("open /proc/mdstat error:%s\n",strerror(errno));
> 		return -errno;
> 	}
> 
> 	struct pollfd fds[1];
> 	int ret;
> 
> 	fds[0].fd = fd;
> 	fds[0].events = POLLPRI;
> 	while(1){
> 		fds[0].fd = fd;
> 		fds[0].events = POLLPRI;
> 		ret = poll(fds,1,-1);
> 		if(ret < 0){
> 			printf("poll error:%s\n",strerror(errno));
> 			break;
> 		}else
> 			printf("ret value=%d\n",fds[0].revents);
> 		read(fd,buff,4096);
> 		memset(buff ,0,4096);
> 	}
> 	close(fd);
> 
> I add read command and confirm read end of file /proc/mdstat.
> But this fution also to find only one event.

You missed this bit:


> poll will only block again after you read to the end of the file (and thus
> observe any change), and then seek back to the start.
                       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

NeilBrown



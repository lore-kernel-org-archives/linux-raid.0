From: Rob Hagopian <robraid@hagopian.net>
Subject: Re: raid bug in 2.4.20
Date: Thu, 10 Apr 2003 18:55:25 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0304101852360.25209-100000@karma.hagopian.net>
References: <200304101815_MC3-1-33E7-DA05@compuserve.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200304101815_MC3-1-33E7-DA05@compuserve.com>
To: Chuck Ebbert <76306.1226@compuserve.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

md0: resyncing spare disk sdb1 to replace failed disk
RAID1 conf printout:
 --- wd:1 rd:2 nd:2
 disk 0, s:0, o:1, n:0 rd:0 us:1 dev:sda1 
 disk 1, s:0, o:0, n:1 rd:1 us:0 dev:[dev 00:00]
 disk 2, s:1, o:0, n:2 rd:2 us:1 dev:sdb1 
 disk 3, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
 disk 4, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
 disk 5, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
 disk 6, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
...
 disk 26, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
RAID1 conf printout:
 --- wd:1 rd:2 nd:2
 disk 0, s:0, o:1, n:0 rd:0 us:1 dev:sda1 
 disk 1, s:0, o:0, n:1 rd:1 us:0 dev:[dev 00:00]
 disk 2, s:1, o:1, n:2 rd:2 us:1 dev:sdb1 
 disk 3, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
 disk 4, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
 disk 5, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
 disk 6, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
...
 disk 26, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
md: syncing RAID array md0
md: minimum _guaranteed_ reconstruction speed: 100 KB/sec/disc.
md: using maximum available idle IO bandwith (but not more than 100000 
KB/sec) for reconstruction.
md: using 124k window, over a total of 128384 blocks.
md: trying to hot-add sdb3 to md2 ...
...



I wonder at what point this will overflow?

md0 : active raid1 sdb1[2] sda1[0]
      128384 blocks [2/1] [U_]
      [>....................]  recovery =  0.0% (0/128384) 
finish=198160.7min speed=0K/sec

:-)

-Rob


On Thu, 10 Apr 2003, Chuck Ebbert wrote:

> 
> >md0 : active raid1 sdb1[2] sda1[0]
> >     128384 blocks [2/1] [U_]
> >      [>....................]  recovery =  0.0% (0/128384) 
> >finish=3658.9min speed=0K/sec
> 
> 
> 
>  What does it say in your syslog about this?
> 
> 
> --
>  Chuck
>  I am not a number!
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


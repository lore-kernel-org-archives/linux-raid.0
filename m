From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: RAID-6 horizontal grow
Date: Sat, 11 Apr 2009 12:40:47 +0200
Message-ID: <20090411104047.GA4489@lazy.lzy>
References: <20090410215435.GA10451@lazy.lzy> <20090410215833.GF21242@cthulhu.home.robinhill.me.uk> <20090410223433.GA10797@lazy.lzy> <20090411082348.GA3983@lazy.lzy> <bf90f0dca1b3c313c8ef5e74a4648938.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <bf90f0dca1b3c313c8ef5e74a4648938.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

> I love it when people find out answers by themselves - it shows the
> documentation isn't completely worthless :-)

well, I think the mdadm man page is good and
complete, even if it requires several re-reads
in order to get all the information... :-)
It is definitely worth!

BTW, maybe it would be good to update the wiki
page about this topic.

> I think so, but mdadm cannot do it for you (yet).
> 
> If you
>   for i in /sys/block/mdX/md/dev-*/size
>   do echo 0 > $i
>   done
> 
> it will have much the same effect as --assemble --update devicesize

Thank you so much!
This is exactly what I needed!
 
Thanks again,

bye,

-- 

piergiorgio

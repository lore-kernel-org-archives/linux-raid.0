From: Jim Paris <jim@jtan.com>
Subject: Re: High System Load
Date: Wed, 28 Jul 2004 20:17:33 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040729001732.GA18905@jim.sh>
References: <A506359028CAD21191C10008C75D895C0A06C865@NPRI54EXC14.NPT.NUWC.NAVY.MIL> <Pine.LNX.4.55.0407281322170.17864@umi.cfht.hawaii.edu> <41083CB6.9070901@h3c.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <41083CB6.9070901@h3c.com>
To: Mike Hardy <mhardy@h3c.com>
Cc: Kanoa Withington <kanoa@cfht.hawaii.edu>, Huntress Gary B NPRI <HuntressGB@Npt.NUWC.Navy.Mil>, "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> #!/bin/tcsh
> while 1
>   cat /proc/mdstat
>   sleep 1
>   clear
> end

.. or just 'watch cat /proc/mdstat' :)

> There's got to be something else happening on the machine...

I find that if the kernel variable dev.raid.speed_limit_max is too
high (the default, 200000, is usually too high), then the rebuild
could taking all available I/O time.  This can cause every other
process trying to do I/O on the machine to block, which may be the
reason your load average is so high.

Try doing 'sysctl -w dev.raid.speed_limit_max=10000' and see if things
improve.

-jim

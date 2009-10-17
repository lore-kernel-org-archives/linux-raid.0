From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Disappointing RAID10 Performance
Date: Sat, 17 Oct 2009 01:03:35 -0500
Message-ID: <20091017060332339.ILNZ13254@cdptpa-omta04.mail.rr.com>
References: <364346.70897.qm@web38808.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <364346.70897.qm@web38808.mail.mud.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> # time dd if={somelarge}.iso of=/dev/null bs={readahead size}
> 
> /dev/sd?
>  1024 71.3 MB/s
>  2048 71.2 MB/s
>  4096 77.7 MB/s
>  8192 69.4 MB/s
>  16384 76.6 MB/s
> 
> /dev/md2
>  1024  67.1
>  2048  69.1
>  4096  75.7
>  8192  64.9
>  16384 69.0
> 
> Using RAID10offset2 on 2 WD 2TB drives, and always the same input file.

	RAID10 on 2 drives?  Are you striping partitions on a single drive?
You won't get much of a performance boost that way.

> Why would RAID10 performance be -poorer-?
> If it weren't for mirroring, this wouldn't be worth it.

Is this with all drives local, or are you mirroring across a Gig-E link, as
I believe you said you were going to do?


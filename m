From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: RAID-6 problem
Date: Sat, 13 Oct 2012 19:23:04 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1210131919230.21297@uplift.swm.pp.se>
References: <20121013120328.GA23279@lazy.lzy>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121013120328.GA23279@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 13 Oct 2012, Piergiorgio Sartor wrote:

> I've a RAID-6, 10 HDDs, which, due to some hardware issue,
> has lost 4 HDDs.
> The RAID cannot be assembled anymore, of course.
>
> The missing HDDs are now available and sane, so I guess it
> could be possible to force an assemble operation.
>
> What would be the reccomended way to proceed?
>
> mdadm -A /dev/md1xx --force -c mdadm.conf
>
> and then re-add the missing HDDs (does the above works?)

Just --assemble --force if they all disappeared at roughly the same time 
(so all drives have not too different event count). If one drive has a 
very different event count, leave it out of the assembly and add it later.

> Or to re-create the array with "assume-clean" and with
> the proper device order? The device role seems to be
> available using "mdadm -E /dev/sdXy", I assume this
> gives the proper order.

Re-creating a raid5/6 with --assume-clean is for me a disaster recovery, 
something that should be performed when everything else fails. It's 
extremely unfortunate that a lot of guides bring this in very early in the 
fault finding process. I've talked to several people who completely 
screwed up their arrays by getting it wrong here.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se

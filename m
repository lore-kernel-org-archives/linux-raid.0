From: Neil Brown <neilb@suse.de>
Subject: Re: weird issues with raid1
Date: Tue, 16 Dec 2008 12:21:42 +1100
Message-ID: <18759.678.74091.236787@notabene.brown>
References: <cccedfc60812051810q3c44ae28x514072cb870ac390@mail.gmail.com>
	<18757.62097.166706.244330@notabene.brown>
	<cccedfc60812150542y5607d168q94c09d8dc3438226@mail.gmail.com>
	<18758.52536.345145.238926@notabene.brown>
	<cccedfc60812151347j659112c5na3aa8cd0eb044669@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jon Nelson on Monday December 15
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Monday December 15, jnelson-linux-raid@jamponi.net wrote:
> On Mon, Dec 15, 2008 at 3:33 PM, Neil Brown <neilb@suse.de> wrote:
> > On Monday December 15, jnelson-linux-raid@jamponi.net wrote:
> >>
> >> Aha!  This explains a question I raised in another email. What
> >> happened there is a previously fully active member of the raid got
> >> added, somehow, as a spare, via --incremental. That's when the entire
> >> raid thought it needed to be rebuilt. How did that (the device being
> >> treated as a spare instead of as a previously fully active member)
> >> happen?
> >
> > It is hard to guess without details, and they might be hard to collect
> > after the fact.
> > Maybe if you have the kernel logs of when the server rebooted and the
> > recovery started, that might contain some hints.
> 
> I hope this helps.

Yes it does, though I generally prefer to get more complete logs.  If
I get the surrounding log lines then I know what isn't there as well
as what is - and it isn't always clear at first which bits will be
important. 

The problem here is that --incremental doesn't provide the --re-add
functionality that you are depending on.  That was an oversight on my
part.  I'll see if I can get it fixed.
In the mean time, you'll need to use --re-add (or --add, it does the
same thing in your situation) to add nbd0 to the array.

NeilBrown


> 
> Prior to the reboot:
> 
> Dec 15 15:19:39 turnip kernel: md: md11: recovery done.
> Dec 15 15:19:39 turnip kernel: RAID1 conf printout:
> Dec 15 15:19:39 turnip kernel:  --- wd:2 rd:2
> Dec 15 15:19:39 turnip kernel:  disk 0, wo:0, o:1, dev:nbd0
> Dec 15 15:19:39 turnip kernel:  disk 1, wo:0, o:1, dev:sda
> 
> During booting:
> 
> <6>raid1: raid set md11 active with 1 out of 2 mirrors
> <6>md11: bitmap initialized from disk: read 1/1 pages, set 1 bits
> <6>created bitmap (10 pages) for device md11
> 
> After boot:
> 
> Dec 15 15:34:38 turnip kernel: md: bind<nbd0>
> Dec 15 15:34:38 turnip kernel: RAID1 conf printout:
> Dec 15 15:34:38 turnip kernel:  --- wd:1 rd:2
> Dec 15 15:34:38 turnip kernel:  disk 0, wo:1, o:1, dev:nbd0
> Dec 15 15:34:38 turnip kernel:  disk 1, wo:0, o:1, dev:sda
> Dec 15 15:34:38 turnip kernel: md: recovery of RAID array md11
> Dec 15 15:34:38 turnip kernel: md: minimum _guaranteed_  speed: 1000
> KB/sec/disk.
> Dec 15 15:34:38 turnip kernel: md: using maximum available idle IO
> bandwidth (but not more than 200000 KB/sec) for recovery.
> Dec 15 15:34:38 turnip kernel: md: using 128k window, over a total of
> 78123988 blocks.
> 
> /dev/nbd0 was added via --incremental (mdadm 3.0)
> 

From: Neil Brown <neilb@suse.de>
Subject: Re: Why is my raid 1 boot/root not working with autodetect?
Date: Fri, 19 Jun 2009 12:10:00 +1000
Message-ID: <19002.62328.200010.484984@notabene.brown>
References: <Pine.LNX.4.64.0906101828150.10333@deimos.nu>
	<Pine.LNX.4.64.0906111019350.9820@deimos.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Fredrik Pettersson on Thursday June 11
Sender: linux-raid-owner@vger.kernel.org
To: Fredrik Pettersson <freppe@deimos.nu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday June 11, freppe@deimos.nu wrote:
> I have done some more testing in an attempt to gather more data, and here 
> is what I have seen when testing different kernel options.
> 
> When booting with my normal kernel options I get the following md output 
> during the boot:
> 
> (raid=noautodetect md=0,/dev/sdb1,/dev/sdc1 md=d0,/dev/sdb2,/dev/sdc2)
> -----
> md: Skipping autodetection of RAID arrays. (raid=autodetect will force)
> md: Loading md0: /dev/sdb1
> md: bind<sdb1>
> md: bind<sdc1>
> raid1: raid set md0 active with 2 out of 2 mirrors
>   md0: unknown partition table
>   md0: unknown partition table
> md: Loading md_d0: /dev/sdb2
> md: bind<sdb2>
> md: bind<sdc2>
> raid1: raid set md_d0 active with 2 out of 2 mirrors
>   md_d0: p1 p2 p3 p4
>   md_d0: p1 p2 p3 p4
> -----
> 
> Everything is well and boots fine.
> 
> If I change try to use autodetect but still keep the md= definitions:
> 
> (raid=autodetect md=0,/dev/sdb1,/dev/sdc1 md=d0,/dev/sdb2,/dev/sdc2)
> -----
> md: Autodetecting RAID arrays.
> md: Scanned 4 and added 4 devices.
> md: autorun ...
> md: considering sdc2 ...
> md:  adding sdc2 ...
> md: sdc1 has different UUID to sdc2
> md:  adding sdb2
> md: sdb1 has different UUID to sdc2
> md: created md1
> md: bind<sdb2>
> md: bind<sdc2>
> md: running: <sdc2><sdb2>
> raid1: raid set md1 active with 2 out of 2 mirrors
> md: considering sdc1 ...
> md:  adding sdc1 ...
> md:  adding sdb1 ...
> md: created md0
> md: bind<sdb1>
> md: bind<sdc1>
> md: running: <sdc1><sdb1>
> raid1: raid set md0 active with 2 out of 2 mirrors
> md: ... autorun DONE.
> md: Loading md0: /dev/sdb1
>   md0: unknown partition table
> md: couldn't update array info. -22
> md: could not bd_claim sdb1.
> md: md_import_device returned -16
> md: could not bd_claim sdc1.
> md: md_import_device returned -16
> md: startind md0 failed
> md: Loading md_d0: /dev/sdb2
> md: could not bd_claim sdb2.
> md: md_import_device returned -16
> md: could not bd_claim sdc2.
> md: md_import_device returned -16
> md: starting md0 failed
> -----
> 
> In that case boot eventually fails with "mdadm: no devices found for 
> /dev/md_d0".

That is because autodetect gave it a different name.  The thing that
was md_d0 is now md1.  mdadm thinks md_d0 doesn't exist so it tried to
assemble it and failed.
the system then tries to mount things from /dev/md_d0p1 etc and that
fails too.

If you change fstab to mount from /dev/md1p1 etc it might work (since
2.6.28, all md devices are partitionable, you don't need the md_d*
ones).

However I recommend and you only use autodetect for the boot device,
and allow mdadm to assemble all the rest.
So change the partition type of sdc2 and sdb2 to something else
e.g. 0xDA.
Then auto-detect will ignore them, mdadm will find and assemble them,
and all with be happy.

NeilBrown

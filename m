From: Neil Brown <neilb@suse.de>
Subject: Re: Requesting replace mode for changing a disk
Date: Wed, 13 May 2009 20:51:34 +1000
Message-ID: <18954.42550.29885.82983@notabene.brown>
References: <4A060CBE.9090308@tmr.com>
	<20090513012112681.IEFQ19662@cdptpa-omta02.mail.rr.com>
	<18954.19719.172893.761454@notabene.brown>
	<37d33d830905122137l18f13c2aoec8e1cf67fdba2c0@mail.gmail.com>
	<18954.21141.982191.727975@notabene.brown>
	<37d33d830905122207pd676f00vac502f18d972dfae@mail.gmail.com>
	<b9218ba81e2428201586f3d740e7ad2f.squirrel@neil.brown.name>
	<37d33d830905122231p28e86b31y21ace4668d1697e7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from SandeepKsinha on Wednesday May 13
Sender: linux-raid-owner@vger.kernel.org
To: SandeepKsinha <sandeepksinha@gmail.com>
Cc: lrhorer@satx.rr.com, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wednesday May 13, sandeepksinha@gmail.com wrote:
> 
> Thanks but I am still confused. Here is what I see on the console.
> 
> 
> [10:55:16 sinhas]$ sudo mdadm -C /dev/md0 --level 1 -n 2 /dev/sda5 missing
> mdadm: /dev/sda5 appears to contain an ext2fs file system
>     size=19535008K  mtime=Sun Apr  5 21:34:00 2009
> mdadm: /dev/sda5 appears to be part of a raid array:
>     level=raid1 devices=2 ctime=Wed May 13 10:06:33 2009
> Continue creating array? y
> mdadm: RUN_ARRAY failed: Invalid argument
> mdadm: stopped /dev/md0

Odd.  Look for explanatory message in 'dmesg'.

NeilBrown

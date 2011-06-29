From: NeilBrown <neilb@suse.de>
Subject: Re: Can't start array and Negative "Used Dev Size"
Date: Wed, 29 Jun 2011 15:18:25 +1000
Message-ID: <20110629151825.56cb4499@notabene.brown>
References: <BANLkTincbuZrS3PuPBOgjidsR8jdyTGBRw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTincbuZrS3PuPBOgjidsR8jdyTGBRw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Simon Matthews <simon.d.matthews@gmail.com>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, 28 Jun 2011 21:29:37 -0700 Simon Matthews
<simon.d.matthews@gmail.com> wrote:

> Problem 1: "Used Dev Size"
> ====================
> Note: the system is a Gentoo box, so perhaps I have missed a kernel
> configuration option or use flag to deal with large hard drives.
> 
> A week or two ago, I resized a raid1 array using 2x3TB drives. I went

Oopps.  That array is using 0.90 metadata which can only handle up to 2TB
devices.  The 'resize' code should catch that you are asking the impossible,
but it doesn't it seems.

You need to simply recreate the array as 1.0.
i.e.
 mdadm -S /dev/md5
 mdadm -C /dev/md5 --metadata 1.0 -l1 -n2 --assume-clean

Then all should be happiness.
> 
> Problem 2: Can't start array
> ====================
> Whatever I do, I can't start md4:
> mdadm /dev/md4 --assemble
> mdadm: /dev/md4 is already in use.
> 
> /proc/mdadm:
> md4 : inactive sdc1[0](S)
>       58591232 blocks super 1.2

What do you get if you:

  mdadm -S /dev/md4
  mdadm -A /dev/md4 /dev/sdc1 /dev/sdd1 --verbose
??

NeilBrown


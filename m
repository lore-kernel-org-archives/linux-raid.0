From: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>
Subject: Re: How to create initrd.img to boot LVM-on-RAID0?
Date: Wed, 03 Oct 2007 19:55:47 +0200
Message-ID: <87myv0ccbg.fsf@informatik.uni-tuebingen.de>
References: <20071003171837.9A0481023D4@medulla.enet.sharplabs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20071003171837.9A0481023D4@medulla.enet.sharplabs.com> (Dean
	S. Messing's message of "Wed, 3 Oct 2007 10:18:37 -0700 (PDT)")
Sender: linux-raid-owner@vger.kernel.org
To: "Dean S. Messing" <deanm@sharplabs.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

"Dean S. Messing" <deanm@sharplabs.com> writes:

> I'm having the devil of a time trying to boot off
> an  "LVM-on-RAID0" device on my Fedora 7 system.
>
> I've created a software RAID-0, defined a Volume Group on in with
> (currently) a single logical volume, and copied my entire
> installation onto it, modifying the copied fstab to reflect where
> the new "/" is.
>
> I created a new initrd with:
>
> mkinitrd --preload raid0  --with=raid0 initrd_raid.img 2.6.22.5-76-fc7
>
> The LVM modules are getting included in the initrd "for free" because
> I'm currently running on a non-raid LV-managed file system.
>
> I added a stanza to grub.conf for the new initrd.img.
>
> But the thing won't complete the boot process.
>>From the boot messages it appears to not
> be starting the array, so when it goes to scan for LVs it doesn't
> find the one that's sitting on top of the array where root lives.

Maybe your lvm.conf filters it out or the devices are missing to
access it?

> Are there instructions for how to make this work?  I've googled for
> a couple of hours, tried a bunch of stuff, but can't get it to
> work.  From what I've read I suspect I must hand-tweek the "init"
> file in the initrd.
>
> Surely there is "a right way" to do this.

Install debian, live happily ever after. :)

By the way, why bother with raid0? lvm can do striping on its own
saving you one layer alltogether and you already have lvm working
right. Why needlessly add problems to your working system?

> (And, yes, my /boot partition is an ordinary device, not involved with
> the RAID0 or the LVs).
>
> Dean

MfG
        Goswin

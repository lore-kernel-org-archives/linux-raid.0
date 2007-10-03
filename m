From: "Dean S. Messing" <deanm@sharplabs.com>
Subject: Re: How to create initrd.img to boot LVM-on-RAID0?
Date: Wed,  3 Oct 2007 15:40:42 -0700 (PDT)
Message-ID: <20071003224042.7F90E1023DC@medulla.enet.sharplabs.com>
References: <20071003171837.9A0481023D4@medulla.enet.sharplabs.com> <87myv0ccbg.fsf@informatik.uni-tuebingen.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <87myv0ccbg.fsf@informatik.uni-tuebingen.de> (message from Goswin
	von Brederlow on Wed, 03 Oct 2007 19:55:47 +0200)
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Goswin von Brederlow wrote:
: "Dean S. Messing" <deanm@sharplabs.com> writes:
: 
: > I'm having the devil of a time trying to boot off
: > an  "LVM-on-RAID0" device on my Fedora 7 system.
: >
: > I've created a software RAID-0, defined a Volume Group on in with
: > (currently) a single logical volume, and copied my entire
: > installation onto it, modifying the copied fstab to reflect where
: > the new "/" is.
: >
: > I created a new initrd with:
: >
: > mkinitrd --preload raid0  --with=raid0 initrd_raid.img 2.6.22.5-76-fc7
: >
: > The LVM modules are getting included in the initrd "for free" because
: > I'm currently running on a non-raid LV-managed file system.
: >
: > I added a stanza to grub.conf for the new initrd.img.
: >
: > But the thing won't complete the boot process.
: >>From the boot messages it appears to not
: > be starting the array, so when it goes to scan for LVs it doesn't
: > find the one that's sitting on top of the array where root lives.
: 
: Maybe your lvm.conf filters it out or the devices are missing to
: access it?

I am not at a point in my meagre understanding to fool with it.

When I unpack the initrd, I see the raid modules but nothing in the
"init" script that activtates the array.  The lvm.conf file is the
default one..

: > Are there instructions for how to make this work?  I've googled for
: > a couple of hours, tried a bunch of stuff, but can't get it to
: > work.  From what I've read I suspect I must hand-tweek the "init"
: > file in the initrd.
: >
: > Surely there is "a right way" to do this.
: 
: Install debian, live happily ever after. :)

No comment.

: By the way, why bother with raid0? lvm can do striping on its own
: saving you one layer alltogether and you already have lvm working
: right. Why needlessly add problems to your working system?

I'm experimenting (and learning) right now.  I'm aware of the striped
lv option, which I will also try.  Thanks.

By the way the current system is working with LVM because at
installation time I told it to use LVM on the installed system.

Dean

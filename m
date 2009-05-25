From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: LVM->RAID->LVM
Date: Mon, 25 May 2009 14:32:39 +0200
Message-ID: <87iqjpqs60.fsf@frosties.localdomain>
References: <a43edf1b0905241131t7dcb3d85v98597f061a4345d6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <a43edf1b0905241131t7dcb3d85v98597f061a4345d6@mail.gmail.com>
	(Billy Crook's message of "Sun, 24 May 2009 13:31:07 -0500")
Sender: linux-raid-owner@vger.kernel.org
To: Billy Crook <billycrook@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Billy Crook <billycrook@gmail.com> writes:

> I use LVM on top of raid (between raid and the filesystem).  I chose
> that so I could export the LV's as iSCSI LUNs for different machines
> for different purposes.  I've been thinking lately though, about using
> LVM also, below raid (between the partitions and raid).  This could
> let me 'migrate out' a disk without degrading redundancy of the raid
> array, but I think it could get a little complicated.  Then again
> there was a day when I thought LVM was too complicating to be worth it
> at all.
>
> If anyone here has done an 'LVM->RAID->LVM sandwich' before, do you
> think it was worth it?  My understanding of LVM is that its overhead

I tried it once and gave it up again. The problem is that a raid
resync only uses idle I/O but any I/O on lvm gets flaged as the devcie
being used. As a result you consistently get the minimum resync speed
of 1MiB/s (or whatever you set it). Never more. And if you increase
the minimum speed it takes I/O away from when the devcie realy isn't
idle.

> is minimal, but would this amount of redirection start to be a
> problem?  What about detection during boot?  I assume if I did this,

Yuo need to ensure the lvm detection is run twice, or triggered after
each new block device passes through udev.

> I'd want a separate volume group for every raid component.  Each
> exporting only one LV and consuming only one PV until I want to move
> that component to another disk.  I'm using RHEL/CentOS 5.3 and most of
> my storage is served over iSCSI.  Some over NFS and CIFS.

You certainly don't want multiple PVs in a volume group as any disk
failure takes down the group (stupid userspace).

> What 'stacks' have you used from disk to filesystem, and what have
> been your experiences?  (Feel free to reply direct on this so this
> doesn't become one giant polling thread.)

Longest chain so far was:

sata -> raid -> dmcrypt -> lvm -> xen block device -> raid -> lvm -> ext3

That was for testing some raid stuff in a xen virtual domain. Only
reason I had to have raid twice so far.

MfG
        Goswin

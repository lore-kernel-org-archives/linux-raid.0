From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: RAID 5 recovery to not degrade device on bad block
Date: Mon, 24 Aug 2009 14:54:24 +0200
Message-ID: <87ws4t4bjz.fsf@frosties.localdomain>
References: <5c45fce80908230116o2f129ab4y8d255cbe83bfac5b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5c45fce80908230116o2f129ab4y8d255cbe83bfac5b@mail.gmail.com>
	(Anshuman Aggarwal's message of "Sun, 23 Aug 2009 13:46:10 +0530")
Sender: linux-raid-owner@vger.kernel.org
To: Anshuman Aggarwal <anshuman.aggarwal@gmail.com>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Anshuman Aggarwal <anshuman.aggarwal@gmail.com> writes:

> Here is a simple feature request which I assume would not be much
> logic change for kernel devs familiar with the code.
>
> Essentially, if I understand correctly, the kernel raid code will try
> to let the drive fix a bad sector and otherwise fail the device and
> degrade the array.
> However, if an array is already degraded then this behvaviour can be
> very limiting because typically you are in recovery mode and want to
> get as much data out to your new disk as you can.
>
> I would say that for an already degraded array, bad blocks should
> *NOT* by default cause a single bad block to fail the whole
> array...instead just log the bad blocks to the syslog and let the
> admin take care of it.

Big problem there.

As long as the raid is degrade a bad block can be reported to the
system as I/O error.

But consider what happens when you resync the drive and don't stop on
a bad block. The block on the new drive coresponding to the bad block
can not be initialized corectly. But a read of the bad block would
trigger the block to be recomputed from the remaining disks. Instead
of an I/O error you would get invalid data.

What would be needed is the ability to mark blocks as bad. Even with
bitmap support the bit cover too large an area.

> Right now, the big benefit of RAID5 is being affected
>
> Ideally, I'd like to see Neil's road map bad block device handler
> implemented (have often thought of tinkering with the block device
> code in the kernel to do just that)...but till then a simple check
> that an array is  degraded before failing a device which would render
> the whole array inoperable should suffice? This could throw big errors
> in the syslog but at least the a 2 TB MD array won't be down because
> of 1 512 byte sector?
>
> Thanks,
> Anshuman

MfG
        Goswin

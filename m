From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Can't resolve mismatch_count > 0 for a raid 1 array
Date: Wed, 08 Apr 2009 23:49:34 +0200
Message-ID: <87d4bmg6j5.fsf@frosties.localdomain>
References: <F87E9034-BDD7-4D74-8117-3ED1884D4165@openmedia.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <F87E9034-BDD7-4D74-8117-3ED1884D4165@openmedia.co.nz> (Steven
	Ellis's message of "Wed, 8 Apr 2009 22:03:32 +1200")
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Steven Ellis <steven@openmedia.co.nz> writes:

> I've resolved most of my raid issues by re-housing the affected system
> and replacing the motherboard, but across the 3 boards I've tried I
> always have an issue with my /dev/md1 array producing mismatch_count
> of 128 or 256.
>
> System is running Centos 5.2 with a Xen Dom0 kernel
>
> This md1 volume is a pair of 40GB HDs raid1 on an IDE controller which
> I them have a bunch of LVM's that are my Xen guests.
>
> Is there any chance that these mismatch_count values are due to swap
> partitions for the Xen guests?
>
> Steve

Have you repaired the raid or do you just check and check and check?

MfG
        Goswin

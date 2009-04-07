From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Recreate raid 10 array
Date: Tue, 07 Apr 2009 08:13:49 +0200
Message-ID: <87prfpdm8y.fsf@frosties.localdomain>
References: <49DA5CE6.7030902@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49DA5CE6.7030902@gmx.net> (LCID Fire's message of "Mon, 06 Apr
	2009 21:49:58 +0200")
Sender: linux-raid-owner@vger.kernel.org
To: LCID Fire <lcid-fire@gmx.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

LCID Fire <lcid-fire@gmx.net> writes:

> On my raid10 array (4 drives) I've had 2 drives (the same model) which
> got disconnected by the kernel (almost at the same time). It seems
> like both were one raid1 part so one half of the raid0 is missing.
> Afterwards I tried to readd the drives again (my bad) so now I'm stuck
> with 1 half of the raid0 part being present and valid and the other (2
> drives) marked as spare.
> The thing I'd like to do is:
> - Take 2 new drives (different manufacturers)
> - Clone one of the valid and one of the spare drives to the new drives
> - Try to reassemble the array.
> Problem is - is this even possible?
> How do I tell mdadm to not care about the spare state?
> Does the kernel write bogus data to the still valid drives if the
> other 2 fail?
>
> Would be great if someone could enlighten me ;)
>
> P.S.: Does someone know how to easily report the different sata errors
> which the kernel encounters?

mdadm --create --assume-clean -l 10 -n 4 /dev/mdX /dev/copied_disk_1 /dev/copied_disk2 missing missing

You need to match the create parameters exactly with the ones you
initially used (near/offset/farcopies? stripe size? ...) and the order
of devices is relevant so you might have to shuffle the disk
arguments. So just try different orders till the result can be mounted
or fscked. With the wrong options the mount/fsck could screw up the
data but then you copy the disk again for the next try. It should be
reasonably obvious when mount/fsck goes wrong as it should find tons
of errors. Mostly I would expect mount/fsck to just fail with the
wrong mdadm args though.

MfG
        Goswin

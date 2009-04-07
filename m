From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: [Patch] mdadm: move mdadm.map file into /dev/md
Date: Tue, 07 Apr 2009 23:04:30 +0200
Message-ID: <87myastbtt.fsf@frosties.localdomain>
References: <E2135ED2-AC92-48FE-843E-9E8C83B12729@redhat.com>
	<87tz51dmmu.fsf@frosties.localdomain>
	<20090407105520.GA29222@maude.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090407105520.GA29222@maude.comedia.it> (Luca Berra's message
	of "Tue, 7 Apr 2009 12:55:21 +0200")
Sender: linux-raid-owner@vger.kernel.org
To: LinuxRaid RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Luca Berra <bluca@comedia.it> writes:

> On Tue, Apr 07, 2009 at 08:05:29AM +0200, Goswin von Brederlow wrote:
>>Doug Ledford <dledford@redhat.com> writes:
>>
>>> Originally, mdadm used /var/run/mdadm/mdadm.map file to store the
>>> temporary mappings of incrementally added devices to device names.
>>> Unfortunately, this breaks incremental assembly if used early in the
>>> booting process.  Specifically, root may still be read only.  Since
>>> incremental assembly is largely a udev specific feature, and udev
>>> needs a writable /dev tmpfs mount even when root is still read only,
>>> it's safer to put our mdadm.map file in /dev/md so that we can write
>>> to the map file no matter how early in the boot process we are
>>> attempting to use incremental assembly.
>>
>>What about /lib/init/rw?
>
> What is that?, i never heard of '/lib/init/rw' before
>
> L.

At least under debian that is a tmpfs mounted in
/etc/rcS.d/S02mountkernfs.sh for programs that need to write somewhere
early in the boot process while potentially / is read-only and tmp and
var are still missing.

It even runs before /etc/rcS.d/S03udev.

MfG
        Goswin

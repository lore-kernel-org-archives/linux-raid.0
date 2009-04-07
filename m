From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: [Patch] mdadm: move mdadm.map file into /dev/md
Date: Tue, 07 Apr 2009 08:05:29 +0200
Message-ID: <87tz51dmmu.fsf@frosties.localdomain>
References: <E2135ED2-AC92-48FE-843E-9E8C83B12729@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <E2135ED2-AC92-48FE-843E-9E8C83B12729@redhat.com> (Doug Ledford's
	message of "Mon, 6 Apr 2009 10:52:10 -0400")
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: LinuxRaid RAID <linux-raid@vger.kernel.org>, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

Doug Ledford <dledford@redhat.com> writes:

> Originally, mdadm used /var/run/mdadm/mdadm.map file to store the
> temporary mappings of incrementally added devices to device names.
> Unfortunately, this breaks incremental assembly if used early in the
> booting process.  Specifically, root may still be read only.  Since
> incremental assembly is largely a udev specific feature, and udev
> needs a writable /dev tmpfs mount even when root is still read only,
> it's safer to put our mdadm.map file in /dev/md so that we can write
> to the map file no matter how early in the boot process we are
> attempting to use incremental assembly.

What about /lib/init/rw?

You say largely udev specific so there might not be an udev running
and no tmpfs on /dev.

MfG
        Goswin

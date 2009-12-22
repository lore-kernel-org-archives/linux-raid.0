From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: imsm woes (and a small bug in mdadm)
Date: Tue, 22 Dec 2009 16:57:49 -0700
Message-ID: <e9c3a7c20912221557p18bb5675ofb148af3164d7c9c@mail.gmail.com>
References: <20091222175128.GA18191@maude.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091222175128.GA18191@maude.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Dec 22, 2009 at 10:51 AM, Luca Berra <bluca@comedia.it> wrote:
> Note for Neil/Dan:
> This email could be long and boring, the attached patch prevents a
> segfault on 3.0.3 and 3.1.1, at least have a look at it.
>
> Hello,
> I have this system at home I use for dev/testing/leisure/whatever.
> it has an asus mb with an embedded intel 82801 sata fakeraid (imsm) with
> two WD10EADS 1T disks.
> I created a mirrored container with two volumes, first one windows the
> second linux.
> Yesterday windows crashed, no surprise there, the surprise was that
> after the crash the controller marked the first drive as failed, instead
> of running the usual verify.
> I readded the drive from the windows storage manager console, and since
> it told me rebuild would take 50+ hours i decided to leave it going.
> (the windows software is idiotic, it tries to rebuild both volumes in
> parallel)
> In the morning i found the drive failed rebuild, so i replaced it (will
> do some tests on it and rma when i have spare time).
> In order to avoid waiting 50 hours to see if it finished i decided to
> try rebuilding it under linux, the linux box used dmraid instead of
> mdadm and was obviously unable to boot (did i ever mention redhat/fedora
> mkinitrd sucks).

Things get better with dracut.

> I booted linux from a rescue cd and rebuilt the raid using mdadm 3.0.2.
> It took only 3 hours.
> now real trouble started
> After reboot the intel bios showed both drives as "Offline Member"
> back to the rescue cd. mdadm 3.0.2 activated the container but the two
> volumes were activated using only /dev/sda (NOTE: this is the new drive
> i put in this same morning, not the old one)
> Seeing that mdadm 3.0.3 had some fixes related to imsm i built that
> instead and tried activating the array. unfortunately it segfaulted,
> tried 3.1.1: same segfault
> fire gdb, bt
> found in super-intel.c around line 2430 a call to
> disk_list_get with the serial of /dev/sdb as first argument, which fails
> returning null.
> created the attached patch and rebuilt mdadm.
> still it activated the container with two drives and the volume with
> only one.
> i lost my patience and mdadm -r /dev/md/imsm0 /dev/sdb, mdadm -a ....
>
> it is now rebuilding
>
> i still have to see what bios thinks of the raid when i reboot
>

Everything looks back in order now, let me know if the bios/Windows
has any problems with it.

>
> attached, besides the patch are
> mdadm -Dsvv and mdadm -Esvv before and after the hot-remove-add, in case
> someone has an idea about what might had happened.
>

Thanks for the report.  I hit that segfault recently as well, and your
fix is correct.

Is sdb the drive you replaced, or the original drive?  The 'before'
record on sdb shows that it is a single disk array with only sda's
serial number in the disk list(?), it also shows that sda has a higher
generation number.  It looks like things are back on track with the
latest code because we selected sda (highest generation number),
omitted sdb because it was not part of sda's disk list, and modified
the family number to mark the rebuild as the bios expects.

The bios marked both disks as offline because they both wanted to be
the same family number, but they had no information about each other
in their records, so it needed user intervention to clear the
conflict.  It would have been nice to see the state of the metadata
after the crash, but before the old mdadm [1] touched it as I believe
that is where the confusion started.

--
Dan

[1]: http://git.kernel.org/?p=linux/kernel/git/djbw/mdadm.git;a=commitdiff;h=a2b9798159755b6f5e867fae0dd3e25af59fc85e

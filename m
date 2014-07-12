From: Phil Turmel <philip@turmel.org>
Subject: Re: Fwd: Recovering RAID5 array from multiple disk failure with different
 partition sizes
Date: Sat, 12 Jul 2014 12:01:09 -0400
Message-ID: <53C15BC5.2070208@turmel.org>
References: <CAK9uVk2tG073pDjpMA4QrHQVLm3y01L+WcxBzoPcTTC5DRoFTg@mail.gmail.com> <CAK9uVk1z1_Mrozm2syo-t6JPYh3ECY_F-fUQ4Rj1GWCDB7Pycg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAK9uVk1z1_Mrozm2syo-t6JPYh3ECY_F-fUQ4Rj1GWCDB7Pycg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Florian Spickenreither <florian.spickenreither@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Florian,

On 07/11/2014 09:43 AM, Florian Spickenreither wrote:
> Dear all,
> 
> I have a 4-disk RAID-5 array running here. While exchanging one faulty
> hard drive another harddisk failed about 18 hours later while the
> arrays were still resyncing. While two arrays could be saved by using
> the --assemble option, the 3rd of the three arrays running on these
> disks could not be started using this option.

The "another failed while resyncing a replacement" is a significant risk
when running raid5 on large drives.  You should seriously consider
adding a drive to make a raid6 (when you are out of trouble).

You don't mention trying --force with --assembly on the third array.  It
is precisely for this kind of situation, that is, telling mdadm to allow
assembly with a raid member that is known to have failed.

> I then tried my luck with recreating the array using --create
> --assume-clean as described in the RAID Wiki. It worked fine, however
> the size of the array was off and of course mounting the filesystem
> was not possible.

That means it did *not* work fine.  It is a good thing you kept an mdadm
--examine report from before the re-create, so we can see what happened.

[trim /]

> Disk Info from sdc2 before I recreated the array:
> /dev/sdc2:

>     Data Offset : 2048 sectors

> Disk info from sdf2 after I recreated the array:
> /dev/sdf2:

>     Data Offset : 262144 sectors

> As you can see the "Avail Dev Size" on sdf2 is less than on sd[cde]2
> which is causing my headaches.

When creating an array, the default value for data offset has changed a
few times over the history of mdadm.  If you assemble, or add, or
reshape, mdadm keeps the original array offset and things "just work".
When you use --create, the old arrangement is thrown away, and sizes can
be different.

 If I recreate the array using sd[cdf]2
> mdadm seems to use the smallest partition to calculate the size of the
> array and the array is useless. If I recreate the array using sd[cde]2
> the array size is identical to before the crash and I can mount the
> filesystem, however I get garbage as soon as a file involves sde2
> which is still not resynced.

It isn't just sde2.  The beginning of your filesystem is cut off with
the data offset you've ended up with.  That you can mount it at all is
surprising, and likely has done further damage.  (Mount is *not* a
read-only operation.)

> Any ideas how I can recreate the array successfully? mdadm tolerated
> the differences in size when I swapped sdf a long time ago and
> re-added the missing drive into the array. Would it be an option to
> increase the size of the partition sdf2 or is there another way?

You must do a --create --assume-clean again, using the data offset
option that's available in recent mdadm versions.  Or use the mdadm
version that originally created the array.  Use the "missing" keyword in
place of sde2 as its data cannot be trusted.

Do not attempt to --add and --resync yet.  The error that kicked during
resync will kick again and you'll be in the same place.  You should back
up any critical files while the array is mounted degraded.  (I'm going
to go out on a limb here and assume you don't have backups of some or
all of the contents...)

You should also examine your drives for proper raid support for error
recovery, as this scenario is dramatically more likely with consumer
drives.  You should google this list's archives for keywords like
"smartctl", "scterc", "URE", "device/timeout", and "timeout mismatch".

Once you are confident you understand the problem drive's error report,
you can attempt to fix it with "dd if=/dev/zero seek=? count=?
of=/dev/sdX2".  You'll lose a chunk of data, but you'll then be able to
finish a resync.

Phil


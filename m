From: pg@lxra2.for.sabi.co.UK (Peter Grandi)
Subject: Re: raid10n2/xfs setup guidance on write-cache/barrier
Date: Thu, 15 Mar 2012 23:00:41 +0000
Message-ID: <20322.29849.917554.794740@tree.ty.sabi.co.UK>
References: <CAA8mOyDKrWg0QUEHxcD4ocXXD42nJu0TG+sXjC4j2RsigHTcmw@mail.gmail.com>
	<4F61803A.60009@hardwarefreak.com>
	<CAA8mOyCzs36YD_QUMq25HQf8zuq1=tmSTPjYdoFJwy2Oq9sLmw@mail.gmail.com>
	<20321.63389.586851.689070@tree.ty.sabi.co.UK>
	<CAA8mOyCUCyzGCuNtn4txFuBtbk22M6LRpShNVH_Szb5=_F1PBw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAA8mOyCUCyzGCuNtn4txFuBtbk22M6LRpShNVH_Szb5=_F1PBw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>, Linux fs XFS <xfs@oss.sgi.com>
List-Id: linux-raid.ids

[ ... ]

>> Also, as a rule I want to make sure that the sector size is
>> set to 4096B, for future proofing (and recent drives not only
>> have 4096B sectors but usually lie).

> it seems the 1TB drivers that I have still have 512byte sectors

But usually you can still set the XFS idea of sector size to 4096,
which is probably a good idea in general.

[ ... ]

>>> is xfs going to be prone to more data loss in case the
>>> non-redundant power supply goes out?

>> That's the wrong question entirely. Data loss can happen for
>> many other reasons, and XFS is probably one of the safest
>> designs, if properly used and configured. The problems are
>> elsewhere.

> Can you please elaborate how xfs can be properly used and
> configured?

I did that in the following bits of the reply. You must be in a
real hurry if you cannot trim down the quoting or write your
comments after reading through once...

[ ... ]

>> But your insistence on power off and disk caches etc. seems to
>> indicate that "safety" in your mind means "when I click the
>> 'Save' button it is really saved and not partially".

> let me define safety as needed by the usecase: fileA is a 2MB
> open office document file already existing on the file system.
> userA opens fileA locally, modifies a lot of lines and attempts
> to save it. as the saving operation is proceeding, the PSU goes
> haywire and power is cut abruptly.

To worry you, if the PSU goes haywire, the disk data may become
subtly corrupted:

https://blogs.oracle.com/elowe/entry/zfs_saves_the_day_ta
 =ABAnother user, also running a Tyan 2885 dual-Opteron workstation
  like mine, had experienced data corruption with SATA disks. The
  root cause? A faulty power supply.=BB

Even if that is not an argument for filesystem provided checksums,
as the ZFS (and other) people say, but for end-to-end (application
level) ones.

> When the system is turned on, i expect some sort of recovery
> process to bring the filesystem to a consistent state.

The XFS design really cares about that and unless the hardware is
very broken metadata consistency will be good.

> I expect fileA should be as it was before the save operation and
> should not be corrupted in anyway.  Am I asking/expecting too much?

That is too much to expect of the filesystem and at the same time
too little.

It is too much because it is strictly the responsibility of the
application, and it is very expensive, because it can only happen
by simulating copy-on-write (app makes a copy of the document,
updates the copy, and then atomically renames it, and then makes
another copy). Some applications like OOo/LibreO/VIM instead use a
log file to record updates, and then merge those on save (copy,
merge, rename), which is better. Some filesystems like NILFS2 or
BTRFS or Next3/Next4 use COW to provide builtin versioning, but
that's expensive too. The original UNIX insight to provide a very
simple file abstraction layer should not be lightly discarded (but
I like NILFS2 in particular).

It is too little because of what happens if you have dozens to
thousands of modified but not yet fully persisted files, sych as
newly created mail folders, 'tar' unpacks , source tree checkins,
=2E..

As I tried to show in my previous reply, and in the NFS blog entry
mentioned in it too, on a creduly practical level relying on
applications doing the right thing is optimistic, and it may be
regrettably expedient to complement barriers with frequent system
driven flushing, which partially simulates (at a price) O_PONIES.

[ ... ]

>> Then Von Neuman help you if your users or you decide to store
>> lots of messages in MH/Maildir style mailstores, or VM images
>> on "growable" virtual disks.

> what's wrong with VM images on "growable" virtual disks. are you
> saying not to rely on lvm2 volumes?

By "growable" I mean that the virtual disk is allocated sparsely.

As to to LVM2 it is very rarely needed. The only really valuable
feature it has is snapshot LVs, and those are very expensive. XFS,
which can allocate routinely 2GiB (or bigger) files as a single
extents, can be used as a volume manager too.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Jessie Evangelista <jessie.evangelista@gmail.com>
Subject: Re: raid10n2/xfs setup guidance on write-cache/barrier
Date: Fri, 16 Mar 2012 11:36:07 +0800
Message-ID: <CAA8mOyC-xCcNxQFz-M1_TfnxcGBmpUdQ57_vYNVF11jhWK3SSA@mail.gmail.com>
References: <CAA8mOyDKrWg0QUEHxcD4ocXXD42nJu0TG+sXjC4j2RsigHTcmw@mail.gmail.com>
	<4F61803A.60009@hardwarefreak.com>
	<CAA8mOyCzs36YD_QUMq25HQf8zuq1=tmSTPjYdoFJwy2Oq9sLmw@mail.gmail.com>
	<20321.63389.586851.689070@tree.ty.sabi.co.UK>
	<CAA8mOyCUCyzGCuNtn4txFuBtbk22M6LRpShNVH_Szb5=_F1PBw@mail.gmail.com>
	<20322.29849.917554.794740@tree.ty.sabi.co.UK>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20322.29849.917554.794740@tree.ty.sabi.co.UK>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Grandi <pg@lxra2.for.sabi.co.uk>
Cc: Linux RAID <linux-raid@vger.kernel.org>, Linux fs XFS <xfs@oss.sgi.com>
List-Id: linux-raid.ids

> But usually you can still set the XFS idea of sector size to 4096,
> which is probably a good idea in general.

I'm now running kernel 3.0.0-16-server Ubuntu 10.04LTS
cat /sys/block/sd[b-d]/queue/physical_block_size shows 512
cat /sys/block/sd[b-d]/device/model shows ST31000524AS
looking up the model at seagate, the specs page does not mention 512
byte sectors
but it did mention guaranteed sectors of 1,953,525,168
multiplying by 512bytes we do get 1000204886016(1TBish)

Anyway, I'll have a look at setting the sector size for xfs

> I did that in the following bits of the reply. You must be in a
> real hurry if you cannot trim down the quoting or write your
> comments after reading through once...

I did read thru your comments several times and I really appreciate the=
m.
Will look into setting vm/dirty_bytes, vm/dirty_background_bytes,
vm/dirty_expire_centisecs, vm/dirty_writeback_centisecs.

I'm still scouring the internet for a best practice recipe for
implementing xfs/mdraid.
I am open to writing one and including the inputs everyone is contribut=
ing here.
In my search, I also saw some references of alignment issues for partit=
ions.
this is what I used to setup the partitions for the md device

sfdisk /dev/sdb <<EOF
unit: sectors

63,104872257,fd
0,0,0
0,0,0
0,0,0
EOF

I've read a recommendation to start the partition on the 1MB mark.
Does this make sense?

>> let me define safety as needed by the usecase: fileA is a 2MB
>> open office document file already existing on the file system.
>> userA opens fileA locally, modifies a lot of lines and attempts
>> to save it. as the saving operation is proceeding, the PSU goes
>> haywire and power is cut abruptly.
>
> To worry you, if the PSU goes haywire, the disk data may become
> subtly corrupted:
>
> https://blogs.oracle.com/elowe/entry/zfs_saves_the_day_ta
> =A0=ABAnother user, also running a Tyan 2885 dual-Opteron workstation
> =A0like mine, had experienced data corruption with SATA disks. The
> =A0root cause? A faulty power supply.=BB
>
> Even if that is not an argument for filesystem provided checksums,
> as the ZFS (and other) people say, but for end-to-end (application
> level) ones.

Mmmm, Ive also been reading up on ZFS but haven't put it thru its paces=
=2E

>> I expect fileA should be as it was before the save operation and
>> should not be corrupted in anyway. =A0Am I asking/expecting too much=
?
>
> That is too much to expect of the filesystem and at the same time
> too little.
>
> It is too much because it is strictly the responsibility of the
> application, and it is very expensive, because it can only happen
> by simulating copy-on-write (app makes a copy of the document,
> updates the copy, and then atomically renames it, and then makes
> another copy). Some applications like OOo/LibreO/VIM instead use a
> log file to record updates, and then merge those on save (copy,
> merge, rename), which is better. Some filesystems like NILFS2 or
> BTRFS or Next3/Next4 use COW to provide builtin versioning, but
> that's expensive too. The original UNIX insight to provide a very
> simple file abstraction layer should not be lightly discarded (but
> I like NILFS2 in particular).
>
> It is too little because of what happens if you have dozens to
> thousands of modified but not yet fully persisted files, sych as
> newly created mail folders, 'tar' unpacks , source tree checkins,
> ...
>
> As I tried to show in my previous reply, and in the NFS blog entry
> mentioned in it too, on a creduly practical level relying on
> applications doing the right thing is optimistic, and it may be
> regrettably expedient to complement barriers with frequent system
> driven flushing, which partially simulates (at a price) O_PONIES.

I'd like to read about the NFS blog entry but the link you included
results in a 404.
I forgot to mention in my last reply.

Based on what I understood from your thoughts above, if an
applications issues a flush/fsync
and it does not complete due to some catastrophic crash,
xfs on its own can not roll back to the prev version of the file in
case of unfinished write operation.
disabling the device caches wouldn't help either right?
only filesystems that do COW can do this at the expense of
performance? (btrfs and zfs, please hurry and grow up!)

> As to to LVM2 it is very rarely needed. The only really valuable
> feature it has is snapshot LVs, and those are very expensive. XFS,
> which can allocate routinely 2GiB (or bigger) files as a single
> extents, can be used as a volume manager too.

If you were in my place with the resource constraints, you'd go with:
xfs with barriers on top of mdraid10 with device cache ON and setting
vm/dirty_bytes, vm/dirty_background_bytes, vm/dirty_expire_centisecs,
vm/dirty_writeback_centisecs to safe values
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Ethan Tira-Thompson <ethan@tira-thompson.com>
Subject: Re: Removable mirror disks?
Date: Sun, 13 Oct 2013 23:06:49 -0700
Message-ID: <758E364B-66C2-402C-8A0B-02A2BF6012C0@tira-thompson.com>
References: <A9E6EB68-1FEC-4509-9357-2F62BC62AE84@tira-thompson.com> <525AA5DB.3010602@turmel.org>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <525AA5DB.3010602@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Oct 13, 2013, at 6:53 AM, Phil Turmel <philip@turmel.org> wrote:

> Good morning Ethan,
>=20
> On 10/12/2013 02:15 PM, Ethan Tira-Thompson wrote:
>> Hi all,
>>=20
>> I=92m setting up a raid mirror with two disks.  Ideally, I=92d like =
to do
>> this in such a way that I could stop the array, remove a drive, moun=
t
>> it directly on another machine as read-only (no RAID setup), and the=
n
>> put it back in the RAID and re-assemble as if nothing happened.  (Or
>> I could put a new drive in and keep the old one as a snapshot
>> backup.)  It=92s a maintenance option, not something I intend to do =
a
>> lot.
>>=20
>> Can I do this?  I=92ve tried creating a raid from the root block dev=
ice
>> (e.g. sdb) and then partitioning and formatting within the RAID, as
>> well as the opposite, partitioning the block device and making a rai=
d
>> of the partition.  Neither of these seems happy if I pull a drive an=
d
>> try to use it directly.  Is that due to the mdadm metadata
>> overwriting/offsetting the filesystem?  Would something like DDF
>> containers solve this?  Or if I shrink the filesystem on a partition
>> (leaving unused space on the partition) and then use metadata versio=
n
>> 1.0? (not sure I can do that, everything I=92ve seen resizes the
>> partition too)
>=20
> It is theoretically possible to do this, and even convenient to leave
> the main system running by appropriate use of a write-intent bitmap.
> However, you can't use mdadm to access the pulled drive, as it will b=
ump
> the event count and cause 'split-brain'.
>=20
> If you use metadata 0.9 or 1.0, you can mount the underlying device
> directly.  This is hazardous, even with a read-only mount, as
> filesystems generally do a mini-fsck on any mount (journal replay, et=
c).
> That makes the copy unusable in the original array.  The original arr=
ay
> has no way to figure out at re-insertion that this type of corruption
> has happened.
>=20
> So the practical answer is *no*, once you access the data on the pull=
ed
> drive.

Yup looks like it works cleanly with metadata 1.0, and thanks for the h=
eads up about the possibility of unexpected low-level writes if I use a=
 drive outside the array.  Hopefully I won=92t need to use it like this=
, but if so I=92ll treat it as a one-way export.

=46or those who follow on a search engine, my general process was:
1. partition drives (1 partition each)
2. mdadm --create /dev/md0 --metadata 1.0 --verbose --level=3Dmirror --=
raid-devices=3D2 /dev/sdd1 /dev/sde1
3. mdadm --detail --scan >> /etc/mdadm/mdadm.conf
4. mdadm -As
5. format /dev/md0
6. mount /dev/md0

Drive export test of /dev/sdd1:
1. mdadm --manage /dev/md0 --fail /dev/sdd1
(to ensure we don=92t let the drive rejoin the array later)
2. mdadm --manage /dev/md0 --remove /dev/sdd1
(maybe also mdadm --zero-superblock /dev/sdd1)
3. mount /dev/sdd1 (will have to pass -t to manually specify filesystem=
, otherwise it reports "unknown filesystem type =91linux_raid_member=92=
")
4. can now use the drive normally, but don=92t expect to put it back in=
 the array without a full reconstruction.

Thanks!
 -Ethan

>=20
>> An unrelated question: I=92ve heard some implementations RAID-1
>> mirroring will load balance reads between the disks at the process
>> level but not striping of reads within a thread?  How does linux rai=
d
>> handle this?  Seems like the kernel could stripe the read requests
>> regardless of being single threaded, but maybe there=92s some
>> complication of guaranteeing coherency with writes to each drive?
>=20
> Raid 1 just passes complete read requests through the block layer to =
one
> of the underlying devices, and write requests to all of the underlyin=
g
> devices.  So the load balancing happens at the level of complete
> requests.  If a process is multi-threaded and submitting multiple
> simultaneous requests, those will load balance.
>=20
> HTH,
>=20
> Phil

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

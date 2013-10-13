From: Phil Turmel <philip@turmel.org>
Subject: Re: Removable mirror disks?
Date: Sun, 13 Oct 2013 09:53:31 -0400
Message-ID: <525AA5DB.3010602@turmel.org>
References: <A9E6EB68-1FEC-4509-9357-2F62BC62AE84@tira-thompson.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A9E6EB68-1FEC-4509-9357-2F62BC62AE84@tira-thompson.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ethan Tira-Thompson <ethan@tira-thompson.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Good morning Ethan,

On 10/12/2013 02:15 PM, Ethan Tira-Thompson wrote:
> Hi all,
>=20
> I=E2=80=99m setting up a raid mirror with two disks.  Ideally, I=E2=80=
=99d like to do
> this in such a way that I could stop the array, remove a drive, mount
> it directly on another machine as read-only (no RAID setup), and then
> put it back in the RAID and re-assemble as if nothing happened.  (Or
> I could put a new drive in and keep the old one as a snapshot
> backup.)  It=E2=80=99s a maintenance option, not something I intend t=
o do a
> lot.
>=20
> Can I do this?  I=E2=80=99ve tried creating a raid from the root bloc=
k device
> (e.g. sdb) and then partitioning and formatting within the RAID, as
> well as the opposite, partitioning the block device and making a raid
> of the partition.  Neither of these seems happy if I pull a drive and
> try to use it directly.  Is that due to the mdadm metadata
> overwriting/offsetting the filesystem?  Would something like DDF
> containers solve this?  Or if I shrink the filesystem on a partition
> (leaving unused space on the partition) and then use metadata version
> 1.0? (not sure I can do that, everything I=E2=80=99ve seen resizes th=
e
> partition too)

It is theoretically possible to do this, and even convenient to leave
the main system running by appropriate use of a write-intent bitmap.
However, you can't use mdadm to access the pulled drive, as it will bum=
p
the event count and cause 'split-brain'.

If you use metadata 0.9 or 1.0, you can mount the underlying device
directly.  This is hazardous, even with a read-only mount, as
filesystems generally do a mini-fsck on any mount (journal replay, etc)=
=2E
 That makes the copy unusable in the original array.  The original arra=
y
has no way to figure out at re-insertion that this type of corruption
has happened.

So the practical answer is *no*, once you access the data on the pulled
drive.

> An unrelated question: I=E2=80=99ve heard some implementations RAID-1
> mirroring will load balance reads between the disks at the process
> level but not striping of reads within a thread?  How does linux raid
> handle this?  Seems like the kernel could stripe the read requests
> regardless of being single threaded, but maybe there=E2=80=99s some
> complication of guaranteeing coherency with writes to each drive?

Raid 1 just passes complete read requests through the block layer to on=
e
of the underlying devices, and write requests to all of the underlying
devices.  So the load balancing happens at the level of complete
requests.  If a process is multi-threaded and submitting multiple
simultaneous requests, those will load balance.

HTH,

Phil
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

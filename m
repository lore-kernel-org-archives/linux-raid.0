From: CoolCold <coolthecold@gmail.com>
Subject: Re: Removable mirror disks?
Date: Tue, 15 Oct 2013 20:18:50 +0400
Message-ID: <CAGqmV7r2VQdwgC38fiQJcGAK_fAEHo_YNH+GF99FzeisTv+Zhw@mail.gmail.com>
References: <A9E6EB68-1FEC-4509-9357-2F62BC62AE84@tira-thompson.com>
	<525AA5DB.3010602@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <525AA5DB.3010602@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Ethan Tira-Thompson <ethan@tira-thompson.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, Oct 13, 2013 at 5:53 PM, Phil Turmel <philip@turmel.org> wrote:
> Good morning Ethan,
>
> On 10/12/2013 02:15 PM, Ethan Tira-Thompson wrote:
>> Hi all,
>>
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
>>
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
>
> It is theoretically possible to do this, and even convenient to leave
> the main system running by appropriate use of a write-intent bitmap.
> However, you can't use mdadm to access the pulled drive, as it will b=
ump
> the event count and cause 'split-brain'.
>
> If you use metadata 0.9 or 1.0, you can mount the underlying device
> directly.  This is hazardous, even with a read-only mount, as
> filesystems generally do a mini-fsck on any mount (journal replay, et=
c).
>  That makes the copy unusable in the original array.  The original ar=
ray
> has no way to figure out at re-insertion that this type of corruption
> has happened.
>
> So the practical answer is *no*, once you access the data on the pull=
ed
> drive.
I'd say there is at least one way - you can use dm-setup to build
overlayed block device, from your disk (say sdb) and some
ramdrive/fs-based block device (losetup) - so reads will go to sdb,
writes will go to that ramdrive, original device will be untouched.
More info can be found here
https://www.kernel.org/doc/Documentation/device-mapper/snapshot.txt
and here http://unix.stackexchange.com/questions/35286/how-to-create-a-=
snapshot-of-a-physical-disk

>
>> An unrelated question: I=92ve heard some implementations RAID-1
>> mirroring will load balance reads between the disks at the process
>> level but not striping of reads within a thread?  How does linux rai=
d
>> handle this?  Seems like the kernel could stripe the read requests
>> regardless of being single threaded, but maybe there=92s some
>> complication of guaranteeing coherency with writes to each drive?
>
> Raid 1 just passes complete read requests through the block layer to =
one
> of the underlying devices, and write requests to all of the underlyin=
g
> devices.  So the load balancing happens at the level of complete
> requests.  If a process is multi-threaded and submitting multiple
> simultaneous requests, those will load balance.
>
> HTH,
>
> Phil
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



--=20
Best regards,
[COOLCOLD-RIPN]
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

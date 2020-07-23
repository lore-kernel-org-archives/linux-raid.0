From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Linux RAID with btrfs stuck and consume 100 % CPU
Date: Wed, 22 Jul 2020 20:08:30 -0600
Message-ID: <CAJCQCtSfz+b38fW3zdcHwMMtO1LfXSq+0xgg_DaKShmAumuCWQ@mail.gmail.com>
References: <d3fced3f-6c2b-5ffa-fd24-b24ec6e7d4be@xmyslivec.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <d3fced3f-6c2b-5ffa-fd24-b24ec6e7d4be@xmyslivec.cz>
Sender: linux-raid-owner@vger.kernel.org
To: Vojtech Myslivec <vojtech@xmyslivec.cz>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>, Linux-RAID <linux-raid@vger.kernel.org>, Michal Moravec <michal.moravec@logicworks.cz>
List-Id: linux-raid.ids

On Wed, Jul 22, 2020 at 2:55 PM Vojtech Myslivec <vojtech@xmyslivec.cz> wrote:
>
> This host serves as a backup server and it runs regular backup tasks.
> When a backup is performed, one (read only) snapshot of one of my
> subvolumes on the btrfs filesystem is created and one snapshot is
> deleted afterwards.

This is likely to be a decently metadata centric workflow, lots of
small file changes, and metadata (file system) changes. Parity raid
performance in such workloads is often not great. It's just the way it
goes. But what does iostat tell you about drive utilization during
these backups? And during the problem? Are they balanced? Are they
nearly fully utilized?



>
> Once in several days (irregularly, as I noticed), the `md1_raid6`
> process starts to consume 100 % of one CPU core and during that time,
> creating a snapshot (during the regular backup process) of a btrfs
> subvolume get stucked. User space processes accessing this particular
> subvolume then start to hang in *disk sleep* state. Access to other
> subvolumes seems to be unaffected until another backup process tries to
> create another snapshot (of different subvolume).

Snapshot results in flush. And snapshot delete result in btrfs-cleaner
process, which involves a lot of reas and writes to track down the
extents to be freed. But your call traces seem stuck in snapshot
creation.

Can you provide mdadm -E and -D output respectively? I wonder if the
setup is just not well suited for the workload. Default mdadm 512KiB
chunk may not align well with this workload.

Also, a complete dmesg might be useful.



>
> In most cases, after several "IO" actions like listing files (ls),
> accessing btrfs information (`btrfs filesystem`, `btrfs subvolume`), or
> accessing the device (with `dd` or whatever), the filesystem gets
> magically unstucked and `md1_raid6` process released from its "live
> lock" (or whatever it is cycled in). Snapshots are then created as
> expected and all processes finish their job.
>
> Once in a week approximately, it takes tens of minutes to unstuck these
> processes. During that period, I try to access affected btrfs subvolumes
> in several shell sessions to wake it up.

Could be lock contention on the subvolume.


> However, there are some more "blocked" tasks, like `btrfs` and
> `btrfs-transaction` with call trace also included.
>
>
> Questions
> =========
>
> 1. What should be the cause of this problem?
> 2. What should I do to mitigate this issue?
> 3. Could it be a hardware problem? How can I track this?

Not sure  yet. Need more info.

dmesg
mdadm -E
mdadm -D
btrfs filesystem usage /mountpoint
btrfs device stats /mountpoint

> What I have done so far
> =======================
>
> - I keep the system up-to-date, with latest stable kernel provided by
>   Debian packages

5.5 is fairly recent and OK. It should be fine, except you're having a
problem, so...it could be a bug that's fixed already or a new bug. Or
it could be suboptimal configuration for the workload - which can be
difficult to figure out.

>
> - I run both `btrfs scrub` and `fsck.btrfs` to exclude btrfs filesystem
>   issue.
>
> - I have read all the physical disks (with dd command) and perform SMART
>   self tests to exclude disks issue (though read/write badblocks were
>   not checked yet).

I wouldn't worry too much about badblocks. More important is
https://raid.wiki.kernel.org/index.php/Timeout_Mismatch

But you report using enterprise drives. They will invariably have an
SCT ERC time of ~70 deciseconds, which is well below that of the
kernel's SCSI command timer, ergo not a problem. But it's fine to
double check that.


> - I have also moved all the files out of the affected filesystem, create
>   a new btrfs filesystem (with recent btrfs-progs) and moved files
>   back. This issue, none the less, appeared again.

Exactly the same configuration? Anything different at all?


>
> - I have tried to attach strace to cycled md1 process, but
>   unsuccessfully (is it even possible to strace running kernel thread?)

You want to do 'cat /proc/<pid>/stack'


> Some detailed facts
> ===================
>
> OS
> --
>
> - Debian 10 buster (stable release)
> - Linux kernel 5.5 (from Debian backports)
> - btrfs-progs 5.2.1 (from Debian backports)

btrfs-progs 5.2.1 is ok, but I suggest something newer before using
'btrfs check --repair'. Just to be clear --repair is NOT indicated
right now.


> Hardware
> --------
>
> - 8 core/16 threads amd64 processor (AMD EPYC 7251)
> - 6 SATA HDD disks (Seagate Enterprise Capacity)
> - 2 SSD disks (Intel D3-S4610)

It's not related, but your workload might benefit from
'compress=zstd:1' mount option. Compress everything across the board.
Chances are these backups contain a lot of compressible data. This
isn't important to do right now. Fix the problem first. Optimize
later. But you have significant CPU capacity relative to the hardware.


> btrfs
> -----
> - Several subvolumes, tens of snapshots
> - Default mount options: rw,noatime,space_cache,subvolid=5,subvol=/
> - No compression, autodefrag or so
> - I have tried to use quotas in the past but they are disabled for
>   a long time

I don't think this is the only thing going on, but consider
space_cache=v2. You can mount with '-o clear_cache'  then umount and
then mount again with 'o space_cache=v2' to convert. And it will be
persistent (unless invalidated by a repair and then default v1 version
is used again). v2 will soon be the default.




>
> Usage
> -----
>
> - Affected RAID6 block device is directly formatted to btrfs
> - This filesystem is used to store backups
> - Backups are performed via rsnapshot
> - rsnapshot is configured to use btrfs snapshots for hourly and daily
>   backups and rsync to copy new backups

How many rsnapshot and rsync tasks are happening concurrently for a
subvolume at the time the  subvolume becomes unresponsive?




-- 
Chris Murphy

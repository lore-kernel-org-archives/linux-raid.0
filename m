From: hansbkk@gmail.com
Subject: Re: [linux-lvm] Q: LVM over RAID, or plain disks? A:"Yes" = best of
 both worlds?
Date: Tue, 30 Nov 2010 12:20:46 +0700
Message-ID: <AANLkTim67atrgHEzunBRvp4ij+MUDiTg4vu5t6sbgFLq@mail.gmail.com>
References: <AANLkTimTYse7vnqZydc1Z5z60vNuQw3juj7J_W7+bQEm@mail.gmail.com>
	<AANLkTimGkMJGiJC+7L+Pu3+yf-J_s0Ex3hM2-g-0+UqQ@mail.gmail.com>
	<4CF3F7A0.2080108@rjl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4CF3F7A0.2080108@rjl.com>
Sender: linux-raid-owner@vger.kernel.org
To: Nataraj <incoming-redhat@rjl.com>
Cc: linux-raid@vger.kernel.org, linux-lvm@redhat.com
List-Id: linux-raid.ids

On Tue, Nov 30, 2010 at 1:57 AM, Nataraj <incoming-redhat@rjl.com> wrote:
> Your proposed solution is a bit confusing to understand,

Thanks for taking the time to give me feedback! And sorry I couldn't
make it clearer, but if the diagram is pasted into a monospace screen
it becomes more so - duplicated below.

The key is that I want to RAID1 from a given **LV** within the
TopRAID1 set to regular partitions on physical disks on the TopRAID2
side.

> however raid1 works for doing backups in the manner that you describe .
> I use it myself and I
> have, over time read about others doing so as well.  Be sure to create your
> volumes with --bitmap=internal, that way when you swap in a drive, it won't
> need to replicate the entire drive, only the part that is changed.

TopRAID1's LVM is likely to be running over a RAID6 set , so I'm not
depending on the TopRAID mirroring for reliability, just using it for
the above volume cloning.

When TopRAID1 is running with the TopRAID2 side marked faulty or
missing, will there be a performance hit or other negative
consequences?

If so, would it be possible/better for the host In normal operations
to mount the underlying LV directly rather than the degraded top-level
RAID1?

Obviously I'm asking the whole list here, not just Nataraj :)


> If your not going to manage the drives yourself, you will need an operations
> staff that has a pretty good understanding of how raid works and/or possibly
> write a robust set of scripts to manage the drives, ensure that the correct
> volume is mounted, etc.

Just me, and I'm sure my understanding will grow over time :)

We're not keeping archive sets of the drives themselves, rather
managing the archives created by BackupPC/rsnapshot/rdiff-backup and
Amanda, keeping them "live" in the disk sets discussed here, each in
its own LV(s), which data is constantly being refreshed onto the
rotating drives through the RAID re-mirroring process.

> Also, I don't personally feel that disks are a
> suitable media for long term data archival, so if that is really your
> purpose, as opposed to a quick way to recover from a disk failure, then you
> might consider doing periodic tape or optical media backups as well.

Remember we're talking about tens of terabytes here! I do also make
occasional DVD runs of key data sets + 20% PAR2s, but even then, I'm
not counting on these lasting more than 3 years, maybe 5 if I use
well-recommended media (checking the media ID). If we could afford
Verbatim "archive quality" I'd probably invest in a tape unit.

I just keep in mind Mr Keynes' "In the long run, we're all dead."

Thanks to all for your help!

----------------------------------------------

Repeat of conceptual diagram, best viewed with a monospaced font

"TopRAID1" side - LV's within a VG running on a RAID6 set
 ______________________________________
|                LVM VG                |
|  _____   _____________   __________  |
| | LV1 | |     LV2     | |    LV3   | |
| |     | |             | |          | |
| |     | |             | |          | |
| |     | |             | |          | |
| |     | |             | |          | |
| |     | |             | |          | |
| |_____| |_____________| |__________| |
|____v___________v______________v______|
    v           v              v
    v           v              v
  RAID1       RAID1          RAID1
    v           v              v
  __v__   ______v______   _____v____
 | HD1 | |     HD2     | |    HD3   |
 |     | |             | |          |
 |     | |             | |          |
 |     | |             | |          |
 |     | |             | |          |
 |     | |             | |          |
 |_____| |_____________| |__________|

"TopRAID2" side - regular partitions on physical disks

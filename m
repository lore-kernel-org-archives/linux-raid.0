From: hansbkk@gmail.com
Subject: Re: [linux-lvm] Q: LVM over RAID, or plain disks? A:"Yes" = best of
 both worlds?
Date: Tue, 30 Nov 2010 14:34:05 +0700
Message-ID: <AANLkTing5ApAXM2o0M+pxNvg01mHewNgGGBiUXM3aLzZ@mail.gmail.com>
References: <AANLkTimTYse7vnqZydc1Z5z60vNuQw3juj7J_W7+bQEm@mail.gmail.com>
	<AANLkTimGkMJGiJC+7L+Pu3+yf-J_s0Ex3hM2-g-0+UqQ@mail.gmail.com>
	<4CF3F7A0.2080108@rjl.com>
	<AANLkTim67atrgHEzunBRvp4ij+MUDiTg4vu5t6sbgFLq@mail.gmail.com>
	<4CF4A472.20107@rjl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4CF4A472.20107@rjl.com>
Sender: linux-raid-owner@vger.kernel.org
To: Nataraj <incoming-centos@rjl.com>
Cc: linux-raid@vger.kernel.org, linux-lvm@redhat.com
List-Id: linux-raid.ids

On Tue, Nov 30, 2010 at 2:14 PM, Nataraj <incoming-centos@rjl.com> wrot=
e:
>> TopRAID1's LVM is likely to be running over a RAID6 set , so I'm not
>> depending on the TopRAID mirroring for reliability, just using it fo=
r
>> the above volume cloning.
>
> Your raid 1 backups won't mirror any snapshots of your LV's unless yo=
u
> specifically setup mirroring of the snapshots after they exist.

Ah, getting clearer to me, I was thinking I'd be mirroring the LV
itself, but you're right, taking a snapshot and mirroring that is a
much better idea.

So here's a summary of steps, please confirm:
  - create a snapshot of a given volume
  - create a new RAID1 mdN between that and a physical partition (blank=
?)
  - let that get sync'd up
  - break the RAID (fail the partition?), remove the drive
  - delete the snapshot

The below is less clear to me, especially if the above is correct:

>> If so, would it be possible/better for the host In normal operations
>> to mount the underlying LV directly rather than the degraded top-lev=
el
>> RAID1?
>
> No, you want to have mdadm assemble the raid volume, even if in degra=
ded
> mode with only one drive and then access the LV on top of the md devi=
ce.
> =A0Even if you were able to mount the LV and bypass raid, that would =
be
> pointless because you would not update the bitmap and superblock and =
the
> integrety of the raid set would be lost.

During normal operations - when I'm not in the process of taking a
RAID-backup of my LV snapshot - it seems to me that the "Top-RAID" mdN
doesn't even exist right? It's set up to mirror between a snapshot and
a regular partition, both of which don't even exist during these
normal operations.

Therefore during normal operations the host *is* mounting the LV
directly, not via the "Top-RAID"mdN.

I wasn't talking about accessing the "Bottom-RAID" which creates the
underlying PV - this is transparent to LVM anyway, right?

Thanks again for your help (or in advance to anyone else who would
like to chime in)
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

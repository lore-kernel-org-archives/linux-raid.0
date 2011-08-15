From: Phil Turmel <philip@turmel.org>
Subject: Re: Rotating RAID 1
Date: Mon, 15 Aug 2011 16:19:41 -0400
Message-ID: <4E497F5D.7000306@turmel.org>
References: <CALJXSJq6bDoWhSY3jQa8scpMo4QzHPzUvVPnHbox=xXYPm877w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CALJXSJq6bDoWhSY3jQa8scpMo4QzHPzUvVPnHbox=xXYPm877w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi J=C3=A9r=C3=B4me,

On 08/15/2011 03:56 PM, J=C3=A9r=C3=B4me Poulin wrote:
> Then what is different about a standard RAID1, I removed sdb and
> replaced it with a brand new disk, copied the partition template from
> the other one and added the new disk using mdadm -a on both arrays, i=
t
> synced and works, then swapping the other disk back only rebuilds
> according to the bitmap, however sometimes it appears to make a full
> rebuild which is alright. However once, after a day of modifications
> and weeks after setting-up this RAID, at least 100 GB, it took second=
s
> to rebuild and days later it appeared to have encountered corruption,
> the kernel complained about bad extents and fsck found errors in one
> of the file I know it had modified that day.

This is a problem.  MD only knows about two disk.  You have three.  Whe=
n two disks are in place and sync'ed, the bitmaps will essentially stay=
 cleared.

When you swap to the other disk, its bitmap is also clear, for the same=
 reason.  I'm sure mdadm notices the different event counts, but the cl=
ear bitmap would leave mdadm little or nothing to do to resync, as far =
as it knows.  But lots of writes have happened in the meantime, and the=
y won't get copied to the freshly inserted drive.  Mdadm will read from=
 both disks in parallel when there are parallel workloads, so one workl=
oad would get current data and the other would get stale data.

If you perform a "check" pass after swapping and resyncing, I bet it fi=
nds many mismatches.  It definitely can't work as described.

I'm not sure, but this might work if you could temporarily set it up as=
 a triple mirror, so each disk has a unique slot/role.

It would also work if you didn't use a bitmap, as a re-inserted drive w=
ould simply be overwritten completely.

> So the question is; Am I right to use md-raid to do this kind of
> stuff, rsync is too CPU heavy for what I need and I need to stay
> compatible with Windows thus choosing metadata 1.0.

How do you stay compatible with Windows?  If you let Windows write to a=
ny of these disks, you've corrupted that disk with respect to its peers=
=2E  Danger, Will Robinson!

HTH,

Phil
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

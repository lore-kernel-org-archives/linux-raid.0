From: danci@agenda.si
Subject: Re: "failed-disk" ?
Date: Tue, 25 Mar 2003 15:12:20 +0100 (CET)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0303251453520.31592-100000@duplo.agenda.si>
References: <20030324143458.GB683@rdlg.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20030324143458.GB683@rdlg.net>
To: "Robert L. Harris" <Robert.L.Harris@rdlg.net>
Cc: Linux-Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, 24 Mar 2003, Robert L. Harris wrote:

>   I'm at the point of trying to restart /dev/md0 with one mirror dead.
> My raidtab looks like this:
>
> raiddev /dev/md0
>   raid-level 1
>   nr-raid-disks 2
>   nr-spare-disks 0
>   chunk-size 16
>   persistent-superblock 1
>   device /dev/lvm-vg1/lvm1
>   raid-disk 0
>   device /dev/lvm-vg2/lvm2
>   raid-disk 1
>
> I changed the first raid-disk line to be:
>   failed-disk 0

I'm not sure if this is your problem, but the Software RAID How-To says:

"Don't put the failed-disk as the first disk in the raidtab, that will
give you problems with starting the RAID. Create the RAID, and put a
filesystem on it."

It may be that SW RAID cannot really use LVMs. It is usually the
other way around (LVM using RAID arrays).

  D.


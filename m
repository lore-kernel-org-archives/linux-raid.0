From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: LVM RAID1 syncing component
Date: Mon, 24 Nov 2014 23:07:32 -0500
Message-ID: <alpine.DEB.2.02.1411242255300.12886@jlaw-desktop.mno.stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Joe Lawrence <joe.lawrence@stratus.com>
List-Id: linux-raid.ids

Does anyone know how its possible to determine which side of an LVM RAID 1 
is the stale partner during RAID resync?

In ordinary MD RAID, I believe you can check 
/sys/block/md0/md/dev-XXX/state, but LVM RAID seems to hide those files 
when leveraging the MD code.  I've looked though pvs/vgs/lvs manpages, but 
can't figure anything out there either.

Thanks,

-- Joe

From: Chris Murphy <lists@colorremedies.com>
Subject: Re: LVM RAID1 syncing component
Date: Tue, 25 Nov 2014 22:42:38 -0700
Message-ID: <CAJCQCtQauJQkKjYL6-hxYkquCHL2yXSo4034jfiJxUPO7Nw2dQ@mail.gmail.com>
References: <alpine.DEB.2.02.1411242255300.12886@jlaw-desktop.mno.stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1411242255300.12886@jlaw-desktop.mno.stratus.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Nov 24, 2014 at 9:07 PM, Joe Lawrence <joe.lawrence@stratus.com> wrote:
> Does anyone know how its possible to determine which side of an LVM RAID 1
> is the stale partner during RAID resync?
>
> In ordinary MD RAID, I believe you can check
> /sys/block/md0/md/dev-XXX/state, but LVM RAID seems to hide those files
> when leveraging the MD code.  I've looked though pvs/vgs/lvs manpages, but
> can't figure anything out there either.

Rather indirectly: iotop which will show you which devices are mostly
being read from and written to.

# lvs -a -o copy_percent
Anything less than 100% is syncing. I think.

-- 
Chris Murphy

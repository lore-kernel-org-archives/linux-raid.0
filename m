From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: Two degraded mirror segments recombined out of sync for massive
	data loss
Date: Wed, 7 Apr 2010 14:21:42 -0700
Message-ID: <r2v4877c76c1004071421o14e66ae5s35b0bf0914fb737c@mail.gmail.com>
References: <4BBCEEEC.4030606@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BBCEEEC.4030606@cfl.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Phillip Susi <psusi@cfl.rr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Apr 7, 2010 at 1:45 PM, Phillip Susi <psusi@cfl.rr.com> wrote:
> The gist of the problem is this: after booting a mirror in degraded m=
ode
> with only the first disk, then doing the same with only the second di=
sk,
> then booting with both disks again, mdadm happily recombines the two
> disks out of sync, causing two divergent filesystems to become munged
> together.
>
> The problem was initially discovered testing the coming lucid release=
 of
> Ubuntu doing clean installs in a virtualization environment, and I ha=
ve
> reproduced it manually activating and deactivating the array built ou=
t
> of two lvm logical volumes under Karmic. =A0What seems to be happenin=
g is
> that when you activate in degraded mode ( mdadm --assemble --run ), t=
he
> metadata on the first disk is changed to indicate that the second dis=
k
> was faulty and removed. =A0When you activate with only the second dis=
k,
> you would think it would say the first disk was faulty, removed, but =
for
> some reason it ends up only marking it as removed, but not faulty. =A0=
Now
> both disks are degraded.
>
> When mdadm --incrmental is run by udev on the first disk, it happily
> activates it since the array is degraded, but has one out of one acti=
ve
> member present, with the second member faulty,removed. =A0When mdadm
> --incremental is run by udev on the second disk, it happily slips the
> disk into the active array, WITHOUT SYNCING.
>
> My two questions are:
>
> 1) When doing mdadm --assemble --run with only the second disk presen=
t,
> shouldn't it mark the first disk as faulty, removed instead of only r=
emoved?
>
> 2) When mdadm --incremental is run on the second disk, shouldn't it
> refuse to use it since the array says the second disk is faulty, remo=
ved?
>
> The bug report related to this can be found at:
>
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/557429
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

It sounds like the last 'synced' time should be tracked, as well as
the last modification time. If the two differ then it can be known
that the contents has diverged since last sync.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: RAID scrubbing
Date: Fri, 9 Apr 2010 18:41:21 -0700
Message-ID: <l2t4877c76c1004091841n40a6ad69gb9f73c9d1b68f4ae@mail.gmail.com>
References: <q2s150c16851004091828t235d2derf36033d19e2f11ad@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <q2s150c16851004091828t235d2derf36033d19e2f11ad@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Maggard <jmaggard10@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Apr 9, 2010 at 6:28 PM, Justin Maggard <jmaggard10@gmail.com> w=
rote:
> Hi all,
>
> I've got a system using two RAID5 arrays that share some physical
> devices, combined using LVM. =A0Oddly, when I "echo repair >
> /sys/block/md0/md/sync_action", once it finishes, it automatically
> starts a repair on md1 also, even though I haven't requested it.
> Also, if I try to stop it using "echo idle >
> /sys/block/md0/md/sync_action", a repair starts on md1 within a few
> seconds. =A0If I stop that md1 repair immediately, sometimes it will
> respawn and start doing the repair again on md1. =A0What should I be
> expecting here? =A0If I start a repair on one array, is it supposed t=
o
> automatically go through and do it on all arrays sharing that
> personality?
>
> Thanks!
> -Justin
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

Is md1 degraded with an active spare?  It might be delaying resync on
it until the other devices are idle.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

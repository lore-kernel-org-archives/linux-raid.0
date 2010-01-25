From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Swapping a disk without degrading an array
Date: Mon, 25 Jan 2010 18:40:52 +0100
Message-ID: <87d40yqdzv.fsf@frosties.localdomain>
References: <1264421475.30742.49.camel@test.apertos.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1264421475.30742.49.camel@test.apertos.eu> (Micha's message of
	"Mon, 25 Jan 2010 13:11:15 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Micha Sawicz <michal@sawicz.net>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Micha=C5=82 Sawicz <michal@sawicz.net> writes:

> Hi list,
>
> This is something I've discussed on IRC and we achieved a conclusion
> that this might be useful, but somewhat limited use-case count might =
not
> warrant the effort to be implemented.
>
> What I have in mind is allowing a member of an array to be paired wit=
h a
> spare while the array is on-line. The spare disk would then be filled
> with exactly the same data and would, in the end, replace the active
> member. The replaced disk could then be hot-removed without the array
> ever going into degraded mode.
>
> I wanted to start a discussion whether this at all makes sense, what =
can
> be the use cases etc.

I had that discussion last year with Neil. Summary: It totaly makes
sense, is not that hard to implement but doesn't have a high priority.

You sort of do it with 2 short downtimes. Shut down the raid, set up a
dm-mirror target, restart the raid, wait for the mirror to complete,
shutdown and undo the dm-mirror. Instead of dm-mirror you can also use =
a
superblock-less raid1. You get problems on a crash though unless the
superblock is mirrored last because then the wrong (incomplete) disk
might be added to the raid on boot.


Besides replacing a disk suspect of failing soon there is also a second
use case. Balancing the wear of the active and spare disks. If you buy =
6
new disks and create a 5 disks + spare raid 5 then the spare will remai=
n
unused while the remaining disks wear down. So every now and then it
would be nice to rotate the spare disk so the wear is distributed
better. This could be done in parallel with the monthly raid check,
where you read the full disk data and verify it anyway. Copying out one
disk to the spare at the same time and switching them at the end would
cost little extra (given enough controler bandwith it wouldn't even slo=
w
the check down).

MfG
        Goswin
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

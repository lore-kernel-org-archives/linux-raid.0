From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: Re: Split-Brain Protection for MD arrays
Date: Thu, 15 Dec 2011 16:29:12 +0200
Message-ID: <CAGRgLy7oCm87HRTK_FS6g80g5MQzSvto10T0PH0vE022XMsn-w@mail.gmail.com>
References: <CAGRgLy6=-naSGJw_tgiD5=ab7gWxyeQ2ysu-yCKa064Jih+cfA@mail.gmail.com>
	<20111215140252.2f9bb986@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111215140252.2f9bb986@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil,
thanks for the review, and for detailed answers to my questions.

> When we mark a device 'failed' it should stay marked as 'failed'. =A0=
When the
> array is optimal again it is safe to convert all 'failed' slots to
> 'spare/missing' but not before.
I did not understand all that reasoning. When you say "slot", you mean
index in the dev_roles[] array, correct? If yes, I don't see what
importance the index has, compared to the value of the entry itself
(which is "role" in your terminology).
Currently, 0xFFFE means both "failed" and "missing", and that makes
perfect sense to me. Basically this means that this entry of
dev_roles[] is unused. When a device fails, it is kicked out of the
array, so its entry in dev_roles[] becomes available.
(You once mentioned that for older arrays, their dev_roles[] index was
also their role, perhaps you are concerned about those too).
In any case, I will be watching for changes in this area, if you
decide to make them (although I think this might break backwards
compatibility, unless a new version of superblock will be used).

> If you have a working array and you initiate a write of a data block =
and the
> parity block, and if one of those writes fails, then you no longer ha=
ve a
> working array. =A0Some data blocks in that stripe cannot be recovered=
=2E
> So we need to make sure that admin knows the array is dead and doesn'=
t just
> re-assemble and think everything is OK.
I see your point. I don't know what's better: to know the "last known
good" configuration, or to know that the array has failed. I guess, I
am just used to the former.

> I think to resolve this issue we need 2 thing.
>
> 1/ when assembling an array if any device thinks that the 'chosen' de=
vice has
> =A0 failed, then don't trust that devices.
I think that if any device thinks that "chosen" has failed, then
either it has a more recent superblock, and then this device should be
"chosen" and not the other. Or, the "chosen" device's superblock is
the one that counts, then it doesn't matter what current device
thinks, because array will be assembled according to the "chosen"
superblock.

> 2/ Don't erase 'failed' status from dev_roles[] until the array is
> optimal.

Neil, I think both these points don't resolve the following simple
scenario: RAID1 with drive A and B. Drive A fails, array continues to
operate on drive B. After reboot, only drive A is accessible. If we go
ahead with assemble, we will see stale data. If after reboot, we,
however, see only drive A, then (since B is "faulty" in A's
superblock), we can go ahead and assemble. The change I suggested will
abort in the first case, but will assemble in the second case.

But obviously, you know better what MD users expect and want.
Thanks again for taking time and reviewing the proposal! And yes, next
time, I will put everything in the email.

Alex.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Bodo Eggert
	<arcoristkaputtundbrauchtdiesentext.7eggert@nurfuerspam.de>
Subject: Re: [PATCH] md: Remove risk of overflow via sprintf) by using snprintf()  in md_check_recovery()
Date: Sun, 13 Feb 2011 21:53:21 +0100
Message-ID: <E1Poiwb-0002rc-Lm@be1.7eggert.dyndns.org>
References: <gl8SB-1hb-11@gated-at.bofh.it> <glk7o-3l2-17@gated-at.bofh.it> <glo1k-1AX-17@gated-at.bofh.it>
Reply-To: 7eggert@nurfuerspam.de
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>, "Daniel K." <dk@uw.no>, Jesper Juhl <jj@chaosbits.net>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, Neil Brown <neilb@suse.de>Neil
List-Id: linux-raid.ids

Michael Tokarev <mjt@tls.msk.ru> wrote:
> 12.02.2011 12:34, Daniel K. wrote:
>> Jesper Juhl wrote:

>>> sprintf() is dangerous - given the wrong source string it will
>>> overflow the destination. snprintf() is safer in that at least we'l=
l
>>> never overflow the destination. Even if overflow will never happen
>>> today, code changes over time and snprintf() is just safer in the l=
ong
>>> run.
>>
>>> -                        sprintf(nm,"rd%d", rdev->raid_disk);
>>> +                        snprintf(nm, sizeof(nm), "rd%d",
>>> rdev->raid_disk);
>>>                          sysfs_remove_link(&mddev->kobj, nm);

> C'mon guys, this is pointless.  20 bytes allocated for the device
> name, and this is for raid disk number.  It is impossible to have
> more than 10^17 (20 bytes total, 2 for "rd" and on for the zero
> terminator) drives in a single array.

If you argue that you might get a buffer overflow, you'll have to check
for snprintf errors, too.
--=20
Logic: The art of being wrong with confidence...=20

=46ri=C3=9F, Spammer: tR@c.7eggert.dyndns.org S5xk@h.7eggert.dyndns.org
 loqnjg@GFhzy.7eggert.dyndns.org 6hs4Axaqf@ndlJ.7eggert.dyndns.org

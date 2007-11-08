From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: 2.6.23.1: mdadm/raid5 hung/d-state
Date: Thu, 8 Nov 2007 07:44:36 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0711080744070.575@p34.internal.lan>
References: <Pine.LNX.4.64.0711040658180.30831@p34.internal.lan>
 <18222.16003.92062.970530@notabene.brown> <472ED613.8050101@systella.fr>
 <4731EA2B.5000806@redhat.com> <4731EC64.3050903@systella.fr>
 <4732F643.9030507@systella.fr>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463747160-699739752-1194525876=:575"
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1760337AbXKHMou@vger.kernel.org>
In-Reply-To: <4732F643.9030507@systella.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: =?ISO-8859-1?Q?BERTRAND_Jo=EBl?= <joel.bertrand@systella.fr>
Cc: Chuck Ebbert <cebbert@redhat.com>, Neil Brown <neilb@suse.de>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463747160-699739752-1194525876=:575
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Thu, 8 Nov 2007, BERTRAND Jo=EBl wrote:

> BERTRAND Jo=EBl wrote:
>> Chuck Ebbert wrote:
>>> On 11/05/2007 03:36 AM, BERTRAND Jo=EBl wrote:
>>>> Neil Brown wrote:
>>>>> On Sunday November 4, jpiszcz@lucidpixels.com wrote:
>>>>>> # ps auxww | grep D
>>>>>> USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME=20
>>>>>> COMMAND
>>>>>> root       273  0.0  0.0      0     0 ?        D    Oct21  14:40
>>>>>> [pdflush]
>>>>>> root       274  0.0  0.0      0     0 ?        D    Oct21  13:00
>>>>>> [pdflush]
>>>>>>=20
>>>>>> After several days/weeks, this is the second time this has happened,
>>>>>> while doing regular file I/O (decompressing a file), everything on
>>>>>> the device went into D-state.
>>>>> At a guess (I haven't looked closely) I'd say it is the bug that was
>>>>> meant to be fixed by
>>>>>=20
>>>>> commit 4ae3f847e49e3787eca91bced31f8fd328d50496
>>>>>=20
>>>>> except that patch applied badly and needed to be fixed with
>>>>> the following patch (not in git yet).
>>>>> These have been sent to stable@ and should be in the queue for 2.6.23=
=2E2
>>>>     My linux-2.6.23/drivers/md/raid5.c contains your patch for a long
>>>> time :
>>>>=20
>>>> ...
>>>>         spin_lock(&sh->lock);
>>>>         clear_bit(STRIPE_HANDLE, &sh->state);
>>>>         clear_bit(STRIPE_DELAYED, &sh->state);
>>>>
>>>>         s.syncing =3D test_bit(STRIPE_SYNCING, &sh->state);
>>>>         s.expanding =3D test_bit(STRIPE_EXPAND_SOURCE, &sh->state);
>>>>         s.expanded =3D test_bit(STRIPE_EXPAND_READY, &sh->state);
>>>>         /* Now to look around and see what can be done */
>>>>
>>>>         /* clean-up completed biofill operations */
>>>>         if (test_bit(STRIPE_OP_BIOFILL, &sh->ops.complete)) {
>>>>                 clear_bit(STRIPE_OP_BIOFILL, &sh->ops.pending);
>>>>                 clear_bit(STRIPE_OP_BIOFILL, &sh->ops.ack);
>>>>                 clear_bit(STRIPE_OP_BIOFILL, &sh->ops.complete);
>>>>         }
>>>>
>>>>         rcu_read_lock();
>>>>         for (i=3Ddisks; i--; ) {
>>>>                 mdk_rdev_t *rdev;
>>>>                 struct r5dev *dev =3D &sh->dev[i];
>>>> ...
>>>>=20
>>>> but it doesn't fix this bug.
>>>>=20
>>>=20
>>> Did that chunk starting with "clean-up completed biofill operations" en=
d
>>> up where it belongs? The patch with the big context moves it to a=20
>>> different
>>> place from where the original one puts it when applied to 2.6.23...
>>>=20
>>> Lately I've seen several problems where the context isn't enough to mak=
e
>>> a patch apply properly when some offsets have changed. In some cases a
>>> patch won't apply at all because two nearly-identical areas are being
>>> changed and the first chunk gets applied where the second one should,
>>> leaving nowhere for the second chunk to apply.
>>
>>     I always apply this kind of patches by hands, and no by patch comman=
d.=20
>> Last patch sent here seems to fix this bug :
>>=20
>> gershwin:[/usr/scripts] > cat /proc/mdstat
>> Personalities : [raid1] [raid6] [raid5] [raid4]
>> md7 : active raid1 sdi1[2] md_d0p1[0]
>>       1464725632 blocks [2/1] [U_]
>>       [=3D=3D=3D=3D=3D>...............]  recovery =3D 27.1% (396992504/1=
464725632)=20
>> finish=3D1040.3min speed=3D17104K/sec
>
> =09Resync done. Patch fix this bug.
>
> =09Regards,
>
> =09JKB
>

Excellent!

I cannot easily re-produce the bug on my system so I will wait for the=20
next stable patch set to include it and let everyone know if it happens=20
again, thanks.

---1463747160-699739752-1194525876=:575--

From: =?ISO-8859-1?Q?BERTRAND_Jo=EBl?= <joel.bertrand@systella.fr>
Subject: Re: 2.6.23.1: mdadm/raid5 hung/d-state
Date: Wed, 07 Nov 2007 17:48:36 +0100
Message-ID: <4731EC64.3050903@systella.fr>
References: <Pine.LNX.4.64.0711040658180.30831@p34.internal.lan> <18222.16003.92062.970530@notabene.brown> <472ED613.8050101@systella.fr> <4731EA2B.5000806@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4731EA2B.5000806@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Neil Brown <neilb@suse.de>, Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Chuck Ebbert wrote:
> On 11/05/2007 03:36 AM, BERTRAND Jo=EBl wrote:
>> Neil Brown wrote:
>>> On Sunday November 4, jpiszcz@lucidpixels.com wrote:
>>>> # ps auxww | grep D
>>>> USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME C=
OMMAND
>>>> root       273  0.0  0.0      0     0 ?        D    Oct21  14:40
>>>> [pdflush]
>>>> root       274  0.0  0.0      0     0 ?        D    Oct21  13:00
>>>> [pdflush]
>>>>
>>>> After several days/weeks, this is the second time this has happene=
d,
>>>> while doing regular file I/O (decompressing a file), everything on
>>>> the device went into D-state.
>>> At a guess (I haven't looked closely) I'd say it is the bug that wa=
s
>>> meant to be fixed by
>>>
>>> commit 4ae3f847e49e3787eca91bced31f8fd328d50496
>>>
>>> except that patch applied badly and needed to be fixed with
>>> the following patch (not in git yet).
>>> These have been sent to stable@ and should be in the queue for 2.6.=
23.2
>>     My linux-2.6.23/drivers/md/raid5.c contains your patch for a lon=
g
>> time :
>>
>> ...
>>         spin_lock(&sh->lock);
>>         clear_bit(STRIPE_HANDLE, &sh->state);
>>         clear_bit(STRIPE_DELAYED, &sh->state);
>>
>>         s.syncing =3D test_bit(STRIPE_SYNCING, &sh->state);
>>         s.expanding =3D test_bit(STRIPE_EXPAND_SOURCE, &sh->state);
>>         s.expanded =3D test_bit(STRIPE_EXPAND_READY, &sh->state);
>>         /* Now to look around and see what can be done */
>>
>>         /* clean-up completed biofill operations */
>>         if (test_bit(STRIPE_OP_BIOFILL, &sh->ops.complete)) {
>>                 clear_bit(STRIPE_OP_BIOFILL, &sh->ops.pending);
>>                 clear_bit(STRIPE_OP_BIOFILL, &sh->ops.ack);
>>                 clear_bit(STRIPE_OP_BIOFILL, &sh->ops.complete);
>>         }
>>
>>         rcu_read_lock();
>>         for (i=3Ddisks; i--; ) {
>>                 mdk_rdev_t *rdev;
>>                 struct r5dev *dev =3D &sh->dev[i];
>> ...
>>
>> but it doesn't fix this bug.
>>
>=20
> Did that chunk starting with "clean-up completed biofill operations" =
end
> up where it belongs? The patch with the big context moves it to a dif=
ferent
> place from where the original one puts it when applied to 2.6.23...
>=20
> Lately I've seen several problems where the context isn't enough to m=
ake
> a patch apply properly when some offsets have changed. In some cases =
a
> patch won't apply at all because two nearly-identical areas are being
> changed and the first chunk gets applied where the second one should,
> leaving nowhere for the second chunk to apply.

	I always apply this kind of patches by hands, and no by patch command.=
=20
Last patch sent here seems to fix this bug :

gershwin:[/usr/scripts] > cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4]
md7 : active raid1 sdi1[2] md_d0p1[0]
       1464725632 blocks [2/1] [U_]
       [=3D=3D=3D=3D=3D>...............]  recovery =3D 27.1% (396992504=
/1464725632)=20
finish=3D1040.3min speed=3D17104K/sec

	Regards,

	JKB
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: =?UTF-8?Q?Lucian_=C8=98andor?= <lucisandor@gmail.com>
Subject: Re: RAID5 reshape past 100%
Date: Sun, 23 Aug 2009 21:23:38 -0400
Message-ID: <c775b4470908231823md05673cte42e077ccf0c93f@mail.gmail.com>
References: <c775b4470908230502o6fa41danf4281ed58f0e82a9@mail.gmail.com>
	<da29e42a203b94c238e8829394b21861.squirrel@neil.brown.name>
	<c775b4470908231539o4a0ab494vc717146d47219062@mail.gmail.com>
	<5f8a15e87be7d7d4627dfcb2df8ac019.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5f8a15e87be7d7d4627dfcb2df8ac019.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Thanks a lot for your replies.

2009/8/23 NeilBrown <neilb@suse.de>:
> On Mon, August 24, 2009 8:39 am, Lucian =C8=98andor wrote:
>> battlecruiser:~ # zcat /var/log/messages-20090823.gz | grep md
>> [...]
>> Aug 23 07:34:59 battlecruiser kernel: md: couldn't update array info=
=2E -16
>>
>> (This last one appears to be the moment when it goes past 100%.)
>
> -16 is EBUSY. =C2=A0It appears something tried to reshape the array a=
gain?
> Maybe you tried to repeat the --grow command?? =C2=A0Whatever it was,=
 it wasn't
> allowed to proceed because the array was busy reshaping.
> So it is harmless.
>

I didn't try anything. As I said, I believe it could be the moment
when it goes over 100%. It happens at 7:34. I think it is so, because
my initial message, at 7:49, corresponds to 106%.
Good to know it's harmless, maybe it's a side effect of the bug I
already ran into.


> What "persistent error regarding the number of blocks" are you referr=
ing
> to? =C2=A0Except for the transient problems with mdstat, everything l=
ooks
> good.
>

Post-reshape, I still the same number of blocks, which apparently was
incorrect. I also have the failure on "array status" on mdadm
--examine.

>> I am pondering whether to extend the file system.
>
> I should be safe to do that.
>

I am running a sync_action=3Dcheck operation right now and it doesn't
say anything bad. (Not that I have any idea what to see as bad signs.)

Despite the odd output, your program does a great job in preserving
data integrity. Thanks again,
Lucian
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

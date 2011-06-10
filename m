From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: HDD reports errors while completing RAID6 array check
Date: Fri, 10 Jun 2011 19:23:55 +0100
Message-ID: <BANLkTinPfZeSwJ8Tckc0usXFpLHHuPSz4Q@mail.gmail.com>
References: <BANLkTik87PZChAzgBnDM170uJHU=3Yc6Eg@mail.gmail.com>
	<20110611000000.76ca58e7@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110611000000.76ca58e7@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 10 June 2011 19:00, Roman Mamedov <rm@romanrm.ru> wrote:
> On Fri, 10 Jun 2011 18:37:06 +0100
> Mathias Bur=C3=A9n <mathias.buren@gmail.com> wrote:
>
>> =C2=A0 9 Power_On_Hours =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00x0032 =C2=
=A0 090 =C2=A0 090 =C2=A0 000 =C2=A0 =C2=A0Old_age
>> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 7781
>
>
>> # 1 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0=
 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A06827
>> - # 2 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=
=A0 =C2=A0 =C2=A0 00%
>> 6550 =C2=A0 =C2=A0 =C2=A0 =C2=A0 - # 3 =C2=A0Extended offline =C2=A0=
 =C2=A0Completed without error
>> 00% =C2=A0 =C2=A0 =C2=A06468 =C2=A0 =C2=A0 =C2=A0 =C2=A0 - # 4 =C2=A0=
Extended offline =C2=A0 =C2=A0Completed without
>> error =C2=A0 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A06329 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 - # 5 =C2=A0Extended offline =C2=A0 =C2=A0Completed
>> without error =C2=A0 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A06040 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 - # 6 =C2=A0Extended offline
>> Completed without error =C2=A0 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A0=
5584 =C2=A0 =C2=A0 =C2=A0 =C2=A0 - # 7 =C2=A0Extended
>> offline =C2=A0 =C2=A0Completed without error =C2=A0 =C2=A0 =C2=A0 00=
% =C2=A0 =C2=A0 =C2=A05178 =C2=A0 =C2=A0 =C2=A0 =C2=A0 - # 8
>> Extended offline =C2=A0 =C2=A0Completed without error =C2=A0 =C2=A0 =
=C2=A0 00% =C2=A0 =C2=A0 =C2=A04761 =C2=A0 =C2=A0 =C2=A0 =C2=A0 - #
>> 9 =C2=A0Short offline =C2=A0 =C2=A0 =C2=A0 Completed without error =C2=
=A0 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A02285 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 -
>> #10 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0=
 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A01514
>
> I suggest that you do another "smartctl -t long" on it, the latest on=
e was
> done almost 1000 hours ago which is also much longer than the period =
between
> previous tests. Freezes on reads could be a symptom of a bad (unreada=
ble, or
> very slowly readable - which is worse) sector, perhaps it could be de=
tected by
> the SMART test. Or also do a full read of the drive directly (not thr=
ough the
> RAID) e.g. with "badblocks" and see if you get any I/O errors that wa=
y.
>
> --
> With respect,
> Roman
>

Thanks for the suggestions, I'll start the long selftest now.

/M
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

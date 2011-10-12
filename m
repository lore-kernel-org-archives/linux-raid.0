From: "Andrei E. Warkentin" <andrey.warkentin@gmail.com>
Subject: Re: 1.X metadata: Resuming an interrupted incremental recovery for RAID1.
Date: Wed, 12 Oct 2011 12:15:01 -0400
Message-ID: <CANz0V+7W5Y=LxFXRfp8LpeSmTf4LJOJPRNt2wZ7tEicd=ekiLQ@mail.gmail.com>
References: <CANz0V+567wM8dfW0-3mQbWhJjNHf_j4qxH0Da9Agi9xYggAJmA@mail.gmail.com>
	<20111012140517.595f60f8@notabene.brown>
	<CANz0V+5imRWcTyO5L2-=7Qu8nZ+TdSKxPZZ9xFQ2Q1YES3bOgA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CANz0V+5imRWcTyO5L2-=7Qu8nZ+TdSKxPZZ9xFQ2Q1YES3bOgA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2011/10/12 Andrei E. Warkentin <andrey.warkentin@gmail.com>:
>> <thinks....>
>>
>> I think that if a spare being bitmap-recovered fails and then gets r=
e-added,
>> then we have to start the bitmap-recovery from the beginning. =C2=A0=
i.e. we cannot
>> use the recovery_offset. =C2=A0This is because it is entirely possib=
le that while
>> the device was missing the second time, a write went to an address b=
efore
>> recovery_offset and so there is a new bit, which the recovery has to=
 handle.
>>
>> So the correct thing to do is to *not* update the metadata on the re=
covering
>> device until recovery completes. =C2=A0Then if it fails and is re-ad=
ded, it will
>> look just the same as when it was re-added the first time, and will =
do a
>> bitmap-based recovery.
>> Only when the bitmap-based recovery finishes should the metadata be =
updated
>> with a new event count, and then the bitmap can start forgetting tho=
se old
>> bits.
>>
>> Credible?
>> </thinks>
>
> I think you are spot on. If MD_FEATURE_IN_RECOVERY is set in the SB,
> the recovery_offset should be disregarded and recovery
> should start at sector zero. In fact, I've verified that in the
> *current case*, that full recovery that follows the interrupted
> incremental actually starts at
> recovery_offset, so it's broken right now.
>

Actually, doesn't this imply that recovery_offset should never be used
during a recovery (full or incremental) - after all,
you could have had I/O to the degraded array?

A
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

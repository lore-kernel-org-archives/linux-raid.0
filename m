From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: Growing 6 HDD RAID5 to 7 HDD RAID5
Date: Tue, 12 Apr 2011 18:21:13 +0100
Message-ID: <BANLkTim-iiYbza8ZZZv60ArRfXjnOuU7sg@mail.gmail.com>
References: <BANLkTi=yZkM464MbvEgAjEWPGrR+eieXCg@mail.gmail.com>
	<20110412231401.5bb9065c@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110412231401.5bb9065c@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 12 April 2011 18:14, Roman Mamedov <rm@romanrm.ru> wrote:
> On Tue, 12 Apr 2011 17:56:05 +0100
> Mathias Bur=C3=A9n <mathias.buren@gmail.com> wrote:
>
>> I'm approaching over 6.5TB of data, and with an array this large I'd
>> like to migrate to RAID6 for a bit more safety.
>
> That's a great decision (and I suppose you made a typo in the subject=
).
> RAID5 is downright dangerous at that disk count, and with disks of th=
at size.
>
>> I'm just checking if I
>> understand this correctly, this is how to do it:
>>
>> * Add a HDD to the array as a hot spare:
>> mdadm --manage /dev/md0 --add /dev/sdh1
>>
>> * Migrate the array to RAID6:
>> mdadm --grow /dev/md0 --raid-devices 7 --level 6
>
> Looks correct to me...
>
> The first command can be just "mdadm --add /dev/md0 /dev/sdh1".
>
> If you'd rather avoid a reshape at this point, you can add
> "--layout=3Dpreserve" to the second line. That way you will have just=
 a rebuild
> of the new drive, instead of a full reshape.
>
> You will also need to "--grow --bitmap=3Dnone" first (you can re-add =
the bitmap
> later).
>
> --
> With respect,
> Roman
>

Hi,

Yep I mean RAID6, stupid subject line. If I use --layout=3Dpreserve ,
what impact will that have? Will the array have redundancy during the
rebuild of the new drive?
If I preserve the layout, what is the final result of the array
compared to not preserving it?

Cheers,
// Mathias
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

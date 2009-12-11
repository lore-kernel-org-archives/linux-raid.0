From: "Cat'Killer" <catkiller@gmail.com>
Subject: Re: RAID 5 build time optimization question and experiments.
Date: Fri, 11 Dec 2009 16:57:39 +0000
Message-ID: <ad15b8920912110857y12e0df7bqe076ba42fee0102d@mail.gmail.com>
References: <4B227932.80503@mpstor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B227932.80503@mpstor.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> On Fri Dec 11, 2009 at 02:55:31PM +0000, Cat'Killer wrote:
>
>> I found a way using Doug Gilbert's great sg3utils to zero all these
>> disks in a very efficient manner, using sgp_dd, at near drive
>> bandwidth, and proceeded to zero all the disks fully in about 4 hour=
s!
>>
>> Once done, I then created a RAID 5 on 10 disks, waited for the rebui=
ld
>> to complete, stopped the array using mdadm, and dumped each of the
>> RAID's components superblocks to files.
>>
> <-snip->
>>
>> The create worked fine and I waited for the rebuild to be complete
>> before stopping the array and dumping the SBs.
>>
>> I then proceeded to write these same superblocks to 10 new similar
>> disks in a different system.
>>
> You could just do the create with --assume-clean, which should take v=
ery
> little time at all. =A0If the drives were zeroed initially then this =
will
> give you valid parity data.
>
Thank you for this, that's exactly what I was looking for. I had
looked in the manpage beforehand but I did not search for the right
terms nor assumed this would work in case of an array created ontop of
zeroed drives.

Thanks again.

Ben.

> Cheers,
> =A0 Robin
>
> --
> =A0 =A0___ =A0 =A0 =A0 =A0 =A0 ( ' } =A0 =A0 | =A0 =A0 =A0 Robin Hill=
 =A0 =A0 =A0 =A0<robin@robinhill.me.uk>
> |
> =A0/ / ) =A0 =A0 =A0| Little Jim says .... =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0|
> =A0// !! =A0 =A0 =A0 | =A0 =A0 =A0"He fallen in de water !!" =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 |
>
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

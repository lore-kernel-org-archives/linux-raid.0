From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: RAID 5 build time optimization question and experiments.
Date: Fri, 11 Dec 2009 14:35:22 -0800
Message-ID: <4877c76c0912111435o5a79dfccs2a27b48128150921@mail.gmail.com>
References: <4B227932.80503@mpstor.com>
	 <ad15b8920912110857y12e0df7bqe076ba42fee0102d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ad15b8920912110857y12e0df7bqe076ba42fee0102d@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Dec 11, 2009 at 8:57 AM, Cat'Killer <catkiller@gmail.com> wrote=
:
>> On Fri Dec 11, 2009 at 02:55:31PM +0000, Cat'Killer wrote:
>>
>>> I found a way using Doug Gilbert's great sg3utils to zero all these
>>> disks in a very efficient manner, using sgp_dd, at near drive
>>> bandwidth, and proceeded to zero all the disks fully in about 4 hou=
rs!
>>>
>>> Once done, I then created a RAID 5 on 10 disks, waited for the rebu=
ild
>>> to complete, stopped the array using mdadm, and dumped each of the
>>> RAID's components superblocks to files.
>>>
>> <-snip->
>>>
>>> The create worked fine and I waited for the rebuild to be complete
>>> before stopping the array and dumping the SBs.
>>>
>>> I then proceeded to write these same superblocks to 10 new similar
>>> disks in a different system.
>>>
>> You could just do the create with --assume-clean, which should take =
very
>> little time at all. =A0If the drives were zeroed initially then this=
 will
>> give you valid parity data.
>>
> Thank you for this, that's exactly what I was looking for. I had
> looked in the manpage beforehand but I did not search for the right
> terms nor assumed this would work in case of an array created ontop o=
f
> zeroed drives.
>
> Thanks again.
>
> Ben.
>
>> Cheers,
>> =A0 Robin
>>
>> --
>> =A0 =A0___ =A0 =A0 =A0 =A0 =A0 ( ' } =A0 =A0 | =A0 =A0 =A0 Robin Hil=
l =A0 =A0 =A0 =A0<robin@robinhill.me.uk>
>> |
>> =A0/ / ) =A0 =A0 =A0| Little Jim says .... =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0|
>> =A0// !! =A0 =A0 =A0 | =A0 =A0 =A0"He fallen in de water !!" =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 |
>>
>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

Yes, I had just come to a similar conclusion in a recent email series
and even provided a patch against the git copy of the manpage to
clarify the documentation.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

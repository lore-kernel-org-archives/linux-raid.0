From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: Linux mdadm superblock question.
Date: Sat, 13 Feb 2010 01:40:13 -0800
Message-ID: <4877c76c1002130140x65cb2b24ydcb57913c6d89b64@mail.gmail.com>
References: <alpine.DEB.2.00.1002111758350.12031@p34.internal.lan>
	 <4B7664AC.4080504@texsoft.it>
	 <4877c76c1002130126m7ff93c33m5159eb4e554d22b4@mail.gmail.com>
	 <4B767249.2070305@texsoft.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B767249.2070305@texsoft.it>
Sender: linux-raid-owner@vger.kernel.org
To: Giovanni Tessore <giotex@texsoft.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Feb 13, 2010 at 1:35 AM, Giovanni Tessore <giotex@texsoft.it> w=
rote:
>
>>> I recently reinstalled my systems, and I had to use superblock 0.9 =
to be
>>> able to boot ext4 from raid-1 (kernel 2.6.31 - grub2 1.97-beta4).
>>> I didn't go deep with it as I was quite in hurry, so I'm not sure i=
f it
>>> depends by grub2 or by kernel's md autodetection at boot.
>>> I used superblock 1.1 for the others md devices.
>>>
>>> ...
>>
>> mdadm 1.0 block devices, since stored at the end, can still be used
>> /read only/ the same way that 0.90 devices were used before grub kne=
w
>> how to talk to them. =A0By looking at the underlying block devices a=
nd
>> ignoring their tails. =A0This does however only hold for raid-1 layo=
uts
>> with the 1.0 or 0.90 format labels.
>
> I guessed so, infact I created superblock 1.0 for the raid-1 devices =
md0
> (root) and md1 (swap), while 1.1 for the others .. but it didn't work=
 and I
> had to revert to 0.9 for root and swap ...
>
> Regards
>
> --
> Cordiali saluti.
> Yours faithfully.
>
> Giovanni Tessore
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

Just a guess, but did you tell grub root was /dev/md0 or did you say
root was /dev/sd(whatever backs md0) ?
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: data scrubbing
Date: Fri, 29 Jul 2011 22:51:37 +0100
Message-ID: <CADNH=7EXh1JSbbJ6nzDsnva7+-Ug6YdqDrVX2aSd5ezJVzvsTQ@mail.gmail.com>
References: <4E327445.9080404@oldum.net>
	<alpine.DEB.2.00.1107291200580.22537@uplift.swm.pp.se>
	<4E32B4D3.3030905@oldum.net>
	<CADc_k_uV2eOpK+tNxpph3ky2J0OOf_LPF7cNK7f5fPAFpy4Dpw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADc_k_uV2eOpK+tNxpph3ky2J0OOf_LPF7cNK7f5fPAFpy4Dpw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Beolach <beolach@gmail.com>
Cc: Nikolay Kichukov <hijacker@oldum.net>, Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 29 July 2011 21:48, Beolach <beolach@gmail.com> wrote:
> On Fri, Jul 29, 2011 at 07:25, Nikolay Kichukov <hijacker@oldum.net> =
wrote:
>> -----BEGIN PGP SIGNED MESSAGE-----
>> Hash: SHA1
>>
>> Hi,
>>
>> This is a good to know!
>>
>> Just performed a check on a raid1 and got:
>>
>> Jul 29 15:37:36 hanna64 mdadm[2277]: RebuildFinished event detected =
on md device /dev/md1, component device =C2=A0mismatches
>> found: 128
>>
>> So I presume those mismatches have now been rewritten to both disks =
successfully. Am I wrong there?
>>
>> cat /sys/block/md1/md/mismatch_cnt
>> 128
>>
>>
>
> That depends on if you did a "check" or a "repair" - see the SCRUBBIN=
G
> AND MISMATCHES section of the md(4) man page:
> "If =C2=A0check =C2=A0was used, then no action is taken to handle the=
 mismatch,
> it is simply recorded. =C2=A0If repair =C2=A0was =C2=A0used, =C2=A0th=
en =C2=A0a =C2=A0mismatch =C2=A0will
> =C2=A0be repaired =C2=A0in =C2=A0the same way that resync repairs arr=
ays."
>
>
> Good luck,
> Beolach
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>

Sorry to chime in like this. After reading the above, is there a
reason why anyone shouldn't _always_ use repair instead of check on a
weekly RAID6 check? You have to run repair anyway after a check if any
issues are found, right?

Or does the system become vulnerable during a repair? (less redundant)

Thanks,
Mathias
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

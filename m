From: Beolach <beolach@gmail.com>
Subject: Re: data scrubbing
Date: Fri, 29 Jul 2011 16:37:38 -0600
Message-ID: <CADc_k_uDcU_=QT=PYBuowQ1EHCLTXqrnTSk68vt1BFALHxuWwA@mail.gmail.com>
References: <4E327445.9080404@oldum.net> <alpine.DEB.2.00.1107291200580.22537@uplift.swm.pp.se>
 <4E32B4D3.3030905@oldum.net> <CADc_k_uV2eOpK+tNxpph3ky2J0OOf_LPF7cNK7f5fPAFpy4Dpw@mail.gmail.com>
 <CADNH=7EXh1JSbbJ6nzDsnva7+-Ug6YdqDrVX2aSd5ezJVzvsTQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADNH=7EXh1JSbbJ6nzDsnva7+-Ug6YdqDrVX2aSd5ezJVzvsTQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Cc: Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Jul 29, 2011 at 15:51, Mathias Bur=C3=A9n <mathias.buren@gmail.=
com> wrote:
> On 29 July 2011 21:48, Beolach <beolach@gmail.com> wrote:
>> On Fri, Jul 29, 2011 at 07:25, Nikolay Kichukov <hijacker@oldum.net>=
 wrote:
>>> -----BEGIN PGP SIGNED MESSAGE-----
>>> Hash: SHA1
>>>
>>> Hi,
>>>
>>> This is a good to know!
>>>
>>> Just performed a check on a raid1 and got:
>>>
>>> Jul 29 15:37:36 hanna64 mdadm[2277]: RebuildFinished event detected=
 on md device /dev/md1, component device =C2=A0mismatches
>>> found: 128
>>>
>>> So I presume those mismatches have now been rewritten to both disks=
 successfully. Am I wrong there?
>>>
>>> cat /sys/block/md1/md/mismatch_cnt
>>> 128
>>>
>>>
>>
>> That depends on if you did a "check" or a "repair" - see the SCRUBBI=
NG
>> AND MISMATCHES section of the md(4) man page:
>> "If =C2=A0check =C2=A0was used, then no action is taken to handle th=
e mismatch,
>> it is simply recorded. =C2=A0If repair =C2=A0was =C2=A0used, =C2=A0t=
hen =C2=A0a =C2=A0mismatch =C2=A0will
>> =C2=A0be repaired =C2=A0in =C2=A0the same way that resync repairs ar=
rays."
>>
>>
>> Good luck,
>> Beolach
>
> Sorry to chime in like this. After reading the above, is there a
> reason why anyone shouldn't _always_ use repair instead of check on a
> weekly RAID6 check? You have to run repair anyway after a check if an=
y
> issues are found, right?
>
> Or does the system become vulnerable during a repair? (less redundant=
)
>
> Thanks,
> Mathias
>

The primary purpose of data scrubbing a RAID is to detect & correct
read errors on any of the member devices; both check and repair
perform this function.  Finding (and w/ repair correcting) mismatches
is only a secondary purpose - it is only if there are no read errors
but the data copy or parity blocks are found to be inconsistent that a
mismatch is reported.  In order to repair a mismatch, MD needs to
restore consistency, by over writing the inconsistent data copy or
parity blocks w/ the correct data.  But, because the underlying member
devices did not return any errors, MD has no way of knowing which
blocks are correct, and which are incorrect; when it is told to do a
repair, it makes the assumption that the first copy in a RAID1 or
RAID10, or the data (non-parity) blocks in RAID4/5/6 are correct, and
corrects the mismatch based on that assumption.

That assumption may or may not be correct, but MD has no way of
determining that reliably - but the user might be able to, by using
additional knowledge or tools, so MD gives the user the option to
perform data scrubbing either with (repair) or without (check) MD
correcting the mismatches using that assumption.


I hope that answers your question,
Beolach
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

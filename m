From: mark delfman <markdelfman@googlemail.com>
Subject: =?windows-1252?Q?Re=3A_MD_performance_options=3A_More_CPU=92s_or_more_Hz?=
	=?windows-1252?Q?=92s=3F?=
Date: Wed, 4 Nov 2009 14:34:36 +0000
Message-ID: <66781b10911040634mcdc3c70jec3410c09003fb6c@mail.gmail.com>
References: <66781b10911040149q165edf1s94a86f179f9af9fc@mail.gmail.com>
	 <4AF18A39.6010404@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AF18A39.6010404@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Thank you Bill... maybe a silly question but doesn=92t the fact we can
achieve 1.6GBsec on MD RAID0 mean we have drive bandwidth available to
MD to use?  To the block device (sas drives in this case) it does not
know if the data is been xor=92d or just striped, its just blocks of
data.  So wouldn=92t this mean that we know that MD RAID6 =91could=92
achieve up to 1.6GB if the software could send it out quicker?

Hence my logic of =91deal with MD software aspects faster =3D faster wr=
ites=92

Ok, I know that in many applications we would have to deal with read
modify write but I am not sure in this case that would be true given
we are just kicking out one large stream and that would I suspect
write a complete stripe... (or maybe I could be wrong here and that
may be the limitation?)


Mark


On Wed, Nov 4, 2009 at 2:05 PM, Bill Davidsen <davidsen@tmr.com> wrote:
> mark delfman wrote:
>>
>> Hi... I am wondering if anyone can offer some advice on MD performan=
ce
>> related to CPU (speed and or cores). =A0The basic question (probably=
 too
>> basic) is =93for more MD performance are you better with more cpu=92=
s or a
>> faster single cpu=94. =A0(in an ideal world we would have lots of ve=
ry
>> fast CPUs, but given we never have enough money....).
>>
>> Is there any grounding to the following logic:
>>
>> Presuming that a RAID0 will deliver 1.5GBsec and a RAID6 circa
>> 700MBsec, I am guessing there are many complex reasons for the
>> difference, but one of the more obvious being the need for the CPU t=
o
>> perform all the necessary R6 overheads.
>>
>> If we look at a single RAID 6 configuration, then I am guessing if w=
e
>> increase the speed of the CPU from eg 2.0GHz to 2.8GHz (quad core
>> xeon) then the RAID6 calculations would be faster? =A0Would other
>> overheads also be faster and if so is there any know relationship
>> between CPU Hz and MD performance (maybe even rough rule of thumb eg
>> double cpu Hz and increase R6 performance by 20% etc)
>>
>> If however I start to think of multiple RAID6 configurations maybe v=
ia
>> iSCSI etc... then I wonder if MD would be better served with more CP=
Us
>> instead... for example 2 x Quad core 2.0GHz xeons instead of 1 x 2.8=
=2E
>> =A0This theory is dependent on linux / md effectively parallel
>> processing the overheads and I have no knowledge in this area... hen=
ce
>> the question.
>>
>> Any thoughts anyone?
>>
>
> Your logic is correct, but it implies that you expect "faster calcula=
tion"
> to mean "faster write performance," and that is usually true only at =
very
> low or very high write loads.
>
> Very low, because you get the io queued a few ns faster. Since the di=
sk
> still has to do the write, this is essentially meaningless.
>
> Very high, because with many drives and a huge write volume you could=
, in
> theory, start having CPU issues.
>
> I suggest that before you worry over much on that, you look at CPU us=
age at
> idle and then at gradually increasing write load, and look at system =
time
> vs. GB/sec to see if you are actually getting anywhere near the limit=
, or
> even up enough to notice. In my look at this a few years ago I didn't=
 see
> any issues, but that was with only eight drives in the array. Measure=
ment is
> always good, but in general drive performance is the limiting factor =
rather
> than CPU.
>
> You didn't ask: if you use ext[34] filesystems, there is a gain to be=
 had
> from tuning the stripe and stride parameters, at least for large sequ=
ential
> io. My measurements were on 2.6.26, so are out of date, but less head=
 motion
> is always better.
>
> Others may have more experience, other than load testing the array ha=
s never
> been stressed, performance of backup servers is less important than
> reliability.
>
> --
> Bill Davidsen <davidsen@tmr.com>
> =A0Unintended results are the well-earned reward for incompetence.
>
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: daobang wang <wangdb1981@gmail.com>
Subject: Re: RAID5 created by 8 disks works with xfs
Date: Fri, 6 Apr 2012 14:49:59 +0800
Message-ID: <CACwgYDOc2C=j1hrbtwTqOPr77wtfLvxow9xNeF+mGUakt1rHzQ@mail.gmail.com>
References: <CACwgYDPQBNa7z7WcyUjV2Rx8Qf47r7eaRCowNKxjLBz+fYcfvQ@mail.gmail.com>
	<CADNH=7H_rgiY4fkB0SHo0yPhSBib7Gq-E_fu18yuJx=enn-eGg@mail.gmail.com>
	<4F776492.4070600@hardwarefreak.com>
	<CACwgYDOSrEYUps2VLpFSZ-irH7Mn_-BWrOYYDgXS=ULrmVuEPw@mail.gmail.com>
	<4F77D0B2.8000809@hardwarefreak.com>
	<CACwgYDMx6nQF-OwYj-BA+sZivUK=kmv2tPukgf5JGwA1vMTGrA@mail.gmail.com>
	<4F77EA55.6090004@hardwarefreak.com>
	<CACwgYDMVHT5DFjJztX9JvsVQJ+uOjPrfcs4+0aGXotDvf6tymQ@mail.gmail.com>
	<CACwgYDMXF9WEgzW9vL_0=GdRc_t+67WAkRTKNoKOMEMCvjujVw@mail.gmail.com>
	<CALFpzo5aKM2y_stDR14PNYMHEcq5CEptuFiXrvcCpXTzSQmAxw@mail.gmail.com>
	<4F792154.5020006@hardwarefreak.com>
	<CACwgYDPsZSEhuqNP8YgAksEq9BB6YOS1Q8jGx2J7DCrrOh_JQw@mail.gmail.com>
	<CACwgYDOtCoVF-p+KKqPYxHhA4vWF78Ueecx9hcVWLoyxFWzV9Q@mail.gmail.com>
	<4F7E0842.6090004@hardwarefreak.com>
	<CACwgYDMEpFqJhtUGeRg4hvux3GigNRnA--V18DwdyUvJpY434w@mail.gmail.com>
	<CACwgYDPur_8sO-BhhP-ggEmPCGa5ddsCcmSDfCuhD9OgiwGRyw@mail.gmail.com>
	<CA+res+RR5iAZsEY8G21YkQn+p_8EYSFvu4+H1SK=HXshOcS-4g@mail.gmail.com>
	<CACwgYDN5ceD3ka-O9t1rGdj4tS=JpHVm_ZWetqZ7ZAOyEjqspA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CACwgYDN5ceD3ka-O9t1rGdj4tS=JpHVm_ZWetqZ7ZAOyEjqspA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jack Wang <jack.wang.usish@gmail.com>
Cc: stan@hardwarefreak.com, Marcus Sorensen <shadowsor@gmail.com>, =?ISO-8859-1?Q?Mathias_Bur=E9n?= <mathias.buren@gmail.com>, linux-raid <linux-raid@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>
List-Id: linux-raid.ids

I did more tests, and found the mkfs.xfs did not hang.

I tried to make the xfs on 7TB logical volume, both 2.10.1 and 3.1.5
mkfs.xfs -f dev will work well, less than one minute.

But when i tried to make xfs on 8TB logical volume, 2.10.1 works well,
less than 1 minute, but 3.1.5 needs 5 minutes.

On 4/6/12, daobang wang <wangdb1981@gmail.com> wrote:
> Hi Jacky,
>
>      Yes, the environment is like your description, i will try with
> your suggestion. thanks a lot.
>
> On 4/6/12, Jack Wang <jack.wang.usish@gmail.com> wrote:
>> using bigger inode size or inode64 does help?
>>
>> So your environment is NVR software running in Linux ,100+ D1 stream=
er
>> directly write to filesystem on top of 16 SATA disks (with raid5 and
>> vg)?
>>
>> 2012/4/6 daobang wang <wangdb1981@gmail.com>:
>>> There is another issue, i updated xfsprog from 2.10.1 to 3.1.5, and
>>> found i could not make the xfs filesystem when the logical volume s=
ize
>>> large than 8TB with command mkfs.xfs -f -i size=3D512
>>> /dev/vg+vg00+20120406101850/lv+nxx+lv0000, this command seems hang,=
 it
>>> did not return for a long time, is there any parameter i should
>>> adjust?
>>>
>>> Thank you very much
>>>
>>> Best Regards,
>>> Daobang Wang.
>>>
>>> On 4/6/12, daobang wang <wangdb1981@gmail.com> wrote:
>>>> Hi All,
>>>>
>>>> =A0 =A0 I have found the solution, i updated the xfsprogs from 2.1=
0.1 to
>>>> 3.1.5, and could repair it, Thanks.
>>>>
>>>> Best Wishes,
>>>> Daobang Wang.
>>>>
>>>> On 4/6/12, Stan Hoeppner <stan@hardwarefreak.com> wrote:
>>>>> On 4/5/2012 1:48 AM, daobang wang wrote:
>>>>>> Hi stan,
>>>>>>
>>>>>> =A0 =A0 =A0I duplicated the input/output error issue, about the =
detail
>>>>>> operations and logs, please see the attachments, Is there any wa=
y to
>>>>>> fix this? thanks!
>>>>>>
>>>>>> Best Regards,
>>>>>> Daobang Wang.
>>>>>
>>>>>
>>>>> These fiilesystem issues have nothing to do with linux-raid. =A0I=
'm
>>>>> copying the XFS mailing list which is where this discussion shoul=
d be
>>>>> taking place from this point forward. =A0Please reply-to-all, and=
 paste
>>>>> the output you previously attached, but inline this time.
>>>>>
>>>>> Also, since the XFS folks are unfamiliar with what you're doing u=
p to
>>>>> this point, please provide a basic description of your
>>>>> hardware/storage
>>>>> setup, kernel version, mdraid configuration, xfs_info output as w=
ell
>>>>> as
>>>>> your fstab XFS mount options, and a description of your workload.
>>>>>
>>>>> My best guess at this point as to the du and ls errors is that yo=
ur
>>>>> application is not behaving properly, or you're still running wit=
h XFS
>>>>> barriers disabled, which, I say _loudly_ for the 2nd time, you sh=
ould
>>>>> NOT do in the absence of BBWC, which you stated you do not have.
>>>>>
>>>>> --
>>>>> Stan
>>>>>
>>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
>>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

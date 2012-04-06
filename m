From: daobang wang <wangdb1981@gmail.com>
Subject: Re: RAID5 created by 8 disks works with xfs
Date: Fri, 6 Apr 2012 10:33:21 +0800
Message-ID: <CACwgYDPur_8sO-BhhP-ggEmPCGa5ddsCcmSDfCuhD9OgiwGRyw@mail.gmail.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CACwgYDMEpFqJhtUGeRg4hvux3GigNRnA--V18DwdyUvJpY434w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: Marcus Sorensen <shadowsor@gmail.com>, =?ISO-8859-1?Q?Mathias_Bur=E9n?= <mathias.buren@gmail.com>, linux-raid <linux-raid@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>
List-Id: linux-raid.ids

There is another issue, i updated xfsprog from 2.10.1 to 3.1.5, and
found i could not make the xfs filesystem when the logical volume size
large than 8TB with command mkfs.xfs -f -i size=512
/dev/vg+vg00+20120406101850/lv+nxx+lv0000, this command seems hang, it
did not return for a long time, is there any parameter i should
adjust?

Thank you very much

Best Regards,
Daobang Wang.

On 4/6/12, daobang wang <wangdb1981@gmail.com> wrote:
> Hi All,
>
>     I have found the solution, i updated the xfsprogs from 2.10.1 to
> 3.1.5, and could repair it, Thanks.
>
> Best Wishes,
> Daobang Wang.
>
> On 4/6/12, Stan Hoeppner <stan@hardwarefreak.com> wrote:
>> On 4/5/2012 1:48 AM, daobang wang wrote:
>>> Hi stan,
>>>
>>>      I duplicated the input/output error issue, about the detail
>>> operations and logs, please see the attachments, Is there any way to
>>> fix this? thanks!
>>>
>>> Best Regards,
>>> Daobang Wang.
>>
>>
>> These fiilesystem issues have nothing to do with linux-raid.  I'm
>> copying the XFS mailing list which is where this discussion should be
>> taking place from this point forward.  Please reply-to-all, and paste
>> the output you previously attached, but inline this time.
>>
>> Also, since the XFS folks are unfamiliar with what you're doing up to
>> this point, please provide a basic description of your hardware/storage
>> setup, kernel version, mdraid configuration, xfs_info output as well as
>> your fstab XFS mount options, and a description of your workload.
>>
>> My best guess at this point as to the du and ls errors is that your
>> application is not behaving properly, or you're still running with XFS
>> barriers disabled, which, I say _loudly_ for the 2nd time, you should
>> NOT do in the absence of BBWC, which you stated you do not have.
>>
>> --
>> Stan
>>
>

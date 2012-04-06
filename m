From: daobang wang <wangdb1981@gmail.com>
Subject: Re: RAID5 created by 8 disks works with xfs
Date: Fri, 6 Apr 2012 16:45:06 +0800
Message-ID: <CACwgYDMXZ2O+7B163eg5h-D5sw9_0MRgu8BAahjgOr+td8cJtg@mail.gmail.com>
References: <CACwgYDPQBNa7z7WcyUjV2Rx8Qf47r7eaRCowNKxjLBz+fYcfvQ@mail.gmail.com>
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
	<CACwgYDOc2C=j1hrbtwTqOPr77wtfLvxow9xNeF+mGUakt1rHzQ@mail.gmail.com>
	<4F7EA6D4.804@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F7EA6D4.804@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: Jack Wang <jack.wang.usish@gmail.com>, Marcus Sorensen <shadowsor@gmail.com>, =?ISO-8859-1?Q?Mathias_Bur=E9n?= <mathias.buren@gmail.com>, linux-raid <linux-raid@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>
List-Id: linux-raid.ids

Hi stan,

    Thank you for your reply, the envrionment is the same that i
mentioned before,  the user allows the cache data to miss, so i did
not disable the barriers, they just demands that the filesystem should
be repaired after system restarted. We did not deal with the fstab
now, it is the next step work.

    And about the mkfs.xfs slow issue, we found the logsize is too
large, it caused making the xfs filesystem slowly.

    Thanks again.

Have a good day.
Daobang Wang.

On 4/6/12, Stan Hoeppner <stan@hardwarefreak.com> wrote:
> On 4/6/2012 1:49 AM, daobang wang wrote:
>> I did more tests, and found the mkfs.xfs did not hang.
>>
>> I tried to make the xfs on 7TB logical volume, both 2.10.1 and 3.1.5
>> mkfs.xfs -f dev will work well, less than one minute.
>>
>> But when i tried to make xfs on 8TB logical volume, 2.10.1 works well,
>> less than 1 minute, but 3.1.5 needs 5 minutes.
>
> Once you provide the information I requested I'd be glad to help you
> further.  Without that information I'm wasting my time.
>
> --
> Stan
>

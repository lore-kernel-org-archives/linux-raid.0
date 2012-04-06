From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: RAID5 created by 8 disks works with xfs
Date: Fri, 06 Apr 2012 06:12:23 -0500
Message-ID: <4F7ECF97.6020601@hardwarefreak.com>
References: <CACwgYDPQBNa7z7WcyUjV2Rx8Qf47r7eaRCowNKxjLBz+fYcfvQ@mail.gmail.com> <4F77EA55.6090004@hardwarefreak.com> <CACwgYDMVHT5DFjJztX9JvsVQJ+uOjPrfcs4+0aGXotDvf6tymQ@mail.gmail.com> <CACwgYDMXF9WEgzW9vL_0=GdRc_t+67WAkRTKNoKOMEMCvjujVw@mail.gmail.com> <CALFpzo5aKM2y_stDR14PNYMHEcq5CEptuFiXrvcCpXTzSQmAxw@mail.gmail.com> <4F792154.5020006@hardwarefreak.com> <CACwgYDPsZSEhuqNP8YgAksEq9BB6YOS1Q8jGx2J7DCrrOh_JQw@mail.gmail.com> <CACwgYDOtCoVF-p+KKqPYxHhA4vWF78Ueecx9hcVWLoyxFWzV9Q@mail.gmail.com> <4F7E0842.6090004@hardwarefreak.com> <CACwgYDMEpFqJhtUGeRg4hvux3GigNRnA--V18DwdyUvJpY434w@mail.gmail.com> <CACwgYDPur_8sO-BhhP-ggEmPCGa5ddsCcmSDfCuhD9OgiwGRyw@mail.gmail.com> <CA+res+RR5iAZsEY8G21YkQn+p_8EYSFvu4+H1SK=HXshOcS-4g@mail.gmail.com> <CACwgYDN5ceD3ka-O9t1rGdj4tS=JpHVm_ZWetqZ7ZAOyEjqspA@mai
 l.gmail.com> <CACwgYDOc2C=j1hrbtwTqOPr77wtfLvxow9xNeF+mGUakt1rHzQ@mail.gmail.com> <4F7EA6D4.804@hardwarefreak.com> <CACwgYDMXZ2O+7B163eg5h-D5sw9_0MRgu8BAahjgOr+td8cJtg@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CACwgYDMXZ2O+7B163eg5h-D5sw9_0MRgu8BAahjgOr+td8cJtg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: daobang wang <wangdb1981@gmail.com>
Cc: Marcus Sorensen <shadowsor@gmail.com>, linux-raid <linux-raid@vger.kernel.org>, =?ISO-8859-1?Q?Mathias_Bur=E9n?= <mathias.buren@gmail.com>, Jack Wang <jack.wang.usish@gmail.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>
List-Id: linux-raid.ids

On 4/6/2012 3:45 AM, daobang wang wrote:
> Hi stan,
> 
>     Thank you for your reply, the envrionment is the same that i
> mentioned before,  [...]

There's seems to be some kind of communication failure here.  I'll make
this really simple.  Please fill in the blanks.

$ uname -a

$ xfs_info [device]

$ cat /etc/fstab|grep xfs

$ mdadm --detail /dev/mdX


Thanks.

-- 
Stan


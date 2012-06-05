From: Igor M Podlesny <for.poige+lsr@gmail.com>
Subject: Re: Software RAID checksum performance on 24 disks not even close to
 kernel reported
Date: Tue, 5 Jun 2012 19:29:33 +0800
Message-ID: <CA+sTkh7XeE49HmF+REyNTcOWJK6OS-tfi0qk7-SosFmAWenTqA@mail.gmail.com>
References: <CA+4vN7wPd0Av_sbtA0JD5y=fGcsuq20SOQVHWnE8BUFpDxOEXQ@mail.gmail.com>
 <CA+sTkh4fd+oZqagpHkGv5Kw+nkDyhunXfJm0tu0rqvuxVZBOyQ@mail.gmail.com> <CA+4vN7xH10qS-=OSS_3z3B3EohKHjk8-GBVvVfPj01TH-0pe3w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+4vN7xH10qS-=OSS_3z3B3EohKHjk8-GBVvVfPj01TH-0pe3w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ole Tange <ole@tange.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 5 June 2012 15:47, Ole Tange <ole@tange.dk> wrote:
> On Tue, Jun 5, 2012 at 5:39 AM, Igor M Podlesny <for.poige+lsr@gmail.=
com> wrote:
>> On 5 June 2012 07:14, Ole Tange <ole@tange.dk> wrote:
>> [=E2=80=A6]
>>> I tested this by creating 24 devices in RAM, used different chunk
>>> sizes, and then copied the linux kernel source. Test script can be
>>> found on http://oletange.blogspot.dk/2012/05/software-raid-performa=
nce-on-24-disks.html
>>
>> =C2=A0 I don't see there "--assume-clean" option, and it's (again) n=
ot
>> clear =E2=80=94 are you playing with re-syncing RAID or what?
>
> Good call. But the resync is done before the mkfs.xfs is finished, so
> the time of the copying is not affected by resync.
>
> I re-tested with --assume-clean and as expected it has no impact.

   Wanna try CONFIG_MULTICORE_RAID456? :-)

--
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

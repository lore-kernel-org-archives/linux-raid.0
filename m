From: Ole Tange <ole@tange.dk>
Subject: Re: Software RAID checksum performance on 24 disks not even close to
 kernel reported
Date: Tue, 5 Jun 2012 20:44:06 +0200
Message-ID: <CA+4vN7x0f3f3=htC4iaPmDPqdviv8+AqAqY3sxKbP1X+89gtuQ@mail.gmail.com>
References: <CA+4vN7wPd0Av_sbtA0JD5y=fGcsuq20SOQVHWnE8BUFpDxOEXQ@mail.gmail.com>
 <CA+sTkh4fd+oZqagpHkGv5Kw+nkDyhunXfJm0tu0rqvuxVZBOyQ@mail.gmail.com>
 <CA+4vN7xH10qS-=OSS_3z3B3EohKHjk8-GBVvVfPj01TH-0pe3w@mail.gmail.com> <CA+sTkh7XeE49HmF+REyNTcOWJK6OS-tfi0qk7-SosFmAWenTqA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+sTkh7XeE49HmF+REyNTcOWJK6OS-tfi0qk7-SosFmAWenTqA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Igor M Podlesny <for.poige+lsr@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jun 5, 2012 at 1:29 PM, Igor M Podlesny <for.poige+lsr@gmail.co=
m> wrote:
> On 5 June 2012 15:47, Ole Tange <ole@tange.dk> wrote:
>> On Tue, Jun 5, 2012 at 5:39 AM, Igor M Podlesny <for.poige+lsr@gmail=
=2Ecom> wrote:
>>> On 5 June 2012 07:14, Ole Tange <ole@tange.dk> wrote:
>>> [=85]
>>>> I tested this by creating 24 devices in RAM, used different chunk
>>>> sizes, and then copied the linux kernel source. Test script can be
>>>> found on http://oletange.blogspot.dk/2012/05/software-raid-perform=
ance-on-24-disks.html
:
> =A0 Wanna try CONFIG_MULTICORE_RAID456? :-)

If the kernel can checksum 6196 MB/s why would I need
CONFIG_MULTICORE_RAID456? Please elaborate on why you think that is
needed.

/Ole
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: Software RAID checksum performance on 24 disks not even close
 to kernel reported
Date: Wed, 06 Jun 2012 09:40:37 +0800
Message-ID: <4FCEB515.5050209@fnarfbargle.com>
References: <CA+4vN7wPd0Av_sbtA0JD5y=fGcsuq20SOQVHWnE8BUFpDxOEXQ@mail.gmail.com> <CA+sTkh4fd+oZqagpHkGv5Kw+nkDyhunXfJm0tu0rqvuxVZBOyQ@mail.gmail.com> <CA+4vN7xH10qS-=OSS_3z3B3EohKHjk8-GBVvVfPj01TH-0pe3w@mail.gmail.com> <CA+sTkh7XeE49HmF+REyNTcOWJK6OS-tfi0qk7-SosFmAWenTqA@mail.gmail.com> <CA+4vN7x0f3f3=htC4iaPmDPqdviv8+AqAqY3sxKbP1X+89gtuQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+4vN7x0f3f3=htC4iaPmDPqdviv8+AqAqY3sxKbP1X+89gtuQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ole Tange <ole@tange.dk>
Cc: Igor M Podlesny <for.poige+lsr@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 06/06/12 02:44, Ole Tange wrote:
> On Tue, Jun 5, 2012 at 1:29 PM, Igor M Podlesny<for.poige+lsr@gmail.c=
om>  wrote:
>> On 5 June 2012 15:47, Ole Tange<ole@tange.dk>  wrote:
>>> On Tue, Jun 5, 2012 at 5:39 AM, Igor M Podlesny<for.poige+lsr@gmail=
=2Ecom>  wrote:
>>>> On 5 June 2012 07:14, Ole Tange<ole@tange.dk>  wrote:
>>>> [=85]
>>>>> I tested this by creating 24 devices in RAM, used different chunk
>>>>> sizes, and then copied the linux kernel source. Test script can b=
e
>>>>> found on http://oletange.blogspot.dk/2012/05/software-raid-perfor=
mance-on-24-disks.html
> :
>>    Wanna try CONFIG_MULTICORE_RAID456? :-)
>
> If the kernel can checksum 6196 MB/s why would I need
> CONFIG_MULTICORE_RAID456? Please elaborate on why you think that is
> needed.

I'd have thought there was a significant difference between the test=20
generating that figure (being a large, single block being checksummed)=20
and shunting around blocks from 20 odd block devices, arranging them an=
d=20
checksumming them.

I'm not debating the validity of your tests at all, however I do=20
question your assertion than a single raid6 thread should even get clos=
e=20
to that theoretical figure when actually doing real work.

Why not do as the man suggested and enable CONFIG_MULTICORE_RAID456 and=
=20
see what happens?

Regards,
Brad
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

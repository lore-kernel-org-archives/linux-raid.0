From: Igor M Podlesny <for.poige+lsr@gmail.com>
Subject: Re: Software RAID checksum performance on 24 disks not even close to
 kernel reported
Date: Tue, 5 Jun 2012 11:39:09 +0800
Message-ID: <CA+sTkh4fd+oZqagpHkGv5Kw+nkDyhunXfJm0tu0rqvuxVZBOyQ@mail.gmail.com>
References: <CA+4vN7wPd0Av_sbtA0JD5y=fGcsuq20SOQVHWnE8BUFpDxOEXQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+4vN7wPd0Av_sbtA0JD5y=fGcsuq20SOQVHWnE8BUFpDxOEXQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ole Tange <ole@tange.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 5 June 2012 07:14, Ole Tange <ole@tange.dk> wrote:
[=E2=80=A6]
> I tested this by creating 24 devices in RAM, used different chunk
> sizes, and then copied the linux kernel source. Test script can be
> found on http://oletange.blogspot.dk/2012/05/software-raid-performanc=
e-on-24-disks.html

   I don't see there "--assume-clean" option, and it's (again) not
clear =E2=80=94 are you playing with re-syncing RAID or what?

--
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

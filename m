From: Igor M Podlesny <for.poige+lsr@gmail.com>
Subject: Re: Software RAID checksum performance on 24 disks not even close to
 kernel reported
Date: Thu, 7 Jun 2012 00:05:34 +0800
Message-ID: <CA+sTkh5m9vumG=56n024jBFobaozOQQJjesh=Cc--C7J0FCnfg@mail.gmail.com>
References: <CA+4vN7wPd0Av_sbtA0JD5y=fGcsuq20SOQVHWnE8BUFpDxOEXQ@mail.gmail.com>
 <CA+4vN7xQgecd95FO6gYVLMuPDKXbfZfzuXS1dzHd+e-otrPxwg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+4vN7xQgecd95FO6gYVLMuPDKXbfZfzuXS1dzHd+e-otrPxwg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ole Tange <ole@tange.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 6 June 2012 22:11, Ole Tange <ole@tange.dk> wrote:
> On Tue, Jun 5, 2012 at 1:14 AM, Ole Tange <ole@tange.dk> wrote:
[=E2=80=A6]
> If the bottleneck is md0_raid6, choose a chunk size that gives
> reasonable performance on your CPU (which in your case seem to be
> 32-64 KB).

   Which you're to never-ever do, since it's simply stupid to involve
bunch of disks into so brief I/O ops.

--
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

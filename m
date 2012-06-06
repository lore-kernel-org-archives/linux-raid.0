From: Igor M Podlesny <for.poige+lsr@gmail.com>
Subject: Re: Software RAID checksum performance on 24 disks not even close to
 kernel reported
Date: Thu, 7 Jun 2012 06:21:07 +0800
Message-ID: <CA+sTkh6xUbQGLXpNiUHmHZoqPaQUrGgoyyX1EssjpO8g8hVZNQ@mail.gmail.com>
References: <CA+4vN7wPd0Av_sbtA0JD5y=fGcsuq20SOQVHWnE8BUFpDxOEXQ@mail.gmail.com>
 <CA+4vN7xQgecd95FO6gYVLMuPDKXbfZfzuXS1dzHd+e-otrPxwg@mail.gmail.com>
 <CA+sTkh5m9vumG=56n024jBFobaozOQQJjesh=Cc--C7J0FCnfg@mail.gmail.com> <CA+4vN7xWST=vgMpd9s0Q0MGmPQq1Fe=FZkSc_qPEfX0vOQskoA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+4vN7xWST=vgMpd9s0Q0MGmPQq1Fe=FZkSc_qPEfX0vOQskoA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ole Tange <ole@tange.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 7 June 2012 03:51, Ole Tange <ole@tange.dk> wrote:
[=E2=80=A6]
> So Igor: Do you have numbers that back up your claim? Or do you advic=
e
> against it just because "it's simply stupid"?

   The reasons are pretty well described in FreeBSD 4.11 vinum's
manual (which I had been using long before LSR): =C2=AB=E2=80=A6 For op=
timum
performance, stripes should be at least 128 kB in size: anything
smaller will result in a significant increase in I/O activity due to
mapping of individual requests over multiple disks. The performance
improvement due to the increased number of concurrent transfers caused
by this mapping will not make up for the performance drop due to the
increase in latency. A good guideline for stripe size is between 256
kB and 512 kB.  Avoid powers of 2, however: they tend to cause all
superblocks to be placed on the first subdisk. =E2=80=A6=C2=BB =E2=80=94
http://goo.gl/sTHxY

   P. S. Alas, LSR doesn't support anything but powers of 2 for chunk
sizes, but according to Neil Brown, it can be relatively easy changed.

--
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

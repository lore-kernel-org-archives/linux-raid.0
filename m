From: Ole Tange <ole@tange.dk>
Subject: Re: Software RAID checksum performance on 24 disks not even close to
 kernel reported
Date: Wed, 6 Jun 2012 21:51:16 +0200
Message-ID: <CA+4vN7xWST=vgMpd9s0Q0MGmPQq1Fe=FZkSc_qPEfX0vOQskoA@mail.gmail.com>
References: <CA+4vN7wPd0Av_sbtA0JD5y=fGcsuq20SOQVHWnE8BUFpDxOEXQ@mail.gmail.com>
 <CA+4vN7xQgecd95FO6gYVLMuPDKXbfZfzuXS1dzHd+e-otrPxwg@mail.gmail.com> <CA+sTkh5m9vumG=56n024jBFobaozOQQJjesh=Cc--C7J0FCnfg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+sTkh5m9vumG=56n024jBFobaozOQQJjesh=Cc--C7J0FCnfg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Igor M Podlesny <for.poige+lsr@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jun 6, 2012 at 6:05 PM, Igor M Podlesny <for.poige+lsr@gmail.co=
m> wrote:
> On 6 June 2012 22:11, Ole Tange <ole@tange.dk> wrote:
>> On Tue, Jun 5, 2012 at 1:14 AM, Ole Tange <ole@tange.dk> wrote:
> [=85]
>> If the bottleneck is md0_raid6, choose a chunk size that gives
>> reasonable performance on your CPU (which in your case seem to be
>> 32-64 KB).
>
> =A0 Which you're to never-ever do, since it's simply stupid to involv=
e
> bunch of disks into so brief I/O ops.

Currently it seems the bottleneck is md0_raid6 running on one core as
it seems can only deliver 400 MB/s to a 24 disk RAID6. The hardware +
drivers supports 2000 MB/s according to the tests.

So without change the total bandwidth is 400 MB/s.

Let us say that we can change the config so md0_raid6 can deliver 600
MB/s, but at the cost that the hardware + drivers lose 2/3 of their
performance and thus can only deliver 650 MB/s. Then the total
bandwidth will be 600 MB/s.

To me what matters is the total performance, so I would choose the 600
MB/s over the 400 MB/s any day.

So Igor: Do you have numbers that back up your claim? Or do you advice
against it just because "it's simply stupid"?


/Ole
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

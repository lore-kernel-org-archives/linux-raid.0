From: =?ISO-8859-1?Q?Sebastian_F=E4rber?= <faerber@gmail.com>
Subject: Re: md raid1 rebuild bug? (2.6.32.25)
Date: Tue, 16 Nov 2010 10:22:08 +0100
Message-ID: <AANLkTi=7x101SxUNiMAC0ger-Wg8L4wo_Po-meGStNGb@mail.gmail.com>
References: <AANLkTikbbcXH7Q1KqcOsS0n05TWYpgBev-wR9NVBdKxa@mail.gmail.com>
	<20101115123342.4432308c@notabene.brown>
	<AANLkTi=7=oNwUe=Zog9QCMCtX8JwKEEYcfp1=f8QYM=D@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=7=oNwUe=Zog9QCMCtX8JwKEEYcfp1=f8QYM=D@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>
> The following patch should fix it properly.
> Are you able to apply this patch to your kernel, rebuild, and see if =
it makes
> the required difference?
> Thanks.

I tested your patch against 2.6.32.25 on another server (same problem,
but the original server
was already decommissioned) and it fixes the infinite loop. Thanks!
Would be great if this fix shows up in the stable kernels (i.e 2.6.32.2=
6).

> I'm working on making md cope with this situation better and actually=
 finish
> the recovery - recording where the bad blocks are so when you read fr=
om the
> new device, you can still get read errors, but when you over-write, t=
he error
> goes away. =A0But there are so many other things to do....

That would be great, i see quite a lot bad disks/read errors where the =
recovery
fails because of bad blocks and i guess it's not too uncommon to have a
RAID-1 over two (cheap) disks :-)

Sebastian
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

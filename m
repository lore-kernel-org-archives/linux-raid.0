From: Ole Tange <ole@tange.dk>
Subject: Re: Software RAID checksum performance on 24 disks not even close to
 kernel reported
Date: Wed, 6 Jun 2012 13:21:02 +0200
Message-ID: <CA+4vN7xbkZMGt8GyxK4Eta439gfJsXWfECNrf6tNF_hS9VfQFQ@mail.gmail.com>
References: <CA+4vN7wPd0Av_sbtA0JD5y=fGcsuq20SOQVHWnE8BUFpDxOEXQ@mail.gmail.com>
 <CA+sTkh4fd+oZqagpHkGv5Kw+nkDyhunXfJm0tu0rqvuxVZBOyQ@mail.gmail.com>
 <CA+4vN7xH10qS-=OSS_3z3B3EohKHjk8-GBVvVfPj01TH-0pe3w@mail.gmail.com>
 <CA+sTkh7XeE49HmF+REyNTcOWJK6OS-tfi0qk7-SosFmAWenTqA@mail.gmail.com>
 <CA+4vN7x0f3f3=htC4iaPmDPqdviv8+AqAqY3sxKbP1X+89gtuQ@mail.gmail.com>
 <4FCEB515.5050209@fnarfbargle.com> <CALFpzo71dypQx93b22bXdh2xrBbjYX=bG5=zeZL3EGjMAx_Bxg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CALFpzo71dypQx93b22bXdh2xrBbjYX=bG5=zeZL3EGjMAx_Bxg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Marcus Sorensen <shadowsor@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jun 6, 2012 at 5:48 AM, Marcus Sorensen <shadowsor@gmail.com> w=
rote:

> That's my thought. The checksumming speed doesn't remain static
> regardless of what's being checksummed. =A0If I want to calculate dou=
ble
> parity on a stripe that spans 30 disks I'd expect that to be more CPU
> intensive than calculating double parity on a 3 disk stripe.

If the checksumming speed differs wildly, then it seems odd that the
kernel chooses the best checksumming algorithm before it knows what it
is going to checksum. Would it not make more sense to defer deciding
the algorithm till you know the actual task?


/Ole
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

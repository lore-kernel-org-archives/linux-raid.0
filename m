From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Change disk problem
Date: Sun, 8 Jun 2008 09:20:25 -0400 (EDT)
Message-ID: <alpine.DEB.1.10.0806080920110.22558@p34.internal.lan>
References: <S1753847AbYFHHWg/20080608072236Z+62@vger.kernel.org> <WorldClient-F200806080958.AA58320509@irisinfo.net> <484BADAF.4000605@dgreaves.com> <WorldClient-F200806081212.AA12040517@irisinfo.net> <484BC1F5.3000009@dgreaves.com>
 <WorldClient-F200806081514.AA14270522@irisinfo.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463747160-848660045-1212931225=:22558"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <WorldClient-F200806081514.AA14270522@irisinfo.net>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-15?Q?Jon_Lur=E5s?= <jon@irisinfo.net>
Cc: David Greaves <david@dgreaves.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463747160-848660045-1212931225=:22558
Content-Type: TEXT/PLAIN; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Sun, 8 Jun 2008, Jon Lur=E5s wrote:

>
> Hi
>
> I didn't check in dmesg all the time. Now I check again - and your are
> correct there is a hardware problem (maybe) with my hdj. This has nothing
> to do on the linux-raid list... "hdj dma_intr: status=3D0x51 { DriveReady
> SeekComplete Error }"
>
> Jon

What does:
smartctl -a /dev/hdj

Show?

Justin.

---1463747160-848660045-1212931225=:22558--

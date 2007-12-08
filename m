From: Raz <raziebe@gmail.com>
Subject: Re: mounting raid5 with different unit values
Date: Sat, 8 Dec 2007 21:42:34 +0200
Message-ID: <5d96567b0712081142r4ebb4f2dk25c8b00c30afe0b5@mail.gmail.com>
References: <5d96567b0710070015j723810aag20dc3e2866868684@mail.gmail.com>
	 <20071007145213.GA4504@puku.stupidest.org>
	 <Pine.LNX.4.64.0710071147390.22702@p34.internal.lan>
	 <20071008004513.GA13543@puku.stupidest.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20071008004513.GA13543@puku.stupidest.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Chris Wedgwood <cw@f00f.org>
Cc: linux-xfs@oss.sgi.com, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Well... this thing actually works just fine with a newer kernel (
2.6.18-8-el5 centos5 ). I managed to mount / mkfs.xfs over raid5 with
a pseudo raid5 unit size, and with the appropriate raid 5 patches and
user space access-pattern, I elimintaed in 99% cases the read penalty
.
I sincerly hope I won't be getting any crashes with this file system tunnings.
so ... first, chris and all you xfs guys, many many thanks.
Chris,  How "dangerous" these tunnings are ? Am I to expect "weird"
behaviour of the file system ?

On 10/8/07, Chris Wedgwood <cw@f00f.org> wrote:
> On Sun, Oct 07, 2007 at 11:48:14AM -0400, Justin Piszcz wrote:
>
> > man mount :)
>
> Ah of course.
>
> But those will be more restrictive that what you can specify when you
> make the file-system (because mkfs.xfs can aligned the AGs to suit).
>


-- 
Raz

From: Duncan Hill <dhill+linuxraid@cricalix.net>
Subject: Re: IT 8212F drivers for kernel-2.6.x failure
Date: Sun, 11 Jul 2004 21:29:05 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200407112129.05103.dhill+linuxraid@cricalix.net>
References: <200404112219.30612.dhill+linuxraid@cricalix.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200404112219.30612.dhill+linuxraid@cricalix.net>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday 11 April 2004 22:19, Duncan Hill wrote:
> Carsten Luedtke wrote:
> > -----snip-----
> > Dear Sir,
> >
> > Please visit our web site for downloading the newest driver for kernel
> > 2.6.x.
> > http://www.ite.com.tw/productInfo/Download.html#IT8212 ATA133 Controller
> >
> > Best Regards,
> > -----snip-----
> >
> > You guys with this chipset onboard, please test these drivers and report
> > problems to itesupport@ite.com.tw .
> > The drivers are available from the link above as source or binary
> > drivers.
>
> For me, this driver has some serious issues with a 2.6 kernel on an AMD64
> box. I have sent a bug report to itesupport, once I got them to acknowledge
>
> If anyone cares:
> Mar 24 08:29:38  kernel: Found Controller: IT8212 UDMA/ATA133 RAID

As a self-followup, ITE released 1.45 a little while back, with much better 
2.6 compatability.  I did a brief stress test (copying around ~50 gig of 
mp3s), and the driver worked just fine, no lockups, no corruption.

Moreover, it appears that the driver might even let a system boot from the 
RAID if the driver is in the initrd.  As an added bonus (to me), when running 
in mirrored mode, you can yank a drive out of the mirror, and use it 
standalone and it just works.  No FS trickery or anything.

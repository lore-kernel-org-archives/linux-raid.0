From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: External enclosure - USB : How are the drives presented for software RAID?
Date: Sun, 20 Sep 2009 19:04:19 -0500
Message-ID: <20090921000440406.WSNE17198@cdptpa-omta04.mail.rr.com>
References: <2267211f0909171728n55cdb621l9948c54e01fc8ccc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2267211f0909171728n55cdb621l9948c54e01fc8ccc@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Tim Bostrom
> Sent: Thursday, September 17, 2009 7:28 PM
> To: linux-raid
> Subject: External enclosure - USB : How are the drives presented for
> software RAID?
> 
> I currently have a AMS Venus T5 external enclosure which is an eSATA
> enclosure with Sil4726.  It came with Sil3132 for host controller.   I
> use it for software RAID5 on Linux for storing documents, music, junk,
> etc.  I noticed that when I boot my server, the first drive only shows
> up in the BIOS.  Meaning, there needs to be driver support in order to
> see all the drives and use RAID.

	Generally speaking, this is untrue.  I have several systems which do
not see all the drives in the BIOS but are recognized by the Linux drivers
and are employed in RAID arrays.  It's true you would not be able to boot
from an array using such drives, but it doesn't prevent them from being used
in an array.

> It got me thinking about using an external enclosure with USB as the
> access method.  My question is - does anyone have any experience with
> multi-drive enclosures with USB?  And how are the drives presented to
> the PC?  Would each drive be seen without any driver?

	I don't have any experience with such systems, but I expect the
presentation would be implementation dependent.  That said, I think most
manufacturers of such systems would probably present the array as a single
drive.  Personally, I would shy away from such systems.

> Reason I ask is:  I'm in the process of building a ESXi whitebox and
> the 3132 SATA card isn't supported in ESXi.  So basically, I can't use
> the 3132.  I couldn't find any inexpensive eSATA controllers that
> support port multipliers.

Do you mean in general or specifically supported by ESXi?  I don't know much
about ESXi or its requirements, but inexpensive PM compatible eSATA
controllers are not difficult to find.  I've used a number which are
supported under Linux kernel 2.6.26

> So I was thinking that USB storage support
> would be the least common denominator and could possibly use an
> external enclosure with USB.  I don't need a lot of throughput - I
> literally use it for lite storage.  I use it on a 100Mb network
> anyways so the 480Mbps USB2 would be more than OK.
> 
> Thoughts?

	Again, I don't know about any specific requirements of ESXi, but
have you looked at any SiI 3124 based controllers?  PC Pitstop has a 4 port
eSATA card for $89.  I've purchased Chinese clones locally (but both stores
have websites and ship anywhere) for $45 - $65.  A quick search in Google
Shopping for "siI3124 card" turned up a number of controllers ranging from
$38 to $74.


From: Tim Bostrom <tbostrom@gmail.com>
Subject: External enclosure - USB : How are the drives presented for software
	RAID?
Date: Thu, 17 Sep 2009 17:28:11 -0700
Message-ID: <2267211f0909171728n55cdb621l9948c54e01fc8ccc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I currently have a AMS Venus T5 external enclosure which is an eSATA
enclosure with Sil4726.  It came with Sil3132 for host controller.   I
use it for software RAID5 on Linux for storing documents, music, junk,
etc.  I noticed that when I boot my server, the first drive only shows
up in the BIOS.  Meaning, there needs to be driver support in order to
see all the drives and use RAID.

It got me thinking about using an external enclosure with USB as the
access method.  My question is - does anyone have any experience with
multi-drive enclosures with USB?  And how are the drives presented to
the PC?  Would each drive be seen without any driver?

Reason I ask is:  I'm in the process of building a ESXi whitebox and
the 3132 SATA card isn't supported in ESXi.  So basically, I can't use
the 3132.  I couldn't find any inexpensive eSATA controllers that
support port multipliers.  So I was thinking that USB storage support
would be the least common denominator and could possibly use an
external enclosure with USB.  I don't need a lot of throughput - I
literally use it for lite storage.  I use it on a 100Mb network
anyways so the 480Mbps USB2 would be more than OK.

Thoughts?

-- 
-tim

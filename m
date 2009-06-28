From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Adding a smaller drive
Date: Sun, 28 Jun 2009 18:51:06 -0400
Message-ID: <yq11vp40y79.fsf@sermon.lab.mkp.net>
References: <20090628194705152.ITZI24524@cdptpa-omta02.mail.rr.com>
	<yq1eit411s4.fsf@sermon.lab.mkp.net>
	<alpine.DEB.1.10.0906290029410.5467@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0906290029410.5467@uplift.swm.pp.se> (Mikael
	Abrahamsson's message of "Mon, 29 Jun 2009 00:33:55 +0200 (CEST)")
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, lrhorer@satx.rr.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "Mikael" == Mikael Abrahamsson <swmike@swm.pp.se> writes:

Mikael> The 2TB WD GP drives have less sectors than their 2x their 1TB
Mikael> drives.

That's how it's supposed to be.


Mikael> The 2TB ones adhere to the IDEMA standard (per your other
Mikael> email), but the 1TB ones do not. (2TB ones have 3907029168
Mikael> sectors, the 1TB ones have 1953103872).

That, on the other hand, is pretty weird.  Call the capacity police!

I have two 500GB WDC GP drives in a machine in the lab and they report
the correct IDEMA size.  But other than that I don't have any WDC drives
that I check.

Which model is this?

-- 
Martin K. Petersen	Oracle Linux Engineering

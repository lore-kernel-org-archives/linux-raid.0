From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Adding a smaller drive
Date: Mon, 29 Jun 2009 00:33:55 +0200 (CEST)
Message-ID: <alpine.DEB.1.10.0906290029410.5467@uplift.swm.pp.se>
References: <20090628194705152.ITZI24524@cdptpa-omta02.mail.rr.com> <yq1eit411s4.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <yq1eit411s4.fsf@sermon.lab.mkp.net>
Sender: linux-raid-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: lrhorer@satx.rr.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 28 Jun 2009, Martin K. Petersen wrote:

> This is not nearly as big a problem as it used to be.  Drive
> manufacturers need to adhere to an IDEMA standard which requires them to
> use a specific LBA count for each capacity class.

The 2TB WD GP drives have less sectors than their 2x their 1TB drives. The 
2TB ones adhere to the IDEMA standard (per your other email), but the 1TB 
ones do not.

(2TB ones have 3907029168 sectors, the 1TB ones have 1953103872).

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se

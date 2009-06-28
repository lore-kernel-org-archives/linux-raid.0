From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Adding a smaller drive
Date: Sun, 28 Jun 2009 17:33:47 -0400
Message-ID: <yq1eit411s4.fsf@sermon.lab.mkp.net>
References: <20090628194705152.ITZI24524@cdptpa-omta02.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090628194705152.ITZI24524@cdptpa-omta02.mail.rr.com> (Leslie
	Rhorer's message of "Sun, 28 Jun 2009 14:47:00 -0500")
Sender: linux-raid-owner@vger.kernel.org
To: lrhorer@satx.rr.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "Leslie" == Leslie Rhorer <lrhorer@satx.rr.com> writes:

Leslie> I may have to rethink my position on using raw drives.  If I
Leslie> partition the drives, I can make the partition a bit smaller
Leslie> than the whole drive, allowing for the addition of a future
Leslie> drive whose size is a bit off.  I hate to waste space, but being
Leslie> stuck with an undersized or limping array is worse.

This is not nearly as big a problem as it used to be.  Drive
manufacturers need to adhere to an IDEMA standard which requires them to
use a specific LBA count for each capacity class.

I.e. a 500GB Seagate drive must have exactly the same number of sectors
as a 500GB Western Digital or Hitachi.

The IDEMA LBA standard applies to 3.5" form factor drives over 160GB as
well as 2.5" FF drives over 80 GB.

-- 
Martin K. Petersen	Oracle Linux Engineering


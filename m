From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Adding a smaller drive
Date: Mon, 29 Jun 2009 12:07:17 +0200
Message-ID: <87eit31hgq.fsf@frosties.localdomain>
References: <20090628194705152.ITZI24524@cdptpa-omta02.mail.rr.com>
	<yq1eit411s4.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <yq1eit411s4.fsf@sermon.lab.mkp.net> (Martin K. Petersen's
	message of "Sun, 28 Jun 2009 17:33:47 -0400")
Sender: linux-raid-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: lrhorer@satx.rr.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

"Martin K. Petersen" <martin.petersen@oracle.com> writes:

>>>>>> "Leslie" == Leslie Rhorer <lrhorer@satx.rr.com> writes:
>
> Leslie> I may have to rethink my position on using raw drives.  If I
> Leslie> partition the drives, I can make the partition a bit smaller
> Leslie> than the whole drive, allowing for the addition of a future
> Leslie> drive whose size is a bit off.  I hate to waste space, but being
> Leslie> stuck with an undersized or limping array is worse.
>
> This is not nearly as big a problem as it used to be.  Drive
> manufacturers need to adhere to an IDEMA standard which requires them to
> use a specific LBA count for each capacity class.
>
> I.e. a 500GB Seagate drive must have exactly the same number of sectors
> as a 500GB Western Digital or Hitachi.
>
> The IDEMA LBA standard applies to 3.5" form factor drives over 160GB as
> well as 2.5" FF drives over 80 GB.

Is that realy exactly so many LBA sectors or at least as many?

I don't really see anything wrong with a 500G drive having a few more
sectors. And I know my Maxtor 200G disk is 3G bigger than Seagates.

MfG
        Goswin

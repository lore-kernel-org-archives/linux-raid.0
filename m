From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Bitmap did not survive reboot
Date: Wed, 11 Nov 2009 08:52:23 -0600
Message-ID: <20091111145233013.LCTM5263@cdptpa-omta04.mail.rr.com>
References: <4AFA847F.1070301@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AFA847F.1070301@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: 'John Robinson' <john.robinson@anonymous.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> On 11/11/2009 08:53, Leslie Rhorer wrote:
> [...]
> > 	It took me less than 3 minutes total to implement the explicit mount
> > routine on both servers, and unless someone can give me either a much
> better
> > solution or a solid reason I should not take this approach
> 
> The only problem I can see is that your bitmap is not on a RAID device
> so if the disc goes you lose the bitmap. I guess you're accepting the

	True, but since the OS is also on the drive, if it goes I will need
to shut down the system anyway.

> risk of downtime anyway because your filesystem root is on a non-RAID
> device, but while you can (as I think you've said before) replace the
> boot disc quickly, you're exposing yourself to a long, slow resync which
> will increase your downtime by perhaps days...

	That presumes a loss of the boot drive *AND* one or two RAID drives.
That's pretty unlikely, unless something really nasty happens.  The boot
drives are not on the same controller or in the same enclosure.  They aren't
even the same type of drive.  The boot drives are PATA drives inside the
same enclosure as the respective motherboards.  The RAID drives are SATA
drives in external RAID enclosures.  Right now, a non-bitmap resync takes
about a day and a half, if I limit array access.

	


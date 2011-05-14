From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Growing a RAID array
Date: Sat, 14 May 2011 09:43:36 -0500
Message-ID: <8F.2D.17273.3159ECD4@cdptpa-omtalb.mail.rr.com>
References: <20110514181455.7e97e755@notabene.brown>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110514181455.7e97e755@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: 'NeilBrown' <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> 10Meg devices with a 1Meg chunk size means just 10 stripes.
> 
> To grow from 4 to 5 data disks it calculates that it needs to back up the
> first 20 stripes (I think).  It sees this is more than half the device and
> gets confused and assumes something is wrong.
> 
> Try with 4k chunks, or 100Meg devices.

	Silly machine.  :-)

	'Works like a champ, thanks.  No errors, and the process completes
in the blink of an eye.  Now if growing an array with 3T spindles were only
that fast...


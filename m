From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Bitmap did not survive reboot
Date: Mon, 9 Nov 2009 19:58:49 -0600
Message-ID: <20091110015857583.WZXO3390@cdptpa-omta03.mail.rr.com>
References: <20091110014415205.WMYE3390@cdptpa-omta03.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091110014415205.WMYE3390@cdptpa-omta03.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> 	I had to reboot one of my Linux systems a few days ago (November 2)
> because something was a little unstable, although RAID was AFAIK working
> just fine.  This is not an online production system, so rather than try to
> run down the culprit, I just rebooted the box.  Everything seemed to come
> back up just fine, so I really didn't spend too much time checking
> everything out.  Today one of the drives in the RAID5 array was kicked
> out,
> so I removed it and added it back.  It wasn't until I added the drive back
> that I noticed the array no longer had a write-intent bitmap.  The array
> had
> an external bitmap, but it is no longer there, and I presume for some
> reason
> it was not registered when the box rebooted.  I don't see anything which

	Oh, hey, I just looked at one of my other Linux systems which was
shut down during a protracted power outage 16 days ago, and it, too, is
missing its bitmap, presumably since it was brought back up.


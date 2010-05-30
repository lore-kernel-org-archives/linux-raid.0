From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: Confused about reshape?
Date: Sun, 30 May 2010 18:29:16 -0500
Message-ID: <FB.E6.01646.AC4F20C4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


	Am I confused about reshaping a RAID5 to RAID6 array, or is there an
error in the man page?  The distro I have on one of my servers - Debian
"Squeeze" - employs mdadm 3.0.3, internally dated Oct. 22, 2009.  The man
page that comes with the software specifically says:

-l, --level=

<snip>

	Not yet supported with --grow.

	Searching the web, however, I find the following link from Aug. 17,
2009:

http://neil.brown.name/blog/20090817000931

	In the link, it says:

Now, in mid 2009, we have most of the rest of the reshaping options that had
been planned. These include changing the stripe size, changing the layout
(i.e. where the parity blocks get stored) and reducing the number of
devices.

Changing the layout provides valuable functionality as it is an important
part of converting a RAID5 to a RAID6.

<snip>

Currently supported reshapes

<snip>

RAID5
A RAID5 can change the number of devices, the size of the individual
devices, the chunk size and the layout. A 2 drive RAID5 can be converted to
RAID1, and a 3 or more drive RAID5 can be converted to RAID6.

	Since the 3.0.3 version of mdadm was evidently written in October,
and since this link was from August, one would think 3.0.3 should be able to
re-shape a RAID5 to RAID6.  If so, the man page (at least for Debian
"Squeeze") is incorrect, and of course fails to offer the syntax for such an
upgrade.

	Am I missing something?


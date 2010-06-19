From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Upgrading to GRUB2 from GRUB Legacy on RAID1
Date: Fri, 18 Jun 2010 20:37:42 -0500
Message-ID: <91.B2.25132.76F1C1C4@cdptpa-omtalb.mail.rr.com>
References: <AANLkTinYXblLrapwCWtWhlqa9H0hbCV7PUaOjNLONZUj@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTinYXblLrapwCWtWhlqa9H0hbCV7PUaOjNLONZUj@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Michael Evans' <mjevans1983@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> IIRC Grub 1.97 ('2') supports the 0.90 metablock format but not the
> 1.0 metablock format.  You might just backup the contents of /boot and
> make that small pair of partitions use the older format (re-create
> that array).  For /boot 0.90 should be sufficient in most cases.

	Actually, it's 1.98 in Debian "Squeeze", now, and perhaps higher in
the wild.  You are correct, though.  After getting nowhere on any of the
mailing lists and failing to get a response from the developers, I tried
moving to a 0.9 superblock, and it worked.  Thanks for the response, though.
Anyone who wants to boot from an array with more than 26 elements or any
elements more than 2T in size is hosed...  Fortunately, my boot partition is
only 5G x 2 drives RAID1, and even that is 90% empty.  It only took seconds
to tar the contents of /boot and start testing.

> However, I've not tested grub 2 with mdadm. Only my ubuntu laptop uses
> grub2; both gentoo and arch (as of the last time I looked) were still
> using grub legacy.

	It works, but as you mention, only with 0.9 superblocks.  It is not
at all obvious this is the case from the errors one encounters.  When I
tired my work-around and it STILL did not work, it began to become more
obvious it was the superblock issue.  The thing that gets me is I
specifically asked about the 0.9 bug - had it been fixed? - in the GRUB
mailing list and several places online.  No one answered me, at all.

> In fact, if grub supports the older metablock format but not the newer
> maybe you should file/attach to a bug about it.

	Yeah, I will this weekend if I get a chance.  I'll definitely update
the existing bug report.


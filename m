From: "Scott E. Armitage" <launchpad@scott.armitage.name>
Subject: Re: Software RAID and TRIM
Date: Wed, 29 Jun 2011 07:48:52 -0400
Message-ID: <BANLkTikcN9vy1-SeYONZkGmDTH9ikea=4Q@mail.gmail.com>
References: <alpine.OSX.2.00.1106281628320.257@trogdor.csi.cam.ac.uk>
	<BANLkTimswAVra6qnMS4g8WRzs=dhi_f7OQ@mail.gmail.com>
	<alpine.OSX.2.00.1106291119200.257@trogdor.csi.cam.ac.uk>
	<20110629204519.419474d2@notabene.brown>
	<alpine.OSX.2.00.1106291206390.257@trogdor.csi.cam.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.OSX.2.00.1106291206390.257@trogdor.csi.cam.ac.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jun 29, 2011 at 7:10 AM, Tom De Mulder <tdm27@cam.ac.uk> wrote:
> However, that might not necessarily be a problem; tools exist that can be run manually (slightly fsck-like) and tell the drive which blocks can be erased.

For RAID5/6 at least, md will still require knowledge of what stripes
are and are not in use by the filesystem. In the current
implementation, the entire array must be consistent, regardless of
whether or not a particular block is in use. As far as my
understanding goes, any level of TRIM support for parity arrays would
be a fundamental shift in the way md treats the array.

The simplest solution I see is to do as Niel suggested, and mimic TRIM
support at the RAID level, and pass commands down as necessary. An
alternative solution would be to add a second TRIM layer, where md
maintains a list of what is or is not in use, and once an entire
stripe has been discarded by the filesystem, it can send a single TRIM
command to each member drive to drop the entire stripe contents. This
adds abstraction for the filesystem layer, allowing it to treat the
RAID array like a regular SSD, but adds significant complexity to md
itself.

-Scott

p.s. Sorry if you receive this twice; Majordomo rejected the first one
on HTML subpart basis.

--
Scott Armitage, B.A.Sc., M.A.Sc. candidate
Space Flight Laboratory
University of Toronto Institute for Aerospace Studies
4925 Dufferin Street, Toronto, Ontario, Canada, M3H 5T6

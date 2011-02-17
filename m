From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>
Subject: Re: RAID5 won't mount after reducing disks from 8 to 6
Date: Thu, 17 Feb 2011 03:18:57 +0100
Message-ID: <20110217021857.GA17043@www2.open-std.org>
References: <C2D86BF5-AECE-49B3-B139-1CD6375DCFC9@mac.com> <4D5C7A33.90007@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4D5C7A33.90007@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Matt Tehonica <matt.tehonica@mac.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Feb 16, 2011 at 08:30:27PM -0500, Phil Turmel wrote:
> On 02/16/2011 07:24 PM, Matt Tehonica wrote:
> > Hi all,
> > 
> > I converted my RAID5 from 8 disks to 6 disks using "mdadm --grow /dev/md0 --array-size" and then "mdadm --grow /dev/md0 --raid-devices=6" and after rebooting, it won't mount.  It has been running fine for about a year.  File system is XFS.  Here is some info on it....
> 
> Did you resize (shrink) the XFS filesystem first?

I think it is not possible to shrink an XFS partition.

best regards
keld

From: Jason Lunz <lunz@falooley.org>
Subject: Re: recovery of hosed raid5 array
Date: Sun, 26 Oct 2003 14:48:27 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20031026194827.GA18591@orr.falooley.org>
References: <slrnbog9og.t0c.lunz@orr.homenet> <no.Yo.24973.N.nN.0310111457280@business.com> <slrnboirt8.me8.lunz@orr.homenet> <Pine.LNX.4.58.0310121034090.7866@twinlark.arctic.org> <20031026194051.GA4511@matchmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20031026194051.GA4511@matchmail.com>
To: Mike Fedyk <mfedyk@matchmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Oct 26, 2003 at 11:40AM -0800, Mike Fedyk wrote:
> 1.  Were they maxtor 160GB 8MB cache drives?

Maxtor DiamondMax Plus 30G, model #53073H4, on a 
Promise 20262 pci ide card

luckily enough, I got all my data back. The "dead" drive turned out to
work well enough to read most of the data. By some miracle, the portion
of the drive with unrecoverable sectors was entirely in the 10% of the
disk that wasn't part of the raid partition.

> 2.  Is there any package that will take one drive in a raid1/5 array
> offline, and run badblocks on it?

package? That's a pretty short script to write, using mdadm and
badblocks.

Jason

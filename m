From: NeilBrown <neilb@suse.de>
Subject: Re: advanced partition format, mdadm, and raw disks
Date: Tue, 5 Jul 2011 14:56:41 +1000
Message-ID: <20110705145641.3f8eb3db@notabene.brown>
References: <1309796133.2766.63.camel@baal>
	<20110705103030.401066f6@notabene.brown>
	<1309840130.2865.5.camel@baal>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1309840130.2865.5.camel@baal>
Sender: linux-raid-owner@vger.kernel.org
To: "Tyler J. Wagner" <tyler@tolaris.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 05 Jul 2011 05:28:50 +0100 "Tyler J. Wagner" <tyler@tolaris.com>
wrote:

> On Tue, 2011-07-05 at 10:30 +1000, NeilBrown wrote:
> > No "super" is mentioned here so it must be using 0.90 metadata.
> 
> Ah. Damn that old Debian package.
> 
> I'm concerned that this means the filesystem isn't aligned to the 4K
> sector, and is therefore less efficient. Is 0.90 metadata at the
> beginning or end of the disk? Is it a multiple of 4K in size?
> 

0.90 has data at the start and metadata at the end on a 64k aligned boundary.
So if the partition is 4K aligned, everything else will be too.

NeilBrown


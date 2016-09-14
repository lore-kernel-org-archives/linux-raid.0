From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: moving spares into group and checking spares
Date: Wed, 14 Sep 2016 11:29:59 +0200
Message-ID: <20160914092959.GA3584@metamorpher.de>
References: <nramjg$n07$1@blaine.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <nramjg$n07$1@blaine.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: scar <scar@drigon.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Sep 13, 2016 at 10:18:41PM -0700, scar wrote:
> i currently have four RAID-5 md arrays which i concatenated into one 
> logical volume (lvm2), essentially creating a RAID-50.  each md array 
> was created with one spare disk.

That's perfect for switching to RAID-6. More redundancy should be 
more useful than spares that only sync in when you already completely 
lost redundancy ...

And the disks would also be covered by your checks that way ;)

> i was wondering, then, how i could also check the spare disks to make
> sure they are healthy and ready to be used if needed?

smartmontools, periodic selftests. for all disks, not just the spares.
you can use select,cont tests to check a small region each day, 
covering the entire disk over $X days.

Regards
Andreas Klauer

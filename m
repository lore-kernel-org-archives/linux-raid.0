From: Neil Brown <neilb@suse.de>
Subject: Re: Raid1 uses partially reconstructed drive
Date: Fri, 17 Nov 2006 16:24:03 +1100
Message-ID: <17757.18291.514912.361754@cse.unsw.edu.au>
References: <2F0FC2A92C0B154BB406D5E74CB3E6930336BDC1@3putt.int.lantronix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Danny Sung on Wednesday November 15
Sender: linux-raid-owner@vger.kernel.org
To: Danny Sung <dsung@lantronix.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday November 15, dsung@lantronix.com wrote:
> Perhaps this is the problem addressed in the 2.6.18.2 patch... But I
> thought I'd post it here just in case.
> 
> I was cloning some drives, and ended up creating a 1 drive RAID1 array.
> After that was built, I decided to add my spare drive and allow the
> reconstruction to take care of things.  As soon as I saw that
> reconstruction was taking place, I shutdown the system, put the drives
> away and closed the case.
> 
> To my surprise, when I booted, I encountered numerous disk errors.
> Apparently the system decided to ues the partially reconstructed drive
> as the primary!  And of course, it had no knowledge that reconstruction
> needed to continue.  My data was hosed and I had to restart the cloning
> process.

I've been trying to reproduce this and have failed.  Can you give me
some more details?
Where you using version 1 metadata or the default version 0.90 (though
/etc/mdadm.conf can override the default).
Were you using a write-intent bitmap?  If so, internal or external?

If you can come up with an exact sequence of actions to reproduce this
I'd really appreciate it, but I don't really expect it.

Thanks,
NeilBrown

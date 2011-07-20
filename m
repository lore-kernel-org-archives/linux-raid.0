From: NeilBrown <neilb@suse.de>
Subject: Re: data corruption after rebuild
Date: Wed, 20 Jul 2011 16:24:31 +1000
Message-ID: <20110720162431.5df90f32@notabene.brown>
References: <2073005.NH8LALaxuD@bloomfield>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2073005.NH8LALaxuD@bloomfield>
Sender: linux-raid-owner@vger.kernel.org
To: Pavel Herrmann <morpheus.ibis@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 19 Jul 2011 15:55:35 +0200 Pavel Herrmann <morpheus.ibis@gmail.com>
wrote:

> Hi,
> 
> I have a big problem with mdadm, I removed a drive from my raid6, after 
> replacing it the raid started an online resync. I accidentally pushed the 
> computer and it shut down (power cord moved), and after booting it again the 
> online resync continued.
> 
> the problem is that the rebuilt array is corrupted. most of the data is fine, 
> but every several MB there is an error (which doesn't look like being caused 
> by a crash), effectively invalidating all data on the drive (about 7TB, mainly 
> HD video)
> 
> I do monthly scans, so the redundancy syndromes should have been up-to-date, 
> the array is made of 8 disks, the setup is ext4 on lvm on mdraid
> 
> is there anything to solve this? or at least ideas what happened?

My suggestion would be to remove the drive you recently added and then see if
the data is still corrupted.  It may not help but is probably worth a try.

There was a bug prior to 2.6.32 where RAID6 could sometimes write the wrong
data when recovering to a spare.  It would only happen if you were accessing
that data at the same time as it was recovery it, and if you were unlucky.

However you are running a newer kernel so that shouldn't affect you, but you
never know.

BTW the monthly scans that you do are primarily for finding sleeping bad
blocks - blocks that you cannot read.  They do check for inconsistencies in
the parity but only report them, it doesn't correct them.  This is because
automatically correcting can cause more problems than it solves.

When the monthly check reported inconsistencies you "should" have confirmed
that all the drives seem to be functioning correctly and then run a 'repair'
pass to fix the parity blocks up.

As you didn't that bad parity would have created bad data when you recovered.


NeilBrown

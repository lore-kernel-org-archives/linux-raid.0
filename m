From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Md says 'bug' to kernel log
Date: Tue, 15 Oct 2002 20:47:15 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15787.62003.633385.687754@notabene.cse.unsw.edu.au>
References: <20021012065457.GA26887@modeemi.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Erkki Seppala on Saturday October 12
To: Erkki Seppala <flux@modeemi.fi>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday October 12, flux@modeemi.fi wrote:
...
> 
> After moving the data from the 'failed disk' to the raid, I tried to
> raidhotadd the failed device, however the operation failed as the disk was
> too small. A little bit of a surprise to me, because the disks were the same
> model, but the geometry was different, hence there was a few blocks
> difference..
> 
> While trying to do that, I accidently added the whole disk to the raid. Of
> course I tried to raidhotremove it, but that couldn't be done anymore, I
> assumed due to the fact that it was already rebuilding the disk.

Yes.  raidhotremove will only remove an inactive spare or a failed
device.  Once rebuilding has started, you have to cause the device to
fail before it can be removed:

   raidsetfaulty /dev/md0 /dev/hdX
   raidhotremove /dev/md0 /dev/hdX


> 
> But I couldn't raithotremove it 800 minutes later either, which led me to
> read the kernel logs, where I discovered the bug-statement.
> 
> Here follows a ~50-line exerpt from the log. The complete log is available
> at http://www.modeemi.fi/~flux/kern.log . The time (19:31) fits nicely to
> the time I started the raid and then tried to remove it. This can be seen in
> the full log.
> 
> md: bug in file md.c, line 2351

That MD_BUG shouldn't really be there.  It is just saying that you
tried to remove a device that was busy.  That should cause an error,
but not a MD_BUG... however MD_BUG is not as catastrophic as BUG, all
you get is annoying (and confusing) error messages.

NeilBrown

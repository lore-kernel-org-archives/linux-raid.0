From: NeilBrown <neilb@suse.de>
Subject: Re: possible bug in md
Date: Thu, 14 Jul 2011 15:11:37 +1000
Message-ID: <20110714151137.7cad2801@notabene.brown>
References: <4E11E9A6.2000606@cdf.toronto.edu>
	<20110705102419.5f2b22fa@notabene.brown>
	<4E133B03.60707@cdf.toronto.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E133B03.60707@cdf.toronto.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Iordan Iordanov <iordan@cdf.toronto.edu>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, 05 Jul 2011 12:25:39 -0400 Iordan Iordanov <iordan@cdf.toronto.edu>
wrote:

> Hi Neil,
> 
> On 07/04/11 20:24, NeilBrown wrote:
> > This is correct in that the spare should be removed from the array as there
> > is nothing else useful that can be done.  It is possibly not ideal in that
> > the spare gets marked as 'faulty' where it isn't really.
> 
> I agree that MD is doing the right thing in stopping the sync, since 
> there is nothing else that can be done. What it should say in the kernel 
> log in this case (in my opinion anyway) is something like:
> 
> raid10: Disk failure on sda, sync stopped, sdb marked faulty.
> 
> instead of:
> 
> raid10: Disk failure on sdb, disabling device.
> 
> only because /dev/sdb did not actually fail! I agree this is not 
> terribly important, I was reporting only for correctness, and I know 
> you're busy :).
> 
> Many thanks,
> Iordan

I have made some changes to RAID10 so that it will not report that
a device has failed when really it hasn't.  It will abort the recovery,
ensure that another recovery doesn't automatically restart, and will
report why the recovery was aborted.

Thanks,
NeilBrown

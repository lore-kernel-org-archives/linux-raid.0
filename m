From: Iordan Iordanov <iordan@cdf.toronto.edu>
Subject: Re: possible bug in md
Date: Tue, 05 Jul 2011 12:25:39 -0400
Message-ID: <4E133B03.60707@cdf.toronto.edu>
References: <4E11E9A6.2000606@cdf.toronto.edu> <20110705102419.5f2b22fa@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110705102419.5f2b22fa@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Neil,

On 07/04/11 20:24, NeilBrown wrote:
> This is correct in that the spare should be removed from the array as there
> is nothing else useful that can be done.  It is possibly not ideal in that
> the spare gets marked as 'faulty' where it isn't really.

I agree that MD is doing the right thing in stopping the sync, since 
there is nothing else that can be done. What it should say in the kernel 
log in this case (in my opinion anyway) is something like:

raid10: Disk failure on sda, sync stopped, sdb marked faulty.

instead of:

raid10: Disk failure on sdb, disabling device.

only because /dev/sdb did not actually fail! I agree this is not 
terribly important, I was reporting only for correctness, and I know 
you're busy :).

Many thanks,
Iordan

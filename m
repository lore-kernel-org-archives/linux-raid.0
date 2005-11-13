From: Neil Brown <neilb@suse.de>
Subject: Re: Raid-6 Rebuild question
Date: Sun, 13 Nov 2005 21:05:48 +1100
Message-ID: <17271.4092.24066.572971@cse.unsw.edu.au>
References: <437701DE.7060400@wasp.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Brad Campbell on Sunday November 13
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <brad@wasp.net.au>
Cc: RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sunday November 13, brad@wasp.net.au wrote:
> G'day all,
> 
> Here is an interesting question( well I think so in any case ). I just replaced a failed disk in my 
> 15 drive Raid-6.
> 
> Simply mdadm --add /dev/md0 /dev/sdl
> 
> Why, when there is no other activity on the array at all, is it writing to every disk during the 
> recovery? I would have assumed it just read from the others and
> write to sdl.

The raid6 recovery code always writes out the P and Q blocks for every
stripe.  This is un-necessary and there is in fact a comment in the
code saying:
	/**** FIX: Should we really do both of these unconditionally? ****/

I recently reviewed and cleaned up this code, though I haven't tested
the new version yet.  I'll make sure the new code doesn't do
un-necessary writes (it may already not).  So there is a good chance
that 2.6.16 will do a better job here.  

Thanks for the report,
NeilBrown

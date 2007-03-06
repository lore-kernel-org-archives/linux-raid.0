From: Neil Brown <neilb@suse.de>
Subject: Re: high mismatch count after scrub
Date: Tue, 6 Mar 2007 15:18:08 +1100
Message-ID: <17900.60288.751357.807885@notabene.brown>
References: <200703060306.46082.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Dexter Filmore on Tuesday March 6
Sender: linux-raid-owner@vger.kernel.org
To: Dexter Filmore <Dexter.Filmore@gmx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday March 6, Dexter.Filmore@gmx.de wrote:
> So I practiced what I learned today and scrubbed the array.
> Getting this:
> 
> xerxes:/sys/block/md0/md# cat mismatch_cnt
> 147248
> 
> 4x 250GB Samsung sATA, smartctl says all fine.
> 
> Need to worry?
> 

If you have a swap file on this array, then that could explain it, so
don't worry.

If not... maybe worry?

I assume you did a 'check' or 'repair' before looking at this file?
If not and it is a newly created array, then it is just telling that
the drives didn't have the same content when you started....

NeilBrown

From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Raid Array with 3.5Tb
Date: Thu, 25 Mar 2004 12:28:57 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16482.13785.605678.313900@notabene.cse.unsw.edu.au>
References: <1074196167.1382.8.camel@e-linux>
	<16391.51319.698137.120756@notabene.cse.unsw.edu.au>
	<1079974452.13232.10.camel@e-linux>
        <1080162888.1936.15.camel@e-linux>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Evan Felix on Monday March 22
To: Evan Felix <evan.felix@pnl.gov>
Cc: Nathan D Tenney <Nathan.Tenney@pnl.gov>, linux-raid <linux-raid@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
List-Id: linux-raid.ids

On Monday March 22, evan.felix@pnl.gov wrote:
> Remember the 3.5Tb Array i've been trying to build, i finally got around
> to getting some source code changes that seem to work much better. 
> Attached you will find a patch that fixes the raid5 code to a point
> where it seems to re-sync and recover without complaining about maps not
> being correct.  The patch below is build against a 2.6.3, but will patch
> 2.6.4 sources as well.  At this point i'd like to hear comments,
> thoughts on the changes i've made.  Some notes:
> 
> 1. raid0 seems to work fine at 3.5T
> 2. I have not looked at the raid6 code, but it does not work at 3.5Tb
> 3. Formatting the array with ext3 takes a very long time, not sure why
> yet.

Thanks.
I've added the equivalent changes to raid6 (to keep 5 and 6 in-sync)
and forwarded it to Andrew.

NeilBrown

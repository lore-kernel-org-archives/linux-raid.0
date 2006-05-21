From: Neil Brown <neilb@suse.de>
Subject: Re: recovery speed on many-disk RAID 1
Date: Sun, 21 May 2006 13:15:58 +1000
Message-ID: <17519.56174.431539.632965@cse.unsw.edu.au>
References: <E1FhdUf-0002pr-00@toko.jab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jeff Breidenbach on Saturday May 20
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Breidenbach <jeff@jab.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday May 20, jeff@jab.org wrote:
> interrupted by seeks from read requests on the RAID. But that's not
> really necessary; imagine if it instead went something like:
> 
>   sbb1 -> sbg1    # High bandwidth copy operation limited by drive speed
>   sb[cde]1        # These guys handle read requests
> 

Yeh... that could be done.  There is even a comment in the 2.4 code:

	/* If reconstructing, and >1 working disc,
	 * could dedicate one to rebuild and others to
	 * service read requests ..
	 */

though that seems to have disappeared from 2.6.

Given that
 - high rebuild speed could swamp some buss and so interfere with
   regular IO and
 - it is fairly easy to ask for the speed to be higher

I'm not sure that it is necessary.... might be interesting though.

I've added it to my todo list, but if someone else would like to have
a try....

NeilBrown

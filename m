From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: RE: Raid5 Construction Question
Date: Fri, 20 Aug 2004 12:01:07 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16677.23395.342573.743378@cse.unsw.edu.au>
References: <16677.21008.119662.799869@cse.unsw.edu.au>
	<200408200156.i7K1u0315123@watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Guy on Thursday August 19
To: Guy <bugzilla@watkins-home.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday August 19, bugzilla@watkins-home.com wrote:
> Why does it check the parity and not just write the correct parity?

Because on a mostly-in-sync array, checking the parity is faster than
correcting the parity.

> Does it log the count that were wrong, or anything?

no, but one day it will.

> 
> And does your new --update=resync option do the same thing?

It just marks an in-sync array as not-in-sync so that a resync is
forced.  It will do the same check-and-correct process for raid5.

NeilBrown

From: Neil Brown <neilb@suse.de>
Subject: Re: making raid5 more robust after a crash?
Date: Thu, 30 Mar 2006 09:17:46 +1100
Message-ID: <17451.1930.142781.917105@cse.unsw.edu.au>
References: <20060317130247.GA19878@cjx.com>
	<17435.9868.249413.113639@cse.unsw.edu.au>
	<20060329131907.GA14133@cjx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Chris Allen on Wednesday March 29
Sender: linux-raid-owner@vger.kernel.org
To: Chris Allen <chris@cjx.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday March 29, chris@cjx.com wrote:
> 
> Thanks for your reply. As you guessed, this was a problem
> with our hardware/config and nothing to do with the raid software.

I'm glad you have found your problem!
> 
> Can anybody point me to the syntax I could use for saying:
> 
> "force rebuild the array using drives ABCD but not E, even though
> E looks fresh and D doesn't".

mdadm -Af /dev/mdX A B C D

i.e. don't even tell mdadm about E.

NeilBrown

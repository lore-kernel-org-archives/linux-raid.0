From: Robin Bowes <robin-lists@robinbowes.com>
Subject: Re: RAID5 - 2nd drive died whilst waiting for RMA
Date: Mon, 15 Nov 2004 21:30:59 +0000
Message-ID: <41992013.3030008@robinbowes.com>
References: <200411152124.iAFLOWN22186@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200411152124.iAFLOWN22186@www.watkins-home.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guy <bugzilla@watkins-home.com>
Cc: 'David Greaves' <david@dgreaves.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Guy wrote:

> Something to consider.  A bad block does not indicate a failed drive.
> However, this point is debatable.  There is a reason they have spare blocks.
> Most or all drives can re-locate a bad block to a spare.

When I say "failed" I mean "diagnosed as faulty by the Maxtor PowerMax 
utility". Some drives that were diagnosed as faulty would appear to be 
working OK but would cause the server to crash when syncronising the 
array for the first time.

I suspect the guy I got these drives from had no idea how to handle 
computer gear - the drives arrived packed tightly in a rigid box with a 
thin layer of bubble wrap. I suggested to him that this was sub-optimal 
and he claimed that bacuse the box was really hard it would project the 
drives more. Obviously not heard of g force then!

R.
-- 
http://robinbowes.com

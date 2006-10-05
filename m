From: Neil Brown <neilb@suse.de>
Subject: Re: question about raid5 parity calculations
Date: Thu, 5 Oct 2006 20:01:55 +1000
Message-ID: <17700.55315.718541.709990@cse.unsw.edu.au>
References: <1159878266.4522567a81ee4@webmail.uni-konstanz.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jochen Oekonomopulos on Tuesday October 3
Sender: linux-raid-owner@vger.kernel.org
To: Jochen Oekonomopulos <jochen.oekonomopulos@uni-konstanz.de>
Cc: linux-raid@vger.kernel.org, mingo@elte.hu
List-Id: linux-raid.ids

On Tuesday October 3, jochen.oekonomopulos@uni-konstanz.de wrote:
> 
> Hello Neil, Ingo and [insert your name here],
> 
> I try to understand the raid5 and md code and I have a question
> concerning the cache.
> 
> There are two ways of calculating the parity: read-modify-write and
> reconstruct-write. In my understanding, the code only checks how many
> buffers it has to read for each method (rmw or rcw) without considering
> the cache. But what if there was relevant data in the cache? How would
> the raid code know it so it can build a decision on top of this
> knowledge?

Close.
It checks how many buffers it has to read for each method *with*
consideration of the cache.
Note the "!test_bit(R5_UPTODATE, &dev->flags)" tests in handle_stripe5
in the section where 'rcw' and 'rwm' are being calculated.
It only counts buffers that are not uptodate.  i.e. those that do not
already exist in the stripe cache.

NeilBrown

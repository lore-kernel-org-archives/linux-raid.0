From: Brassow Jonathan <jbrassow@redhat.com>
Subject: Re: [PATCH] MD: Quickly return errors if too many devices have failed.
Date: Mon, 18 Mar 2013 11:15:58 -0500
Message-ID: <31E9173C-B95C-4D4A-BF91-2D5CE93828A5@redhat.com>
References: <1363195764.24906.14.camel@f16> <20130318104905.4a70bc00@notabene.brown>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130318104905.4a70bc00@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org Raid" <linux-raid@vger.kernel.org>, Jonathan Brassow <jbrassow@redhat.com>
List-Id: linux-raid.ids


On Mar 17, 2013, at 6:49 PM, NeilBrown wrote:

>> 
>> 
>> I would prefer to get immediate errors if nothing can be done to satisfy the
>> request and I've been thinking of something like the attached patch.  The
>> patch below is incomplete.  It does not take into account any reshaping that
>> is going on, nor does it try to figure out if a mirror set in RAID10 has died;
>> but I hope it gets the basic idea across.
>> 
>> Is this a good way to handle this situation, or am I missing something?
> 
> I think we do get immediate errors (once all bugs are fixed).
> Your patch does extra work for every request which is only of value if the
> array has failed - and it really doesn't make sense to optimise for a failed
> array.
> The current approach is to just try to satisfy a request and once we find
> that we need to do something that is impossible - return an error at that
> point.  I think that is best.
> 
> Can you try the commit I identified and see if it makes the problem go away?

Yes, that sounds better.  I will try with the commit you mentioned.

thanks,
 brassow


From: Mike Tran <mhtran@us.ibm.com>
Subject: Re: [PATCH] Version 1 super block
Date: Mon, 24 Jan 2005 13:16:15 -0600
Message-ID: <1106594175.8425.18.camel@dyn95390186.austin.ibm.com>
References: <41E9D66E.9080100@us.ibm.com>
	 <1106323194.8425.4.camel@dyn95390186.austin.ibm.com>
	 <16884.20857.878835.1376@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16884.20857.878835.1376@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org, kevcorry@us.ibm.com
List-Id: linux-raid.ids

On Sun, 2005-01-23 at 19:38, Neil Brown wrote:
> On Friday January 21, mhtran@us.ibm.com wrote:
> > Hello Neil,
> > 
> > I've been wondering if you had a chance to look at this patch.  Please
> > let me know.
> 
> No I hadn't, but I have now.
> > 
> > On Sat, 2005-01-15 at 20:50, Mike Tran wrote:
> > > Hello Neil,
> > > 
> > > I found 2 problems in the kernel MD driver:
> > > 1) if disk index 0 is used, counting of max_dev is wrong
> 
> Yes, but I think that the correct fix is simply to add 1 to max_dev,
> rather than setting it to max(max_dev, i).
> It should really be renamed to "max_devs" (i.e. the maximum number of
> devices) rather than "max_dev" (i.e. the maximum device number).
> Possibly "num_slots" wold be an even better name...
> 
> 
> > > 2) missing checksum calculation
> 
> Yes .... how did I miss that :-(
> 
> 
> > > 
> > > Please consider the attached patch for 2.6.10 kernel.
> 
> 
> How about the following?
> I'll add a changelog entry and forward it to Andrew shortly.
> 

sounds good.

Thanks,
Mike T.


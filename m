From: Neil Brown <neilb@suse.de>
Subject: Re: write barriers on raid0 and raid10
Date: Thu, 17 Jun 2010 07:21:14 +1000
Message-ID: <20100617072114.3cb5c36d@notabene.brown>
References: <S1751539Ab0FHSI6/20100608180858Z+3813@vger.kernel.org>
	<4C0E8A88.8010906@cdf.toronto.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C0E8A88.8010906@cdf.toronto.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Iordan Iordanov <iordan@cdf.toronto.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 08 Jun 2010 14:23:04 -0400
Iordan Iordanov <iordan@cdf.toronto.edu> wrote:

> Hi,
> 
> We are designing a rather involved file server with an ext3 formatted 
> stripe (raid0) sitting on top of raid10 devices. Each raid10 device sits 
> on top of 3 iscsi targets, and has layout n3 (so it is effectively a 3 
> way mirror). We chose raid10 over raid1 due to an apparent read 
> performance benefit of raid10.
> 
> We are trying to decide whether to upgrade to a kernel newer than 
> 2.6.34, where write barriers are ostensibly supported by all possible 
> raid types, because we are worried about ext3 corruption with no write 
> barrier support.
> 
> However, we are also worried about whether write barriers really "make 
> sense" in a multi-disk environment and are wondering whether they will 
> actually make a difference in our setup. For argument's sake, let's 
> assume that our drives honor write cache flushes.
> 
> Can somebody shed some light on how write barriers are implemented in 
> raid0 and raid10? Also, any critical comments on the validity of our 
> setup and/or assumptions is also welcome.

Write barriers are handled as:
   - drain all outstanding requests and block new requests
   - send a zero-length barrier to each component device
   - send the data in the barrier request (if it wasn't zero length)
   - send anther zero-length barrier if there was data
   - allow new requests through.

So you may well notice a slow-down i you enable barriers, but theoretically
your data might be a bit safer.   But that is what barriers have always meant
for ext3, which is why they aren't enabled by default.

NeilBrown

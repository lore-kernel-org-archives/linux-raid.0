From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Fibre Channel Shared Raid 5
Date: Tue, 30 Aug 2005 08:52:08 +1000
Message-ID: <17171.37272.213028.524937@cse.unsw.edu.au>
References: <43113170.9030509@neo.tamu.edu>
	<17170.18863.428428.778402@cse.unsw.edu.au>
	<43125753.8000504@neo.tamu.edu>
	<17170.34689.140273.47944@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Neil Brown on Monday August 29
Sender: linux-raid-owner@vger.kernel.org
To: tlg1466@neo.tamu.edu, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday August 29, neilb@cse.unsw.edu.au wrote:
> On Sunday August 28, tlg1466@neo.tamu.edu wrote:
> > I recently stumbled upon ddraid.  Would this work at all for what I'm 
> > looking for?
> 
> I'm not certain, but I suspect not.
> 

Having reflected a bit more on what I learned at the linux.conf.au
talk on the subject, I'm beginning to suspect "so" rather than "not".

ddraid uses a modified raid3 algorithm.
Each device block (which is typically 1 or 4 k) is split into
individual (512byte) sectors and these striped over the physical devices.
Thus every write is a full-stripe-write so no pre-reading is needed
and there is no need for co-ordination with other blocks to calculate
the parity.

Because if this, multiple hosts could write to the array providing
they agree beforehand who is allowed to write to which block - no
further co-ordination is required.

This co-ordination would be needed for dlvm or gfs anyway, so it is
quite possible that it can be used in a very distributed way.

However I've never actually used it, so I cannot promise anything.

NeilBrown

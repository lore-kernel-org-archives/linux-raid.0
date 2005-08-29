From: Dan Stromberg <strombrg@dcs.nac.uci.edu>
Subject: Re: Fibre Channel Shared Raid 5
Date: Mon, 29 Aug 2005 12:41:06 -0700
Message-ID: <1125344466.28811.6.camel@seki.nac.uci.edu>
References: <43113170.9030509@neo.tamu.edu>
	 <17170.18863.428428.778402@cse.unsw.edu.au> <43125753.8000504@neo.tamu.edu>
	 <17170.34689.140273.47944@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17170.34689.140273.47944@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: tlg1466@neo.tamu.edu, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 2005-08-29 at 13:56 +1000, Neil Brown wrote:
> On Sunday August 28, tlg1466@neo.tamu.edu wrote:
> > I recently stumbled upon ddraid.  Would this work at all for what I'm 
> > looking for?
> 
> I'm not certain, but I suspect not.
> 
> The 'dd' stands for 'distributed data'.  You have a cluster where each
> node has one drive, and you use ddraid to combine all these drives
> into an array which can survive as single node dying.  But I *think*
> you still need a master node which runs the array.  Also the slaves
> would need to access the array through the master.
> But as I said, I'm not sure.  You'd need to check with the author I
> guess.

I'm very interested in hearing more about ddraid, if there are folks on
the list who've tried it.

Thanks!



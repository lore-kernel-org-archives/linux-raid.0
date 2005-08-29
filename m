From: Thomas Garner <tlg1466@neo.tamu.edu>
Subject: Re: Fibre Channel Shared Raid 5
Date: Sun, 28 Aug 2005 20:31:15 -0400
Message-ID: <43125753.8000504@neo.tamu.edu>
References: <43113170.9030509@neo.tamu.edu> <17170.18863.428428.778402@cse.unsw.edu.au>
Reply-To: tlg1466@neo.tamu.edu
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17170.18863.428428.778402@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I recently stumbled upon ddraid.  Would this work at all for what I'm 
looking for?

Thomas

Neil Brown wrote:
> I think you are not wrong, sorry (assuming I understand you
> correctly).
> 
> md/raid5 cannot be distributed.  At any one time, one machine must be
> in control of the array and managing parity updates etc.  The device
> provided by md/raid5 can obviously be share with GFS or NFS or nbd of
> whatever.  But the management of the actually raid5 array must in the
> hands of just one machine.
> 
> NeilBrown


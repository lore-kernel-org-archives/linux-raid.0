From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Fibre Channel Shared Raid 5
Date: Mon, 29 Aug 2005 09:33:03 +1000
Message-ID: <17170.18863.428428.778402@cse.unsw.edu.au>
References: <43113170.9030509@neo.tamu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Thomas Garner on Saturday August 27
Sender: linux-raid-owner@vger.kernel.org
To: tlg1466@neo.tamu.edu
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday August 27, tlg1466@neo.tamu.edu wrote:
> Is it possible to take a group of fibre channel drives on a fc-al loop, 
> run raid 5 on top of them, run lvm on top of that, then gfs on top of 
> that, and have the entire thing readable/writable by multiple machines 
> at the same time?  I have searched amongst lvm, clvm, evms, nbd, enbd, 
> linux software raid, etc. but to no avail.  I assume that both clvm or 
> evms would suit me to make the drives available to multiple machine 
> concurrently, but not allow redundancy.  Hopefully I am wrong and this 
> is in fact possible.

I think you are not wrong, sorry (assuming I understand you
correctly).

md/raid5 cannot be distributed.  At any one time, one machine must be
in control of the array and managing parity updates etc.  The device
provided by md/raid5 can obviously be share with GFS or NFS or nbd of
whatever.  But the management of the actually raid5 array must in the
hands of just one machine.

NeilBrown



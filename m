From: Peter Rabbitson <rabbit+list@rabbit.us>
Subject: Re: Is it possilble to be "delay tolerant" or have "slow dropout"
 of unavailable components?
Date: Tue, 08 Apr 2008 20:54:12 +0200
Message-ID: <47FBBF54.4090609@rabbit.us>
References: <47FBA3BB.2030007@nrel.colostate.edu> <200804081948.41959.Markus@hochholdinger.net> <47FBB842.2030902@nrel.colostate.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47FBB842.2030902@nrel.colostate.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Ty! Boyack <ty@nrel.colostate.edu>
Cc: Markus Hochholdinger <Markus@hochholdinger.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ty! Boyack wrote:
>
> <snip>   
> 
> Right now, without the automation, it is possible, and likely, that an 
> operator cannot respond in time to avoid having the bitmap fill up, and 
> then we are into a long resync.

The bitmap can not "fill-up" - this is by design. It is created by simply 
subdividing the _entire_ array into a number of equally sized regions (the 
exact amount depends on the bitmap size, and the size of every region depends 
on the md device size). Then any time a write operation touches the disk the 
corresponding region is marked as dirty. There might be one write or a 
thousand writes - as long as they all fall within the same region - it is the 
only one which will be resync-ed.

HTH

Peter

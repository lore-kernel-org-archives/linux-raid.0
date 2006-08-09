From: Neil Brown <neilb@suse.de>
Subject: Re: Resize on dirty array?
Date: Wed, 9 Aug 2006 14:09:54 +1000
Message-ID: <17625.24594.568139.430440@cse.unsw.edu.au>
References: <44D7DC93.2070905@net1plus.com>
	<17623.57067.835826.446152@cse.unsw.edu.au>
	<44D8E535.9080208@net1plus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from James Peverill on Tuesday August 8
Sender: linux-raid-owner@vger.kernel.org
To: James Peverill <jamespev@net1plus.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday August 8, jamespev@net1plus.com wrote:
> 
> The resize went fine, but after re-adding the drive back into the array 
> I got another fail event (on another drive) about 23% through the 
> rebuild :(
> 
> Did I have to "remove" the bad drive before re-adding it with mdadm?  I 
> think my array might be toast...
> 

You wouldn't be able to re-add the drive without removing it first.
But why did you re-add the failed drive?  Why not add the new one? Or
maybe you did...

2 drives failed - yes - that sounds a bit like toast.
You can possible do a --force assemble without the new drive and try
to backup the data somewhere - if you have somewhere large enough.

NeilBrown


> Any tips on where I should go now?
> 
> Thanks for the help.
> 
> James

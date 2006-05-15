From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 008 of 8] md/bitmap: Change md/bitmap file handling to
 use bmap to file blocks.
Date: Tue, 16 May 2006 09:03:24 +1000
Message-ID: <17513.2236.102102.929378@cse.unsw.edu.au>
References: <20060512160121.7872.patches@notabene>
	<1060512060809.8099@suse.de>
	<20060512104750.0f5cb10a.akpm@osdl.org>
	<17509.22160.118149.49714@cse.unsw.edu.au>
	<20060512235934.4f609019.akpm@osdl.org>
	<17511.51907.537657.656420@cse.unsw.edu.au>
	<20060515140457.18991c2e.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andrew Morton on Monday May 15
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, paul.clements@steeleye.com
List-Id: linux-raid.ids

On Monday May 15, akpm@osdl.org wrote:
> 
> Ho hum, I give up.

Thankyou :-)  I found our debate very valuable - it helped me clarify
my understanding of some areas of linux filesystem semantics (and as I
am trying to write a filesystem in my 'spare time', that will turn out
to be very useful).  It also revealed some problems in the code!

>                     I don't think, in practice, this code fixes any
> demonstrable bug though.

I thought it was our job to kill the bugs *before* they were
demonstrated :-)

I'm still convinced that the previous code could lead to deadlocks or
worse under sufficiently sustained high memory pressure and fs
activity.

I'll send a patch shortly that fixes the known problems and
awkwardnesses in the new code.

Thanks again,
NeilBrown

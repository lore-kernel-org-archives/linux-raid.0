From: Neil Brown <neilb@suse.de>
Subject: Re: Software RAID (non-preempt) server blocking question. (2.6.20.4)
Date: Thu, 29 Mar 2007 16:25:04 +1000
Message-ID: <17931.23488.160031.119117@notabene.brown>
References: <Pine.LNX.4.64.0703270557360.31853@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Justin Piszcz on Tuesday March 27
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday March 27, jpiszcz@lucidpixels.com wrote:
> I ran a check on my SW RAID devices this morning.  However, when I did so, 
> I had a few lftp sessions open pulling files.  After I executed the check, 
> the lftp processes entered 'D' state and I could do 'nothing' in the 
> process until the check finished.  Is this normal?  Should a check block 
> all I/O to the device and put the processes writing to a particular device 
> in 'D' state until it is finished?

No, that shouldn't happen.  The 'check' should notice any other disk
activity and slow down if anything else is happening on the device.

Did the check run to completion?  And if so, did the 'lftp' start
working normally again?

Did you look at "cat /proc/mdstat" ?? What sort of speed was the check
running at?

NeilBrown

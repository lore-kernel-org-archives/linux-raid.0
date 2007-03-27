From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Software RAID (non-preempt) server blocking question. (2.6.20.4)
Date: Tue, 27 Mar 2007 05:59:34 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0703270557360.31853@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I ran a check on my SW RAID devices this morning.  However, when I did so, 
I had a few lftp sessions open pulling files.  After I executed the check, 
the lftp processes entered 'D' state and I could do 'nothing' in the 
process until the check finished.  Is this normal?  Should a check block 
all I/O to the device and put the processes writing to a particular device 
in 'D' state until it is finished?

Justin.

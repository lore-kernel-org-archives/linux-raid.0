From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Raid5 over sbp2 : sbp2 command abort
Date: Tue, 31 Jan 2006 19:26:02 +0100
Message-ID: <43DFABBA.50303@s5r6.in-berlin.de>
References: <fd8d0180601300550k7316bb14t@mail.gmail.com>	<43DE7053.1030706@s5r6.in-berlin.de> <17374.36482.175051.360224@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17374.36482.175051.360224@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Francois Barre <francois.barre@gmail.com>
Cc: linux1394-devel@lists.sourceforge.net, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Francois Barre wrote in personal mail:
> it appeared that it was a harddrive problem. A
> simple dd from was showing the abort messages as well

Over SBP-2 or IDE? Either way, md is no longer a suspect, and we don't 
need to bother linux-raid anymore. :-)

>> What about sbp2's max_speed parameter?
> 
> Hidden option of the level37 ? I've never seen it...

It is listed on www.linux1394.org's sbp2 page (Linux 2.4 syntax) and of 
course in the source. Anyway, it is not important. Since you don't get 
any error messages from the 1394 stack's lower layers, it is obviously 
not an issue of an electrically unreliable bus which would be the main 
reason to use sbp2's max_speed parameter.

> I was wondering if sbp2 didn't behave as if it was buffering
> writes, waiting for a sufficient amount of data before sending it to
> drives... Regardless of the io scheduler I mean...

No, there is no additional scheduling in sbp2 or in the ieee1394 
transactions layer.

It works a bit different anyway: Sbp2 gets pointers to the scsi layer's 
data buffers, puts SCSI commands into additional small buffers, and 
notifies the target (disk) of new commands. The target fetches commands, 
fetches data or sends data, and sends completion status. IOW the target 
is performing all the data movement. So, strictly speaking, there is 
also some kind of scheduler on the other side of the wire involved (the 
target's fetch agent).
-- 
Stefan Richter
-=====-=-==- ---= =====
http://arcgraph.de/sr/

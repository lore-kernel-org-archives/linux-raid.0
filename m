From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: best common practice in case of degraded array with read errors
Date: Mon, 16 Nov 2009 22:32:30 +0100 (CET)
Message-ID: <alpine.DEB.1.10.0911162224530.14550@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hello.

I have a 6 drive raid5. One of the drives failed on me (totally), and when 
I replaced it (-add a new working drive) I had several sectors on another 
drive give me UNC errors, which made md kick that drive as well, and left 
me with a non-working array (with only 4 drives).

What is the best common practice to handle this scenario? Right now I'm 
dd_rescue:ing the drive with read errors to a (hopefully) working drive, 
and then when I plan to --assemble --force the array to get 5 working 
drives (with a few zero:ed sectors where I guess I'll have corrupted 
files, hopefully no important metadata), and then I plan --add a 6th drive 
and have everything sync up and be back to "normal".

Is there a better way? I don't really understand why kicking drives out of 
the array when there aren't enough of them to keep going makes sense, is 
there some rationale I'm missing?

I've also heard recommendations to write to the bad sectors on the 
existing drive, but that scares me as well in case I write to the wrong 
place, which is why I went the dd_rescue route (I'm also hoping that it'll 
retry a bit more and might be able to read the bad blocks...)

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se

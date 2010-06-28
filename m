From: David Lethe <david@santools.com>
Subject: Re: impact of one slow drive?
Date: Sun, 27 Jun 2010 23:11:00 -0500
Message-ID: <EB9469C209DB064DA15714214B92D5167F23871F0F@34093-MBX-C09.mex07a.mlsrvr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Miles Fidelman <mfidelman@meetinghouse.net>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



-----Original Message-----

From:  "Miles Fidelman" <mfidelman@meetinghouse.net>
Subj:  impact of one slow drive?
Date:  Sun Jun 27, 2010 8:31 pm
Size:  2K
To:  "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>

Hi Folks, 
 
I've been slowly tracking down a problem on one of my servers - after  
prolonged periods of high disk activity, iowait goes to 100% and things  
slow down to a crawl. 
 
The server has 4 drives, with various software RAID (md) built on top of  
them.  After a LOT of digging, I've come to the conclusion that one of  
the drives gets flaky under prolonged stress. 
 
I'll find out for sure, when I plug in a replacement (in the mail) - but  
meanwhile.... 
 
What seems to be weird about this is that the drive passes all kinds of  
normal tests: 
- the SMART long test comes back fine, way within tolerances 
- hdparm -tT comes back with values comparable to other drives 
- badblocks reports nothing wrong (but seems to take a LONG time to  
complete) 
- the only diagnostic that indicates anything odd is atop - under  
sustained load, the one drive reports a higher percentage of busy time,  
and seems to have a longer avio 
 
I recall from previous experience, with a failing drive, that the drive  
also tested fine - but seemed to have very high access delays as  
compared to other drives (I can't remember what tool I used to measure  
it) -- which led me to surmise that something, between the disk platter,  
and higher level software, was exhibiting one of two failure modes: 
a) very high delay, or, 
b) required multiple retries, but ultimately came back with a proper  
response 
Either way, the performance of one drive dragged down the entire system. 
 
Which leads to a few questions: 
 
- what tools are there for detailed diagnostics (timing, failure rates,  
etc.) - I can't seem to find anything other than hdparm and smartctl -  
which aren't showing anything 
 
- shouldn't something in hardware/software chain detect long delays,  
mark a disk as failing, and take it out of a RAID array? 
 
- are there some metrics that md tracks that might be relevant, and if  
so, how does one get at them? 
 
- are there some relevant tuning parameters for md? 
 
Thanks very much, 
 
Miles Fidelman 
 
 
--  
In theory, there is no difference between theory and practice. 
In<fnord>  practice, there is.   .... Yogi Berra 
 
 based on symptoms, your disk is frequently in deep recovery cycle. I.e. It tries for 5-20+ seconds to recover data.

Fix is really to get enterprise drives which don't have this problem to begin with, after replacing drive... A patch is to run full media reads often to force remapping of hard-to-read blocks.  

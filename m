From: FLD <fld@r00t3d.com>
Subject: Bad sectors on a degraded array
Date: Sat, 8 Jan 2011 14:49:53 +0200
Message-ID: <20110108124953.GA8241@r00t3d.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

While waiting for my RMA'd disk to return I noticed that one device in
my degraded (4 out of 5) raid5 has developed some bad sectors:
1   Raw_Read_Error_Rate     0x002f   200   200   051    -    0
196 Reallocated_Event_Count 0x0032   200   200   000    -    0
197 Current_Pending_Sector  0x0032   200   200   000    -    3
198 Offline_Uncorrectable   0x0030   200   200   000    -    3

I did some Self-test'ing and got some errors:
# 1  Extended offline    Completed: read failure       50%      6640
1158803416
# 2  Short offline       Completed without error       00%      6637
# 3  Extended offline    Completed: read failure       50%      6634
1158820656

At this point those bad secotrs haven't caused any harm or errors in 
dmesg while the array is mounted r/w and being used. What I'm wondering 
is what kind of steps should I take once the RMA replacement arrives?
I know md doesn't like read errors very much and I'm thinking with smart
output like that it's very likely theres gonna be some read errors during
rebuild?

According to smartmontool documentation this is a pretty common situation 
for a hard disk. There's a nice tutorial how to fix errors like this at:
http://smartmontools.sourceforge.net/badblockhowto.html , so I wonder if 
I should --stop the array and try to manually fix the bad sectors before 
I try rebuilding?

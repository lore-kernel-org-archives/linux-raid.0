From: "Ty! Boyack" <ty@nrel.colostate.edu>
Subject: Is it possilble to be "delay tolerant" or have "slow dropout" of
 unavailable components?
Date: Tue, 08 Apr 2008 10:56:27 -0600
Message-ID: <47FBA3BB.2030007@nrel.colostate.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm curious if there is a way to have a raid set (raid5 in my case, but 
this could apply to any raid level) that could tolerate a component 
device being unavailable for a period of time.

My reason for this is that I am building raid5 sets of iscsi disks, 
attempting to provide some redundancy in case one of our iscsi 
arrays/controllers goes down.  We have had our iscsi arrays reboot a 
couple of times, and the result is that the raid5 set will see the iscsi 
array go down and take it out of the raid5 set.  In a couple of minutes, 
the iscsi disk returns, but it it too late.  I would love to have the 
raid5 set buffer the writes for about 5 minutes while the iscsi device 
reboots, and then pump all the writes to it.  This does not have to be 
time-based.  If we could buffer the writes up to the point where we 
filled the overflow buffer that would solve the problem too, so long as 
we could make a really big buffer.

I realize that this could incur significant memory costs, but that is 
far cheaper for us than us having the raid5 array come apart. 

The other modification for this would be that read operations would need 
to either pull from the buffer or reconstruct the data from the parity, 
but would need to NOT initiate a device failure.

Have I missed something that already takes care of this?

Is there already a feature that takes care of this on a much smaller 
scale (microseconds?) that might be able to be increased to several 
minutes? 

Does anyone else think this would be a good idea?

-Ty!






-- 
-===========================-
  Ty! Boyack
  NREL Unix Network Manager
  ty@nrel.colostate.edu
  (970) 491-1186
-===========================-


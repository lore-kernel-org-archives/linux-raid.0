From: Bill Davidsen <tmrbill@tmr.com>
Subject: RAID 106 array
Date: Wed, 8 Feb 2006 14:10:18 -0500 (EST)
Message-ID: <Pine.LNX.4.44.0602081356540.8063-100000@firewall2.tmr.com>
Reply-To: davidsen@tmr.com
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I was doing some advanced planning for storage, and it came to me that 
there might be benefit from thinking outside the box on RAID config. 
Therefore I offer this for comment.

The object is reliability with performance. The means is to set up two 
arrays on physical devices, one RAID-0 for performance, one RAID-6 for 
reliability. Let's call them four and seven drives for the RAID-0 and 
RAID-6+Spare. Then configure RAID-1 over the two arrays, marking the 
RAID-6 as write-mostly.

The intension is that under heavy load the RAID-6 would have a lot of head 
motion going on writing two parity blocks for every one data write, while 
the RAID-0 would be doing as little work as possible for writes and would 
therefore have more ability to handle reads quickly.

Just a thought experiment at the moment.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
Doing interesting things with little computers since 1979


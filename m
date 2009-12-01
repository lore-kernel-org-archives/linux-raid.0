From: Arun Jagatheesan <arun.jagatheesan@gmail.com>
Subject: MAX IOPS - s/w scaling issues?
Date: Mon, 30 Nov 2009 18:24:30 -0800
Message-ID: <7E302F0A-135C-434F-8D56-A71B625106FA@gmail.com>
Mime-Version: 1.0 (Apple Message framework v753.1)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

We are trying some experiments on our linux raid. We are having  
bottleneck in scaling the RAID after ~250K IOPS.  Is there a known  
issue of s/w max limit or is it simply an issue of configuration?

We have (16 x 64G) SSDs on a RAID0. Our IOPS on this RAID0 stops at  
250K (even with lesser or more SSD drives).    Whereas we get 540K  
IOPS with the same number of SSDs (RAW no RAID). We find a linear  
scale-up for each SSD we add to RAID0 until we reach ~250K IOPS  
limit. After the RAID0 reaches this limit, its just a straight line  
plateau with no increase in performance.

Is there any known issue of the maximum IOPS the s/w can handle?

Cheers,
Arun


From: Bill Davidsen <davidsen@tmr.com>
Subject: [RFC] Additional info on mdadm 'check'
Date: Thu, 16 Aug 2007 08:21:18 -0400
Message-ID: <46C4413E.3060302@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I was wondering if there would be enough value in saving more 
information out of 'check' to justify the effort of coding it. 
Particularly in the area of faster repair. If the check operation 
optionally left a bitmap of stripes which were bad, if the admin decided 
that a repair was appropriate, then only the stripes identified by check 
would need to be processed. Because of possible additional errors, etc, 
that should be optional as well.

This opens the door to more intensive repair operations, such as voting 
on more-than-two-way mirrors, and extensive test and try recovery on 
RAID-6, where no read error is found but the data doesn't match. By 
assuming chunks are bad, one at a time, a correct sector might be 
identified and written back.

Note: this is just an idea at the moment, I'm just doing a feasibility 
study here. ;-)

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979


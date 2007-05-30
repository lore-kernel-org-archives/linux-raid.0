From: Bill Davidsen <davidsen@tmr.com>
Subject: dm-crypt issue
Date: Wed, 30 May 2007 16:34:21 -0400
Message-ID: <465DDFCD.7010900@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I'm not sure this is the right place, or that there IS a right pace for 
this, but it involves RAID, so... ;-)

I have an array I mount with cryptoloop, to hole some information with 
AES encryption. I keep hearing that the way to do this is with dm-crypt, 
but I can't find anyone who will explain how to do that. If I had the 
luxury of starting over I could use dm-crypt to start from scratch, but 
the only practical solution in terms of time and requirement for 
encrypted backup would be to be able to mount the same partitions, using 
the same encryption, just using dm-crypt. I don't think I can do that, 
but if someone wants to assure me that it can be done and point me to 
documentation, I'll be grateful.

I have a LOT of partial sets of this data in the field in DVD, same 
requirement, I can't replace them, they have to work as is.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979


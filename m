From: Bill Davidsen <davidsen@tmr.com>
Subject: Stripe dirty bitmap
Date: Sun, 04 Jul 2010 20:26:40 -0400
Message-ID: <4C3126C0.4050709@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Sure would be nice to have md track whole never written stripes, so 
creating an array didn't have to be done over a three day weekend. When 
any part of a virgin stripe was written it could then be initialized 
properly, and when a virgin stripe was read zeros could be returned 
without disk i/o. It doesn't matter that the reads are done in parallel, 
with modern disk the bus is the bottleneck. With eSATA arrays the bus is 
slow to start with, passing TB through it should be avoided if possible.

-- 
Bill Davidsen <davidsen@tmr.com>
  "We can't solve today's problems by using the same thinking we
   used in creating them." - Einstein


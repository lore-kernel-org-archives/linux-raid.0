From: Pierre Beck <mail@pierre-beck.de>
Subject: Should mdraid implement timeouts?
Date: Thu, 19 Apr 2012 15:11:45 +0200
Message-ID: <4F900F10.1040405@pierre-beck.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

currently, mdraid will simply block and wait for the underlying layers 
to execute commands and does not handle timeouts on its own.

In a perfect world, disks will respond within a limited timeframe when 
for example a bad sector is encountered. Unfortunately, I see even disks 
with set TLER that don't. Then, with a configurable timeout, Linux 
Kernel will reset the device in question, then the bus, then the 
controller. This process takes time (and I think the bus / controller 
reset is really adding to that time and should be optional in the first 
place) during which data is unavailable, though there is redundancy and 
another device is ready to respond.

For a read operations, things are simple: mdraid can re-issue the read 
on the redundant device(s) and deliver data. For write operations, I see 
no other option than kicking the disk from the array. With write-intent 
bitmaps in place, the disk can be re-added and resync fast once it is 
available again.

If possible, commands sent to the bad disk should be aborted, so Kernel 
doesn't reset the bus.

To add response time management, the timeout could work with several 
values and sum up like this:

max_response_time_ms = 20
timeout_ms = 10000

Every request would measure response time. If response time - 
max_response_time_ms > 0, decrease timeout_ms temporarily by that value. 
So slow disks would be kicked by the same timeout mechanism.

Greetings,

Pierre Beck

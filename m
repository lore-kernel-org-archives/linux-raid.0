From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Growing after replacing with larger discs
Date: Fri, 12 Mar 2010 17:39:47 +0000
Message-ID: <4B9A7C63.6090202@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Before I have to go to a customer's premises and try it, I wanted to ask 
if anyone had already done anything like this: I have a CentOS 5 system 
with 0.90 metadata and type fd partitions with RAID-5 over 3 discs. I 
want to grow it by replacing the drives. If I dd the small partitions 
onto larger ones on the new discs, then reboot, will the system 
recognise the RAID-5 - which now has its metadata somewhere in the 
middle of the paritions not at the end - so that I can then --grow?

Cheers,

John.

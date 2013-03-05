From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Kernel 3.7.9 RAID6 hot replace success
Date: Tue, 05 Mar 2013 09:53:25 +0800
Message-ID: <51355015.7080301@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

G'day all,

I have a RAID6 of 10 2TB drives. One started to grow bad sectors at an 
alarming rate, so rather than fail and replace the drive I thought I'd 
use the hot replace method.

Add spare to array
echo want_replacement > /sys/block/md0/md/dev-sdm/state
Wait 6 hours
Remove failed drive
Job done.

Last time I tried this (lots of kernel versions ago) I had all sorts of 
issues with removing the failed drive and other sticky stuff that 
required rebooting to clean up. This "just worked".

Regards,
Brad

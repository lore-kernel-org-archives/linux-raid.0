From: Fabio Muzzi <liste@kurgan.org>
Subject: MD raid and different  elevators  (disk i/o schedulers)
Date: Thu, 29 Jul 2010 12:12:30 +0200
Message-ID: <4C51540E.9050005@kurgan.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


I have tried to find information about this question in google, but 
found nothing.

The question is: are there issues using different disk i/o schedulers 
(by appending elevator=xxx to the kernel boot command line) when using 
md RAID1 or RAID5?

I seem to remember that someone told me that using elevator=deadline can 
cause perfectly good disks to be kicked from the RAID because of some 
latency issues that make the disk seem unresponsive (and dead) to the 
raid software.

Is this true? Are there compatibility issues using different i/o 
schedulers with software raid?


Thanks

-- 

Fabio "Kurgan" Muzzi

(worried Linux sysadmin)


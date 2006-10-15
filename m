From: Lane Brooks <lbrooks@mit.edu>
Subject: Multiple Disk Failure Recovery
Date: Sat, 14 Oct 2006 22:29:16 -0400
Message-ID: <45319CFC.4050708@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a RAID 5 setup with one spare disk.  One of the disks failed, so 
I replaced it, and while it was recovering, it found some bad sectors on 
another drive (unreadable and uncorrectable SMART errors).  This 
generated a fail event and shut down the array.

When I restart the array with the force command, it starts the recovery 
process and dies when it gets to the bad sectors, so I am stuck in an 
infinite loop.

I am wondering if there is a way to cut my losses with these bad sectors 
and have it recover what it can so that I can get my raid array back to 
functioning.  Right now I cannot get a spare disk recovery to finish 
because these bad sectors.  Is there a way to force as much recovery as 
possible so that I can replace this newly faulty drive?

Thanks
Lane

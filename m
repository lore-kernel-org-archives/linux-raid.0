From: Robert Heinzmann <Robert.Heinzmann@gmx.net>
Subject: Raid1 "synchronous" mirror question
Date: Tue, 06 Dec 2005 10:46:55 +0100
Message-ID: <43955E0F.6090704@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I'm currently trying to understand the "flow" of the I/O in Linux raid1 
devices in regard to superblock updates and resynces on machine crashes. 
I looked at the source (2.6 kernel) and made some guesses about the 
working of  the raid1 kernel module. The problem is that I'm not an 
kernel expert so I try to point out the basic algotithms and it would be 
great if some expert could give ma a yes/no answer :)

1) As soon as the first write is made, the superblock is updated and 
mddev->in_sync is set to 0
2) There is a machanism (can you tell me which part of the kernel does 
this ?) that looks if all write requests have been written to both disks 
and if no write requests are queued anymore, the superblock is updated 
with the information mddev->in_sync=1


The question is, whats the maximal time that data can be "out of sync" 
on both mirrors making the mirror an NON-synchronous mirror ?
Is there a way to make the mirror a "real" synchronous mirror ?


Regards,
Robert Heinzmann

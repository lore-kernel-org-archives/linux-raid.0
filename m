From: Vladimir Milovanovic <vlad@webmail.co.za>
Subject: Tiobench results LOWER with more threads
Date: Tue, 15 Oct 2002 10:20:55 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3DABCFE7.9070701@webmail.co.za>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

OK, just joined the list and rad the faq, and something caught my eye. 
Tiobench results are apparently supposed to INCREASE when there are more 
threads.

What I have is Tiobench results decreasing with more threads. This is my 
setup:

Celeron 633
196 MB PC 133
Adaptec 29160 SCSI controller (PCI)
5 IBM Ultrastar 18XP (18gig, SCSI-3) disks hanging off the Adaptec 
controller
Red Hat 7.3 Linux (2.4.18-3)

Experimenting with different RAID configurations, I have found that I 
can not get more than 32 MB/s from this array with 4 disks, one spare. I 
have actually found out that the disks set the SCSI bus at 40 MB/s 
(since the disks are old) and that in RAID 0 it scales well, the speed 
doubles for two disks, and then the third disk brings in a little more 
performance, and then things topp off at 32 MB/s with four disks. Adding 
the fifth disk gains no extra performance.

Apparently VIA chipsets have problems with PCI bursting, so that is why 
I can't see the full 40 MB/s. That's fine.

But, my tests with tiobench also show that performance decreases as 
extra threads are added. I am testing with a file of 800 MB (approx. 4x 
size of RAM, to get meaningful results) and the decrease with threads, 
while READING only, is consistent in all RAID levels. The write 
performance will sometimes increase, sometimes stay the same.

WHY is this happening? Is it something I have not set up right , or 
what? I am not so much interested in getting more speed out of these old 
disks, they are gonna be replaced soon anyway, but I REALLY want to know 
WHY is this??

Can anyone give me any pointers?
Thanks,
Vlad.



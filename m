From: AndyLiebman@aol.com
Subject: Mis-matched disks RAID 1
Date: Thu, 20 Nov 2003 16:08:40 EST
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <114.2bc61a06.2cee8758@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Can somebody tell me what I have to do to make a RAID 1 array with 
mis-matched disks (1 is 200 GB, one is 160 GB)? 

I am assuming I have to make 2 partitions on the 200 GB drive -- one exactly 
the same size as the 160 GB drive, one with whatever is left. Is that true? 
And is there an easy way to make the big partition EXACTLY the same as the size 
of the 160 GB drive? (When I look at the 160 GB drive with fdisk, I see a size 
that's a certain number of sectors (?)  xxxxxxxxxx+  with a plus sign at the 
end. )

My situation is the following: 
I have 5 Maxtor 160 GB firewire drives and 1 Maxtor 200 GB firewire drive. I 
want to make 3 pairs of RAID 1 arrays and then stripe them as a single RAID 0 
array. 

I have already done essentially the same thing with 6 200 GB drives and it 
works great. But now for the second set of drives I have one that's bigger than 
the rest. I want to be sure I don't have any problems. 

Good advice appreciated. Thanks in advance. 

From: Jonathan Gazeley <jonathan.gazeley@bristol.ac.uk>
Subject: Unsure of changes to array
Date: Wed, 17 Oct 2007 15:04:52 +0100
Message-ID: <47161684.7010604@bristol.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear all,

This is hopefully a simple question for you to answer, but I am fairly 
new to RAID and don't want to risk losing my data!

My setup is as follows:
- I have four 500GB disks. Each disk is split into a 5GB partition, and 
a 495GB partition.
- The four 5GB partitions are in a RAID-5 array, md0. CentOS is 
installed on this 15GB partition.
- The four 495GB partiions are in a RAID-5 array, md1. This partition 
holds my user data.

However, I have decided I no longer wish to two arrays across the disks. 
I've added a fifth disk on which I have installed the OS without RAID, 
meaning the old md0 is currently unused. Can I simply remove the four 
5GB partitions, and resize the four 495GB partitions to fill the entire 
disk? Will this break anything?

Before anybody tells me off for having the OS on a non-RAID disk, this 
is a home server and therefore high availability is not an issue. But 
keeping my data safe against disk failures is important to me.

Cheers,
Jonathan

----------------------
Jonathan Gazeley
ResNet | Wireless Team
Information Services
----------------------


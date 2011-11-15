From: William Colls <william.colls@rogers.com>
Subject: Rebuilding Raid 1 set up
Date: Tue, 15 Nov 2011 15:21:59 -0500
Message-ID: <4EC2C9E7.6000505@rogers.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


Kubuntu 10.04.1 LTS 64 bit system.

I am about to rebuild my Raid 1 setup, using 2 750GB drives, and I have 
some questions about the recommended best practice.

1. What file system should I use? I have mostly use ext3 file systems in 
the past, and they seem to perform well. I have seen recommendations 
against ext4, and from what I have read ReiserFS seems to be 
problematic. I don't know much about XFS. Are there any others I should 
consider? Most of the files will be "small" (under 1 Mb). Some of the 
directories on it will be exported by both NFS and Samba.

2. Do I need to format the drives individually before building the 
array? I always have in the past, creating a single partition on each 
drive. Is there any advantage to creating 2 (or more) partitions?

3. On advice received earlier, I will specify metadata 1.2.

4. How do I determine the physical sector size for the drive? (They are 
Western Digital). How do I then create my partition(s) to take best 
advantage of this information.?

Thanks for your time.

William.

-- 
I know you believe that you understand what you think I said, but I am 
not sure that you realize that what you heard was not what I meant.

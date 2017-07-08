From: Ram Ramesh <rramesh2400@gmail.com>
Subject: My MD is too big to resize ext4.
Date: Fri, 7 Jul 2017 19:41:13 -0500
Message-ID: <6c827d07-19d8-017b-ca95-5e6f84b7821a@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

I asked in other linux forums and did not get enough info. So I come 
here even though this is not mdadm/RAID issue.

I replaced 3TB disks in my 6-disk RAID6 with 6TB and now my md0 is 24TB. 
I had 32bit version of ext4 on it which can only be grown to 16TB. Any 
one had this issue before and any _/inplace/_ good solution to grow ext4 
to full 24TB? It is unlikely that I will be able to back up and recreate 
file system.

My filesystem is on md0 drive so I guess partitioning and making into 2x 
12TB ext4 will not work. I am not even sure if we can partition md like 
any other disk.

On the web, I only found one solution that required upgrading kernel to 
some very recent one (not in my distro) and getting the bleeding edge 
resize2fs. This makes me nervous. Is there a solution that avoids this.

Ramesh


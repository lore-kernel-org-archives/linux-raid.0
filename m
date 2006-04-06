From: andy liebman <andyliebman@aol.com>
Subject: Partitioning md devices versus partitioining underlying devices
Date: Thu, 06 Apr 2006 11:25:14 -0400
Message-ID: <443532DA.7090809@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I have a fundamental question about WHERE it is best to do partititioning.

Here's a concrete example. I have two 3ware RAID-5 arrays, each made up 
of 12 500 GB drives. When presented to Linux, these are /dev/sda and 
/dev/sdb -- each 5.5 TB in size.

I want to stripe the two arrays together, so that 24 drives are all 
operating as one unit. However, I don't want an 11 TB filesystem. I want 
to keep my filesystems down below 6 TB.

It seems I have two choices:

1)  partition the 3ware devices to make /dev/sda1, /dev/sda2, /dev/sdb1 
and /dev/sdb2.  Then I can create TWO md RAID-0 devices -- /dev/sda1 + 
/dev/sdb1 = /dev/md1, /dev/sda2 + /dev/sdb2 = /dev/md2

OR

2) create /dev/md1 from the entire 3ware devices -- /dev/sda + /dev/sdb 
= /dev/md1 -- and then partition /dev/md1 into two devices.

The question is, are these essentially equivalent alternatives? Is there 
any theoretical reason why one choice would be better than the other -- 
in terms of security, performance, memory usage, etc.

A knowledgeable answer would be appreciated. Thanks in advance.

Andy Liebman

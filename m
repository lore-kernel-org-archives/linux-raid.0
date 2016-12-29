From: Adam Goryachev <adam@websitemanagers.com.au>
Subject: Intel SSD or other brands
Date: Thu, 29 Dec 2016 12:52:10 +1100
Message-ID: <2258c04b-9634-fec5-5ad0-7615d00c4bb4@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

I've spent a number of years trying to build up a nice RAID array for my 
SAN, but I seem to be slowly solving one bottle neck only to find 
another one. Right now, I've identified the underlying SSD's as being a 
major factor in that performance issue.

I started with 5 x 480GB Intel 520s SSD's in a RAID5 array, and this 
performed really well.
I added 1 x 480GB 530s SSD
I added 2 x 480GB 530s SSD

I now found out that performance of a 520s SSD is around 180 times 
faster than a 530s SSD.

-- 
Adam Goryachev
Website Managers
P: +61 2 8304 0000                    adam@websitemanagers.com.au
F: +61 2 8304 0001                     www.websitemanagers.com.au


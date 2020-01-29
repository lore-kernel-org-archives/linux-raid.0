From: Ram Ramesh <rramesh2400@gmail.com>
Subject: Is it possible to break one full RAID-1 to two degraded RAID-1?
Date: Tue, 28 Jan 2020 21:17:50 -0600
Message-ID: <1120831b-13e6-6a5d-8908-ee6a312e7302@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I have my entire debian 9.0 installation (root/usr/home etc) in two nvme 
RAID-1 mirror. Is it possible to break them in to two degraded arrays?

Specifically I want to do this.

 1. Break current debian 9 full RAID1 into two degraded RAID1 A & RAID1  B
 2. Boot only A and upgrade to debian 10 and make sure it works
 3. If it works, add B back into A and get Debian 10 in fully complete RAID1
 4. If it does not work, I boot B and add A back and get back debian 9
    in full working RAID1

Is this possible?

Ramesh

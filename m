From: hank peng <pengxihan@gmail.com>
Subject: why disk errors are more likely to happen on md super block area?
Date: Thu, 24 Mar 2011 09:34:51 +0800
Message-ID: <AANLkTik2W3e7BaHdJ1UPxhQWHXm00NAiesUP0AejV6gp@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi, guys:
I found that when disk errors happened, it is more likely to locate in
md super block area. Kernel messages are like this:
end_request: I/O error, dev sda, sector 1953525000
md: super_written gets error=-5, uptodate=0
In some cases, I check if disk is really failed using 'dd' command and
found that it is OK for read and write on those sectors.

I know that md super block information is located in the end of a
disk, but is it related with this problem? Is it safer to put md super
block in the start area of a disk?


-- 
The simplest is not all best but the best is surely the simplest!

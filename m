From: Ninti Systems <office@ninti.com.au>
Subject: RAID 5 questions
Date: 01 Aug 2004 11:27:56 +0930
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1091325475.2374.11.camel@localhost>
Reply-To: office@ninti.com.au
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I'm about to embark on building a RAID 5 Linux software array with 4
disks (I've only ever built 2 disk RAID 1 arrays before).

Q1: Is it true that Linux can't/shouldn't boot off a RAID 5 array?

Q2: The four disks have identical manufacturer, model and size, but two
are brand new while two have had NTFS filesystems on them. Accordingly,
if I run hdparm -g on them, two disks have these specs:

geometry = 2498/255/63, sectors = 40132503, start = 0

while the other two disks have these specs:

geometry = 39813/16/63, sectors = 40132503, start = 0


Is this an issue with software RAID? 

Thanks
Michael Hall




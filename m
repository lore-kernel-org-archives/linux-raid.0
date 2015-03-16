From: Ankur Bose <ankur.bose@oracle.com>
Subject: Bad Block Management in RAID1 and "Faulty"
Date: Mon, 16 Mar 2015 15:04:04 +0530
Message-ID: <5506A38C.3030002@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de
List-Id: linux-raid.ids

Hi Group , I would like to understand more about bad block management  ( 
esp RAID1 )that given the below link 
http://neil.brown.name/blog/20100519043730  . Highly appreciate any kind 
of help.

1) What happens when a  write  comes on a known bad block ?.

2) When exactly the raid1 decides to make the device "Faulty"? Does that 
depends on the number of bad blocks in the list ie: 512?

Thanks,
Ankur


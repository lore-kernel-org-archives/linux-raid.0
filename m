From: Christian Feddern <rangerone@web.de>
Subject: Problem with superblock magic
Date: Fri, 11 Apr 2003 11:27:31 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3E968A83.4040601@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello,

I've send an email two days ago but got no response, so I am trying 
again, maybe the mail didn't make it through.
After I updated from Suse 8.1 to 8.2 my software raid doesn't do autorun 
anymore. I somehow got a bad magic number in the superblock of /dev/md0.
The superblocks of all the partitions which form the raid are ok.
Any idea how I can rewrite only the superblock on /dev/md0 ?

Thx

Christian

P.S The update from 8.0 to 8.1 worked fine. No trouble there.
--
Christian Feddern
rangerone@web.de


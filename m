From: Albert Pauw <albert.pauw@gmail.com>
Subject: Disks with 4k sectors
Date: Sun, 27 Mar 2011 10:15:05 +0200
Message-ID: <4D8EF209.60707@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

  When I would use  new disks with 4kB sectors (3 TB disks e.g.) instead 
of 512B with mdadm to create a RAID 1/5/6 set, are there any special 
things to look out for?

I would assume choosing chunk sizes of multiples of 4kB.

Any more thoughts or ideas?

Cheers,

Albert



From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: how to synchronize two devices (RAID-1, but not really?)
Date: Tue, 15 May 2007 10:57:46 +0200
Message-ID: <4649760A.1060805@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a RAID-10 setup of four 400 GB HDDs. As the data grows by several 
GBs a day, I want to migrate it somehow to RAID-5 on separate disks in a 
separate machine.

Which would be easy, if I didn't have to do it online, without stopping 
any services.


M1 - machine 1, RAID-10
M2 - machine 2, RAID-5


My first idea was to copy the data with rsync two or three times 
(because the files change, I would stop the services for the last run) - 
which turned out to be totally unrealistic - I started rsync process two 
days ago, and it still calculates files to be copied (over 100 million 
files, with hardlinks etc.).


So my second idea is to do some sort of RAID-1-over-iSCSI of these two 
arrays - I don't care if it's gonna take long, what's important, I don't 
want to stop the services.

So let's say M2 exports RAID-5 md to M1 over iSCSI, and M2's RAID-5 is 
available to M1 as /dev/sdr.

Now, is there a way I can synchronize the contents of RAID-10, or 
/dev/md10, with the contents of RAID-5, or /dev/sdr, when /dev/sdr is 
bigger then /dev/md10, and /dev/md10 has to be synchronized on /dev/sdr, 
not the way around (I would expand the filesystem later with ext3online)?

Perhaps "dd" tool would be fine if the data didn't change.

RAID-1 would be great, as it tracks changes, but I'd have to create 
RAID-1 over: /dev/md10 and /dev/sdr. Wouldn't it destroy the contents of 
/dev/md10?


Ideas how to synchronize the contents of two devices (device1 -> device2)?


-- 
Tomasz Chmielewski



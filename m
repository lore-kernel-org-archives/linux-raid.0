From: Ruth Ivimey-Cook <ruth@ivimey.org>
Subject: Rescue md/6 array: advice please
Date: Sat, 24 Mar 2012 21:36:16 +0000
Message-ID: <4F6E3E50.3010000@ivimey.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Folks,

Just wanted some reassurance: my raid6 array died today when a 
controller died and took 3 of 5 disks out of the array. I think/hope the 
disks (1TB enterprise Seagate) are ok, but obviously the event counts 
are now different. Right now I don't have enough ports to plug in all 
disks at once so have just verified one of the missing disks does still 
work: am getting new board next week which should sort that lack. The 
event count of the missing disk was about 20 events lower than the 
latest disk's count. I do have a backup, but would prefer not to have to 
rely on it: if there is an error in restoring from the backup I don't 
have a third line of defence!

I believe the correct way forward is to force an mdadm assemble, with 
the failed-disk and readonly options, to build a minimal (3 of 5?) 
array, then assuming it works do an fsck to see if it checks out, then 
rotate for the best combination, then rebuild without readonly, then add 
in the rest of the failed disks.

Thanks in advance,
Ruth

-- 
Software Manager&  Engineer
Tel: 01223 414180
Blog: http://www.ivimey.org/blog
LinkedIn: http://uk.linkedin.com/in/ruthivimeycook/


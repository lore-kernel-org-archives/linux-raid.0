From: Alex Lilley <alex@redwax.co.uk>
Subject: Raid 5 --grow to fewer, larger drivers
Date: Mon, 24 Nov 2008 12:56:51 +0000
Message-ID: <492AA493.6080605@redwax.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Senario:  raid5 with  4 x 120gb.

aim:  raid5 with 3 x 250gb

3 x 120gb disks replaced with 3 x 250gb, array has been rebuilt/resync'd 
at original size. Can we remove the remaining 120gb drive and reshape 
the array over the remaining 3 drives using all the new space.

I guessed --grow --raid-devices=3 --size-max would work but returns "can 
change at most one of size, raiddisks, bitmap and layout"

I then --failed and --remove the remaining 120gb drive and tried --grow 
--raid-devices=3 but receive "Cannot reduce number of data disks (yet)".

I am therefore slightly stumped!

Is this something that is actually possible or something that is planned 
for because as the size of disk drives multiplies and the desire to keep 
tabs of power usage increases it is likely that we will want to reduce 
the number of disk, besides the obvious increased risk of failure 
introduced by having a greater number of drives.

Regards

Alex

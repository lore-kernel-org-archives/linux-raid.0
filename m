From: Aaron Gee <cluge1669@netscape.net>
Subject: changing MD device
Date: Wed, 14 Jan 2004 16:44:39 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4005B847.5090306@netscape.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a system up and running, the root directory is mounted on device 
/dev/md0 which is a raid1 of 2 IDE drives.  My question is, how can I 
change it so that the my raid device is /dev/md1 not /dev/md0 and not 
loose the data.  Originally I was thinking of booting with a rescue 
disk, breaking the raid1, and rebooting.  Once rebooted create the raid 
device again as /dev/md1.  Is there a simpler way to do this? 

Why do I want to do this?  I have several external FC arrays with 
software raid, and XFS file systems using an external log dev that is 
/dev/md0 which is defined as a raid1 on the same array.  I want to be 
able to recover the external arrays - therefore my /dev/md0 on the 
backup machine needs to change to /dev/md1.

TIA
cluge


From: iggy <info@kit-it.de>
Subject: Reshapeing after 4 Days with 0.0% progress
Date: Mon, 27 Jun 2016 11:21:42 +0000 (UTC)
Message-ID: <loom.20160627T131058-485@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Guys,

i wanted to grow my raid 5 with 3 3tb devices to 4 of 3tb devices.

1) i add a new device
2) i grow (please ask me not why i do this) with the help of the button in
webmin instead of the cli 


cat /proc/mdstat:....

After 3 Days of 0.0% of reshaping progress i decided to abort this procedure
- because for me it seems like an error!


Now my raid disapears and i'm not able to mount and backup my data, because
of degraded. So i have no backup file during reshaping.

is there any way to mount my md0 to backup a fews of data before i complete
recreate my raid array?

i hofe for answers..
THANKS!




From: "Patrick H." <linux-raid@feystorm.net>
Subject: disable creation of md127
Date: Fri, 10 Dec 2010 14:38:30 -0700
Message-ID: <4D029DD6.5070705@feystorm.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

How can I prevent the MD driver from auto-creating md127 on boot?
I have a server which is exporting /dev/sdb1 via iSCSI. The remote 
client for this device is using it in a raid device so it has raid 
metadata on it. However because of this, when the target server boots 
up, the md driver shoves it into md127. And because of this, the iSCSI 
target daemon (tgtd) wont export the device as its now part of a raid 
device.
The partition type is 0x83, not 0xfd.

RHEL6 2.6.32-71

-Patrick

From: "Wojcik, Krzysztof" <krzysztof.wojcik@intel.com>
Subject: Single-drive RAID0
Date: Tue, 8 Feb 2011 16:15:53 +0000
Message-ID: <BE2BFE91933D1B4089447C644860408067197930@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil,

I try to create a single-drive RAID0 array with data preservation.
It means I have a single disk with partitions and data on them. 
I would like to migrate this single disk to RAID0 array and then grow it to N devices.
Of course I expect partitions with my useful data will be mapped to corresponding MD block devices (/dev/md126p1, /dev/md126p2 etc.). Indeed they are but when I try to mount new block device it disappears from /dev directory and mount is not succeeded. 
/var/log/messages shows all the time: 
md126: p1
md126: detected capacity change from 0 to xxxxxxxxxxxxx

It is not always reproducible but very often.
I try this operation on 0.9 and imsm metadata. Symptoms are similar.

Do you have any suggestions? How to fix this issue?

Regards
Krzysztof

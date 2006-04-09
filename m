From: Martin Stender <martin@stender.com>
Subject: A failed-disk-how-to anywhere?
Date: Sun, 9 Apr 2006 15:53:56 +0200
Message-ID: <C1F5413C-E9AB-4331-A901-1FBB645719DF@stender.com>
Mime-Version: 1.0 (Apple Message framework v746.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi there!

I have two identical disks sitting on a Promise dual channel IDE  
controller. I guess both disks are primary's then.

One of the disks have failed, so I bought a new disk, took out the  
failed disk, and put in the new one.
That might seem a little naive, and apparently it was, since the  
system won't boot up now.
It boots fine, when only the old, healthy disk is connected.

By the way, all three partitions are raided - including /boot ...

Anyway, I have removed the old disk from the Raid with:
#mdadm /dev/mdo --remove /dev/hde1
#mdadm /dev/md1 --remove /dev/hde2
#mdadm /dev/md2 --remove /dev/hde3

- but the the problem persists.

I can't seem to find a decent 'How-To' - so how it this supposed to  
be done?

Thanks in advance!
Martin

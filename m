From: Patrice <mailinglist@pboenig.de>
Subject: I was dump, I need help.
Date: Sun, 1 May 2016 11:54:27 +0200
Message-ID: <5725D253.6050202@pboenig.de>
Reply-To: Patrice <mailinglist@pboenig.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I figured out that the Event counter is 343 on all 4 disks.
But can I just do
mdadm --assemble --force /dev/mdX <list of devices>
and it's all ok? I am worried about that it`s not and when I do that the 
RAID will be distroyed. :-S

Best regards
Patrice

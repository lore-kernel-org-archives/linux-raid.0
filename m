From: Paul Menzel <pmenzel@molgen.mpg.de>
Subject: Where to best put the journal device physically?
Date: Tue, 9 May 2017 18:10:11 +0200
Message-ID: <5a7aa1b2-5bfb-3123-3abf-3dd8231c54ae@molgen.mpg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Linux RAID folks,


One stupid practical question, for using the journalling support [1].

Currently, enclosures with 16 3.5 inch drives and hardware RAID 
controllers are used here. Almost all systems have such a hardware RAID 
controller, so moving a enclosure is as simple as plugging the cable 
into a different controller card, and updating some maps.

When using a software RAID with an SSD as a journal device, I see the 
following options.

1.   We need to keep track if a system has a journal device installed, 
and if not install one, when moving an enclosure. (Make sure there are 
as many slots for SSDs as you have enclosures.)
2.   We make sure, in every system, there is a spare SSD drive, usable 
as journal device. (Make sure there as many slots for SSDs as you have 
enclosures.)
3.   There are enclosures, which provide a slot for such a journal 
device. Maybe even battery backed?

Are there more options?

It’d be awesome, if you shared, how you deal with this, or point me to 
the right direction.


Kind regards,

Paul


[1] 
https://kernelnewbies.org/Linux_4.11#head-b75ccfe3ece97a066328c2b2a782434291bf00c6

From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Subject: What is the sector size in /sys/block/md*/md items?
Date: Sat, 22 Feb 2014 12:11:58 +1100
Message-ID: <5307F95E.70501@eyal.emu.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: list linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I am reading the kernel Documentation/md.txt.

It explains what md the items in sysfs mean. It refers a few times to "sectors".
- Are we talking 512 bytes or the underlying physical disk sector size?
- Do all disks in an array need to have the same sector size?

Seeing how md can be built over physical disks, partitions, loop mounts and more,
I expect that 'sector' is short for '512 bytes' and real disk sector size is not
relevant here.

Nevertheless, there is md*/queue/hw_sector_size which gives 512. So there are now
a few sector sizes (the array and the underlying devices) and the text does not
make it clear which is used where. I assume the array cluster size is the one
referred to in this document.

TIA

--
Eyal Lebedinsky (eyal@eyal.emu.id.au)

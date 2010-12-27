From: "D.S. Ljungmark" <spider@skuggor.se>
Subject: md-raid and block sizes
Date: Mon, 27 Dec 2010 13:00:28 +0100
Message-ID: <1293451228.3266.9.camel@Waves.darkmere>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Spider <spider@skuggor.se>
List-Id: linux-raid.ids

Hello, 
  With the advent of the WD*EARS drives and the "advanced partitioning"
system that requires 4k blocks, I wanted to pop a quick question to see
how the md metadata is aligned and how it should be aligned to get
proper performance out of the devices.

So, For raid1,  I'll assume there is some metadata-overhead on the
drives, how large is this block? Will there be need to make a partition
on the md-device in order to get proper alignment of filesystem =>
platters?

for both raid1 and 5/6 levels, what are the appropiate stride-sizes for
ext3/4?

For more advanced raid configurations (5-6), how should the ext3/4
stripe size be configured?


Yes, a lot of similarly naive questions, however, I'm asking mostly
because of how devices are changing from 512 to 4k sized blocks, with
quite interesting changes in performance, and I wanted to figure out
what is the current state of software raid. At which "level" of the
stack: (partition) raid (partition) filesystem ,  do you have to account
for the block sizes in order to not degrade performance of the devices.

( In a perfect world I'd be able to purchase a stack of the devices and
test for myself and come back with a report. However, money and hardware
is a scarce resource ;)

ps.  please keep me CC'd as I'm not subscribed to the list.


// Spider



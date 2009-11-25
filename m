From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Odd raid5 reshape behaviour
Date: Wed, 25 Nov 2009 11:09:23 +0100
Message-ID: <874ooiq5kc.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

I'm reshaping a raid5 from 3 to 4 disks and I'm seeing something odd.

md2 : active raid5 sda3[3] sdd3[2] sdc3[1] sdb3[0]
      2832114688 blocks super 0.91 level 5, 64k chunk, algorithm 2 [4/4] [UUUU]
      [==============>......]  reshape = 73.2% (1037811200/1416057344) finish=276.4min speed=22802K/sec


Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
sda3            792.90         0.00     27459.20          0     274592
sdb3            433.70         0.00     27459.20          0     274592
sdc3            393.20         0.00     27459.20          0     274592
sdd3            399.10         0.00     27458.80          0     274588

The reshape has copied all the old stripes to new positions and now I
guess it fills the drives with zeroes for the remainder.

But why are they roughly twice as many tps on sda, which is the new
disk? All drives write the same amount of data but sda seems to write
it in twice as many chunks.

MfG
        Goswin

From: Linux Raid Study <linuxraid.study@gmail.com>
Subject: iostat with raid device...
Date: Fri, 8 Apr 2011 12:55:39 -0700
Message-ID: <BANLkTi=6uvCsQTpCi4xLUWzx5X7o99_=5g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: linuxraid.study@gmail.com
List-Id: linux-raid.ids

Hello,

I have a raid device /dev/md0 based on 4 devices sd[abcd].

When I write 4GB to /dev/md0, I see following output from iostat...

Ques:
Shouldn't I see write/sec to be same for all four drives? Why does
/dev/sdd always have higher value for  BlksWrtn/sec?
My strip size is 1MB.

thanks for any pointers...

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.02    0.00    0.34    0.03    0.00   99.61

Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
sda               1.08       247.77       338.73   37478883   51237136
sda1              1.08       247.77       338.73   37478195   51237136
sdb               1.08       247.73       338.78   37472990   51245712
sdb1              1.08       247.73       338.78   37472302   51245712
sdc               1.10       247.82       338.66   37486670   51226640
sdc1              1.10       247.82       338.66   37485982   51226640
sdd               1.09       118.46       467.97   17918510   70786576
sdd1              1.09       118.45       467.97   17917822   70786576
md0              65.60       443.79      1002.42   67129812  151629440

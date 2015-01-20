From: Apple Yin <bravery.apple@gmail.com>
Subject: Is it possible to use bad_blocks to simulate write_error and activate hot-replace?
Date: Tue, 20 Jan 2015 16:25:58 +0800
Message-ID: <CAFvwruiLUQNiZTMz6bRYEa4HVKHUqA_Q52K0aQ-jvooZDeKQVg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I want to test hot-replace when a write error is recorded in a
bad-block log. Here is my steps:

1. create raid5 with 3 disks (sdb sdc sdd), and 1 spare (sde)

2. echo 2097152 512 > /sys/block/md192/md/dev-sdb/bad_blocks  /* set 1
badblock from 1G of sdb*/

3. dd if=/dev/zero of=/dev/md192 bs=1M count=1024 seek=2048 /* from 2G of md */
    dd if=/dev/zero of=/dev/md192 bs=1M count=1024 seek=2000 /* near to 2G */


No write error happen, sdb is not marked as want_replacement and not
start the rebuild. Anyone help ?

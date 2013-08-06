From: Dong Wu <archer.wudong@gmail.com>
Subject: when md raid1 superblock is bad block, what happens
Date: Tue, 6 Aug 2013 09:14:05 +0800
Message-ID: <CAAL-TMcqej1YYYoCJr3XV7GONYzUR4=8poMnzMcrzTjP7N84KQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi all, I have some questions about raid1 superblock and bad block.
When I create raid1 with two disks, the md will write superblock to
the disk, if the location of superblock is bad, what will happens?
Just report create error or add the block to bad-block-list and
redirect superblock to another place?
another question, how many bad blocks can be added to bad-block-list,
when the bad-block-list is full, the raid will degrade?

Thand you

Wu Dong

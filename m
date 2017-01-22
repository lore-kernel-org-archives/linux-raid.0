From: Salatiel Filho <salatiel.filho@gmail.com>
Subject: Input/Output error reading from a clean raid
Date: Sun, 22 Jan 2017 11:08:40 -0300
Message-ID: <CAGmni9p7T5VQsSGQrwkpYgV=H4B-pjXtg8TxnuWst-FQSJh_fA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I am trying to recover a few  files from my backup. The backup is on a
raid 5 + ext4.
There are several files where i get I/O error. The raid appears to be
clean and fsck shows no errors. Any ideas what could it be ?

md1 : active raid5 sdd1[0] sdg1[4] sdf1[2] sde1[1]
      3220829184 blocks super 1.2 level 5, 512k chunk, algorithm 2 [4/4] [UUUU]
      bitmap: 1/8 pages [4KB], 65536KB chunk



[]'s
Salatiel

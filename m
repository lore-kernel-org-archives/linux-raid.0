From: "John Stoffel" <john@stoffel.org>
Subject: Re: Input/Output error reading from a clean raid
Date: Sun, 22 Jan 2017 19:18:19 -0500
Message-ID: <22661.19403.314279.130591@quad.stoffel.home>
References: <CAGmni9p7T5VQsSGQrwkpYgV=H4B-pjXtg8TxnuWst-FQSJh_fA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGmni9p7T5VQsSGQrwkpYgV=H4B-pjXtg8TxnuWst-FQSJh_fA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Salatiel Filho <salatiel.filho@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Salatiel> I am trying to recover a few files from my backup. The
Salatiel> backup is on a raid 5 + ext4.  There are several files where
Salatiel> i get I/O error. The raid appears to be clean and fsck shows
Salatiel> no errors. Any ideas what could it be ?

Salatiel> md1 : active raid5 sdd1[0] sdg1[4] sdf1[2] sde1[1]
Salatiel>       3220829184 blocks super 1.2 level 5, 512k chunk, algorithm 2 [4/4] [UUUU]
Salatiel>       bitmap: 1/8 pages [4KB], 65536KB chunk

It would help if you could post the error(s) you're getting, along
with any output from dmesg during that time.  Have you done a full
scan of the disk looking for errors?  You might just have silent
read errors in your array.  So as root do:

   # echo check >>/sys/block/md??/md/sync_action

where md?? is the name of your md array you want to check.  You can
get the name from:

   cat /proc/mdstat

and of course it would help to post that info as well if you want more
help.

John

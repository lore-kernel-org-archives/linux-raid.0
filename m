From: Srinivasa S <srinivasa.s@gmail.com>
Subject: a minor query - please help
Date: Thu, 23 Dec 2004 12:34:51 +0530
Message-ID: <8f8a519404122223042106571b@mail.gmail.com>
Reply-To: Srinivasa S <srinivasa.s@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have configured a 3 disk raid5 on my linux system (fedora core 1
running 2.6.5-1.358 OS). I am basically trying to alter the RMW method
a bit, which I think might improve performance.

Multiple writes come to a stripe at the same time.
Here is the output of the debug stmts I've put in raid5.c code:
-----

Dec 23 11:16:01 raider kernel: check 2: state 0x4 read 00000000 write
2456be00 written 00000000
Dec 23 11:16:02 raider kernel: check 1: state 0x1 read 00000000 write
00000000 written 00000000
Dec 23 11:16:02 raider kernel: check 0: state 0x4 read 00000000 write
41fc8440 written 00000000
Dec 23 11:16:02 raider kernel: locked=0 uptodate=1 to_read=0
to_write=2 failed=0 failed_num=0

-----

Is there any method by which I can make only one write go through at a time?
I'd be glad if any of you could reply to this... 

Regards, 
Srinivasa S

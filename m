From: "Loris-Guillaume Minoia" <miguillo@hotmail.com>
Subject: softraid5 disk order check
Date: Wed, 24 Sep 2003 03:19:41 +0000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <BAY2-F101w3erX5AbEm0000ed9e@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,
I need some infos about array reconstruction. I moved 3 raid5 disk (after 
processor auto-flaming) to another mainboard with only 1 ide controller...

i'm not sure disk order is correct and the superblocks were corrupted so i 
force the superblock to be rewitten.
Before doing really really bad manipulation I need to be sure what make 
reconstruction.

Is disk order important?
How to check disk order from data dump?
What will reconstruction really do?
As of the XOR's proprieties will a parity reconstruction be harmless, 
assuming no data corruption?
How can I check that reconstruction was successfull? Without mounting? 
mounting read-only?

Thanks for helping,

Loris

_________________________________________________________________
MSN Messenger : discutez en direct avec vos amis ! 
http://www.msn.fr/msger/default.asp


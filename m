From: "Donghui Wen" <dhwen@protegonetworks.com>
Subject: badblock handling
Date: Wed, 4 Feb 2004 20:45:36 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <001601c3eba2$e6110410$df01010a@moon>
References: <20040204122317.K27780@forte.austin.ibm.com><Pine.LNX.4.44.0402041726350.20232-100000@coffee.psychology.mcmaster.ca><20040204164946.P27780@forte.austin.ibm.com> <16417.31540.78193.699721@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
Cc: Neil Brown <neilb@cse.unsw.edu.au>
List-Id: linux-raid.ids

Hi,
     I am running a server with Linux software-raid (3ware controller). But
from time to time,
a disk is kicked out by md. This will happen when 3ware card reports a
unrecovered read error
for a sector. But when I run raidhotadd, the disk can added back to raid
with no problem.
     So my questions are:
        (1) Will md  kick out one disk if it find out ONE bad block?
        (2) Is it possible to set up a threshold, only the amount of bad
blocks pass this threshold,
            the disk will be kicked out.
        (3) Is it possible to remap the bad blocks to some spare blocks
automatically on the fly?

Thanks!

Donghui


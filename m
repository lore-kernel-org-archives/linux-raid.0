From: "3tcdgwg3" <3tcdgwg3@prodigy.net>
Subject: raid5, 2 drives dead at same time,kernel will Oops?
Date: Mon, 19 May 2003 17:33:57 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <021301c31e67$804eab90$7b07a8c0@pluto>
References: <3EB8441F.8070606@fugmann.dhs.org> <16056.19633.400369.451156@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I am trying to simulate a case that two drives
in an array fail ad same time.
I use two ide drives, I try to create a 
raid 5 array with 4 arms, created as following:

/dev/hdc1
/dev/hde1
/dev/hdc2
/dev/hde2

This is just for test, I know create two arms on
one hard drive doesn't make much sense.


Anyway, when I run this array, if I power off one
of hard drive (/dev/hde) to simulate two arms failing 
at same  time in an array, I got system Oops. I am using
2.4-18 kernel.

Anyone can tell me if this is normal? or if there is a fix for this?

Thanks in advance.

Here are the output:

=================================
hde: drive not ready for command

md: updating md0 RAID superblock on device

md: (skipping faulty hde2 )

md: hdc2 [events: 00000002]<6>(write) hdc2's sb offset: 3469952

md: (skipping faulty hde1 )

md: hdc1 [events: 00000002]<6>(write) hdc1's sb offset: 16064896

md0: no spare disk to reconstruct array! -- continuing in degraded mode

md: recovery thread finished ...

md: recovery thread got woken up ...

md0: no spare disk to reconstruct array! -- continuing in degraded mode

md: recovery thread finished ...

sector=561a8 i=0 00000000 00000000 8132e840 0

kernel BUG at raid5.c:309!

kupdated(7): Oops

================================================



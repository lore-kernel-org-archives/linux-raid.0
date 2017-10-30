From: Reindl Harald <h.reindl@thelounge.net>
Subject: Re: Raid 5 array down/missing - went through wiki steps
Date: Mon, 30 Oct 2017 19:15:50 +0100
Message-ID: <e9035e7c-30d4-2014-563c-a709d94c8d8f@thelounge.net>
References: <CAA4aoFardnK8fOck4kkCWeYNZc=8-03FJzn6KxS6K9wuYN5bdg@mail.gmail.com>
 <e917e077-a87e-5322-68dd-e25b53bf7678@youngman.org.uk>
 <CAA4aoFatrJQFPHOUm9C6LjUAeNkSE9eH08T8xphuYNPErVg=QQ@mail.gmail.com>
 <59F51E3C.1050509@youngman.org.uk>
 <CAA4aoFb-QoHoL0ucTPXiCJMPXfxTtXOF51UjzRC+ViLHEvkW1g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAA4aoFb-QoHoL0ucTPXiCJMPXfxTtXOF51UjzRC+ViLHEvkW1g@mail.gmail.com>
Content-Language: de-CH
Sender: linux-raid-owner@vger.kernel.org
To: Jun-Kai Teoh <kai.teoh@gmail.com>, Wols Lists <antlists@youngman.org.uk>
Cc: mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



Am 30.10.2017 um 19:08 schrieb Jun-Kai Teoh:
> Thanks for all the responses, Mark, Anthony and Wol.
> 
> I have another hard drive on the way, just in case sda is truly dead.
> I had no idea that when a drive "dies" in a RAID5 array - nothing
> would notify me

on a proper distribution you have mdmon running which sends a mail when 
a drive fails - see below - the problem is that you never tested the 
behavior what happens when you plug out a disk before place data on the 
array, doing so you would have found out how to make sure you get notifies

-------- Weitergeleitete Nachricht --------
Betreff: Fail event on /dev/md0:srv-rhsoft.rhsoft.net
Datum: Wed,  3 Dec 2014 11:32:35 +0100 (CET)
Von: mdadm monitoring <root@srv-rhsoft.rhsoft.net>
An: root@srv-rhsoft.rhsoft.net

This is an automatically generated mail message from mdadm
running on srv-rhsoft.rhsoft.net

A Fail event had been detected on md device /dev/md0.

It could be related to component device /dev/sdb1.

Faithfully yours, etc.

P.S. The /proc/mdstat file currently contains the following:

Personalities : [raid1] [raid10] md2 : active raid10 sda3[4] sdc3[5] 
sdd3[0] sdb3[3]
       3875222528 blocks super 1.1 512K chunks 2 near-copies [4/4] [UUUU]
       bitmap: 1/29 pages [4KB], 65536KB chunk

md1 : active raid10 sda2[4] sdc2[5] sdb2[3] sdd2[0]
       30716928 blocks super 1.1 512K chunks 2 near-copies [4/4] [UUUU]
       bitmap: 1/1 pages [4KB], 65536KB chunk

md0 : active raid1 sda1[4] sdb1[3](F) sdd1[0] sdc1[5]
       511988 blocks super 1.0 [4/3] [UUU_]
       unused devices: <none>

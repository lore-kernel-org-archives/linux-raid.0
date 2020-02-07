From: Reindl Harald <h.reindl@thelounge.net>
Subject: Re: Is it possible to break one full RAID-1 to two degraded RAID-1?
Date: Fri, 7 Feb 2020 15:55:15 +0100
Message-ID: <fe7b1e80-ebbb-da9f-dd09-2d10b4678851@thelounge.net>
References: <1120831b-13e6-6a5d-8908-ee6a312e7302@gmail.com>
 <aa41492c-1ad7-070f-9bc6-646977364758@thelounge.net>
 <2c4fedff-a1c9-6ca3-5385-72b542a4a0b4@gmail.com>
 <551449ed-49f9-e567-09d3-981f4cf9eea9@thelounge.net>
 <5E32855D.3020906@youngman.org.uk>
 <0c70c04f-d8d0-0c44-e603-46c101b21cc1@gmail.com>
 <5E3D2D9C.8020908@youngman.org.uk>
 <42332f03-4c16-5f8f-0e9e-a21ddedd4f5b@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <42332f03-4c16-5f8f-0e9e-a21ddedd4f5b@gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Ram Ramesh <rramesh2400@gmail.com>, Wols Lists <antlists@youngman.org.uk>, Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



Am 07.02.20 um 15:49 schrieb Ram Ramesh:
>>> 4. Make both bootable. (I suppose I need to change UUID of md1
>>>     partitions. I suppose that is easy)
>> Yes it's easy. Yes it should have been done a LOOONG time ago.
> Not if you break md0 into degraded md0 and md1. grub.cfg need to be
> updated after that fact and UUID update is only doable after breakup.
> Again not sure if I am missing something important implied by LOONG in
> your answer

grub itself is installed before the RAID and there is no need to change
any UUID - you just spit out one of the disks from your RAID, work in
degraded mode and if everyhting goes wrong you boot with a recue media
and assemble that disk, zero the one with the damaged OS and resync

From: Mario Giammarco <mgiammarco@virgilio.it>
Subject: RAID1 VS RAID5
Date: Sun, 26 Oct 2003 12:24:14 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1067167454.1222.102.camel@cala>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,
I would like to buy new SCSI hard disk to be used with lsi 160
controller in 32 bit pci.

I can choose:

- RAID5 of three Maxtor Atlas 10K II 9gb
- RAID1 of two   Maxtro Atlas 10K III 18gb

My problem is: I have seen that RAID1 code does not interleave reads so
it does not improve performance very much putting two hard disks.

Is there a patch to change raid1 behaviour?

In linux 2.6.0 is it better?

Thanks in advance for any reply.

-- 
Mario Giammarco



From: Jean-Michel Hautbois <jhautbois@gmail.com>
Subject: HW RAID with ASM 1062R
Date: Thu, 8 Jun 2017 19:41:24 +0200
Message-ID: <CAL8zT=gMdGEN86f8t+XnZe-cZawirmQxTKFC0UF3cg6bW8NSDQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi !

I am quite new with HW RAID drivers, and I want to support a PCIe /
2xSATA board based on ASM1062R chip.
It is seen as AHCI so Linux can see the disks and that's something.
But now, I want to modify the configuration to use RAID-0 or RAID-1,
and there is nothing right now, according to my search ?
This chip understands vendor commands using a CMD/ACK message with MMIO offsets.

I now have several questions (maybe irrelevant :)) :
- Where should this driver be ? md ? scsi ?
- These vendor commands are under NDA right now, so I think it should
not be written in the driver obviously, but I am pretty sure there is
a nice way to do it ;-) ?
Basically, this is a 32 bits word with CMD and some args, and an ACK
with some args, which should be parsed.
Should it be in a specific proprietary user space application (yuck !) ?

Thanks for your help, this is a very early stage exploration, so feel
free to give any idea :D.
JM

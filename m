From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: Trouble with a Adaptec 2010S RAID PCI adapter
Date: Tue, 15 Jun 2004 13:13:32 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189FD23E52@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
content-class: urn:content-classes:message
To: Andre Correa <andre.correa@pobox.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The 2010 Adapter is a Zero Channel RAID card that does *not* purely
follow the I2O standard. It separates out the message unit from the
message pool, each having its own Base Address register (BAR) rather
than a single unifying BAR.

There were recent patches to the I2O layer to support this adapter
posted to the linux-scsi list. Pick them up and check them out. I
believe that there are still problems with that code.

The dpt_i2o driver, which supports 64 bit operation, continues to
properly support this adapter in the 2.6 tree, and updates to this
driver were also posted to the linux-scsi list w/o feedback (so in, not
in, don't know).

Sincerely -- Mark Salyzyn

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Andre Correa
Sent: Tuesday, June 15, 2004 1:01 PM
To: linux-raid@vger.kernel.org
Subject: Trouble with a Adaptec 2010S RAID PCI adapter


Hi list, I'm in trouble trying to use a Adaptec 2010S RAID PCI adapter
in a i386 linux box running kernel 2.6.6. I've enabled I2O in the kernel

and support for my SCSI adapter, that in fact works fine.

CONFIG_I2O=y
CONFIG_I2O_CONFIG=y
CONFIG_I2O_BLOCK=y
CONFIG_I2O_SCSI=y
CONFIG_I2O_PROC=y

My dmesg shows something like this:

...<snip>...
scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.36
         <Adaptec 2940 Ultra2 SCSI adapter>
         aic7890/91: Ultra2 Wide Channel A, SCSI Id=7, 32/253 SCBs
...<snip>...
Red Hat/Adaptec aacraid driver (1.1.2-lk1 Jun  4 2004)
...<snip>...
I2O Core - (C) Copyright 1999 Red Hat Software
I2O: Event thread created as pid 20
i2o: Checking for PCI I2O controllers...
i2o: I2O controller on bus 4 at 16.
i2o: PCI I2O controller at FEBFC000 size=16384
i2o/iop0: Installed at IRQ0
i2o: 1 I2O controller found and installed.
Activating I2O controllers...
This may take a few minutes if there are many devices
Unable to obtain status of i2o/iop0, attempting a reset.
I2O configuration manager v 0.04.
   (C) Copyright 1999 Red Hat Software
I2O Block Storage OSM v0.9
    (c) Copyright 1999-2001 Red Hat Software.
i2o_block: Checking for Boot device...
i2o_block: Checking for I2O Block devices...
i2o_scsi.c: Version 0.1.2
   chain_pool: 0 bytes @ f7d11f9c
   (512 byte buffers X 4 can_queue X 0 i2o controllers)


It seens that the kernel has found the controoler. Then I headed to
http://i2o.shadowconnect.com/  - I2O on Linux Home and got their
raidutil package. But here starts the problem, even simple commands like

raidutil -L controller

gives me the error:

Engine connect failed: COMPATIBILITY number
osdIOrequest : File /dev/dpti17 Could Not Be Opened


Following the site info I have applied the following patchs to my
kernel:

i2o-64-bit-fix.patch
i2o-adaptec-zerochannel-support.patch
i2o-config-clean.patch
i2o-makefile-cleanup.patch
i2o-pae-support.patch
i2o-passthru.patch
i2o_block-cleanup.patch
i2o_cmd_passthru-reorder.patch
i2o_config-checking-bugfix.patch
i2o_proc-full-seq_file.patch
i2o_proc-lct-access-bugfix.patch

with no luck. I've tried Adaptec's asmbe_linux_v1.23.006.tgz tools, but
aaccli cannot find the controller as well.

Does anybody experienced a problem like this before? I've found some
messages on mailling lists with the same error message, but no
solutions. I'm new to I2O. Am I missing something?

tks in advance for any help.

Andre



-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Mark Smith <ietf@2c9d1f3141b658e37c53395b25a04078.nosense.org>
Subject: 2.6.0: Should I worry about "hdc12 has different UUID to hdc13" ?
Date: Wed, 24 Dec 2003 19:28:10 +1030
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20031224192810.1e79f5a3.ietf@2c9d1f3141b658e37c53395b25a04078.nosense.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I recently upgraded to 2.6.0 from 2.4.22. My MD RAID1 arrays seems to be working fine since the upgrade.

However, during boot, for each of my MD devices (I have 13 of them), I get a number of "hdcN has different UUID to hdcN" status or error messages. For example 

--
md:  adding hdc12 ...
md: hdc11 has different UUID to hdc12
md: hdc10 has different UUID to hdc12
md: hdc9 has different UUID to hdc12
md: hdc8 has different UUID to hdc12
md: hdc7 has different UUID to hdc12
md: hdc6 has different UUID to hdc12
md: hdc5 has different UUID to hdc12
md: hdc3 has different UUID to hdc12
md: hdc2 has different UUID to hdc12
md:  adding hda12 ...
md: hda11 has different UUID to hdc12
md: hda10 has different UUID to hdc12
md: hda9 has different UUID to hdc12
md: hda8 has different UUID to hdc12
md: hda7 has different UUID to hdc12
md: hda6 has different UUID to hdc12
md: hda5 has different UUID to hdc12
md: hda3 has different UUID to hdc12
md: hda2 has different UUID to hdc12
md: created md12
md: bind<hda12>
md: bind<hdc12>
md: running: <hdc12><hda12>
raid1: raid set md12 active with 2 out of 2 mirrors
--

I get thirteen sets of these.

Is there a problem with my RAID1 arrays or is there something I can do to get rid of them ? At least to me, they don't seem to mean much (I'm guessing that UUID is some sort of unique identifier, identifying the component devices of the MD devices, and this message indicates that the RAID subsystem is looking for RAID1 component device pairs), and all they end up doing is filling up my kernel buffer before syslogd/klogd starts, which means I loose some of my other boot status messages, which I think I would find more useful eg. early PCI setup / ACPI etc.

Does anybody have any suggestions ?

Thanks,
Mark.

From: David Greaves <david@dgreaves.com>
Subject: Thanks :)
Date: Fri, 22 Oct 2004 19:06:21 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <41794C1D.4080004@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I got this yesterday

#################
This is an automatically generated mail message from mdadm
running on cu.dgreaves.com

A Fail event had been detected on md device /dev/md0.
#################

Looking at it tonight:
Oct 22 18:09:44 cu kernel: Current sdd: sense key Medium Error
Oct 22 18:09:44 cu kernel: Additional sense: Unrecovered read error - auto realloca
te failed
Oct 22 18:09:44 cu kernel: end_request: I/O error, dev sdd, sector 196988598
Oct 22 18:09:45 cu kernel: scsi3: ERROR on channel 0, id 0, lun 0, CDB: Read (10) 0
0 0b bd ce b7 00 00 01 00
Oct 22 18:09:45 cu kernel: Current sdd: sense key Medium Error
Oct 22 18:09:45 cu kernel: Additional sense: Unrecovered read error - auto realloca
te failed
Oct 22 18:09:45 cu kernel: end_request: I/O error, dev sdd, sector 196988599


The Maxtor Maxline+II 250Gb SATA drive (mfg date: feb 2004) is now out and I'm starting the RMA procedure.

No data lost (yet) so we can still watch TV - thanks everyone (especially Neil)

David


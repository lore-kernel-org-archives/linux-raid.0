From: Stefan *St0fF* Huebner <st0ff@gmx.net>
Subject: Feature Request
Date: Tue, 09 Feb 2010 09:43:32 +0100
Message-ID: <4B712034.1000600@gmx.net>
Reply-To: st0ff@npl.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Everybody,

I would like to propose a few probably hard-to-implement features to md=
raid.

Background:
Nowadays harddisk drives, I only talk about ATA/SATA drives (SCSI
devices are too expensive for me), do their own error correction.  Most
of them also have a feature called ERC (Error Recovery Control), where
you can set timeouts for read/write error correction.  Desktop drives
are preset to run their error recovery to its fullest extend, not
reacting while this procedure is active.  RAID-edition/enterprise disks
are normally set to start error recovery, but report back a media error
after 7 seconds of unsuccessful error recovery - here this timeout
"happens".

Now imagine any RAID with some kind of redundancy, reading/writing
data.  One of the disks finds out "I cannot correctly read/write the
requested sector", starts its error correction, hits the respective
ERC-timeout and reports back a media error or unrecoverable error.  Now
mdraid would drop the disk.

But actually the data of the sector can be recreated through the
existing redundancy.  Wouldn't it be a smart thing if the mdraid
recreates the sector and just tried to write it again?  And after a goo=
d
amount of failed retries it may well drop the disk.

Prerequisites:
- upon assembling/creating of the array:
  - mdraid needs to find out if the used devices rely on (s)ata block
devices
  - if it does, the ERC-timeouts for reading/writing operations on each
device need to be set, as this feature is volatile (gets reset to
factory defaults upon power-on-reset).
  - if successful, some flag indicating the enabled feature shall be se=
t
- error handling needs to be updated with above described "intelligence=
"
for devices, that have the ERC-feature set

This is a request for comments (and of course this feature).

All the best,
Stefan H=FCbner
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

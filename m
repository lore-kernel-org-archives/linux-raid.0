From: "Cress, Andrew R" <andrew.r.cress@intel.com>
Subject: RE: SAF-TE - status lights ctrl tool?
Date: Tue, 25 May 2004 09:57:26 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <D9C3AB0C3EE2254099B606A10047B5F60C316D@hdsmsx403.hd.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
content-class: urn:content-classes:message
To: danci@agenda.si, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Sure, the SAF-TE spec covers how to do this under SCSI.
I have some code that does this that you can use, see sgraidmon.c at:
 
http://cvs.sourceforge.net/viewcvs.py/*checkout*/scsirastools/scsirastoo
ls/src/sgraidmon.c?rev=1.9

See the read_safte() and write_safte() routines.

Andy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of danci@agenda.si
Sent: Tuesday, May 25, 2004 9:03 AM
To: linux-raid@vger.kernel.org
Subject: SAF-TE - status lights ctrl tool?


The thing is I have a remote server with HotSwap SAF-TE enclosure and 
Linux SW RAID-1 (2.2 kernel).

One of the disks has gone bad and it needs to be replaced. I can get
somebody local to do that but I need to make it very clear to them which
of the disks is bad and may be pulled out.

SAF-TE enclosure has status LEDs for such purpose and HW RAID
controllers
use them to mark failed drives...

Does anyone know if it is possible to activate/deactive this LEDs from 
within Linux and how?

 Thanks, D.
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

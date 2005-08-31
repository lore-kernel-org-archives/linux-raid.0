From: "David M. Strang" <dstrang@shellpower.net>
Subject: Re: raid5: Disk failure on sdm, disabling device
Date: Wed, 31 Aug 2005 16:28:06 -0400
Message-ID: <007401c5ae6a$7e9cd160$c100a8c0@NCNF5131FTH>
References: <003401c5ae61$d982b5d0$c100a8c0@NCNF5131FTH> <4316050B.1060805@tls.msk.ru> <005201c5ae63$ef23e6f0$c100a8c0@NCNF5131FTH> <43160DF2.6000504@tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=response
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael Tokarev  wrote:
> Please don't top-post.

My apologies; Outlook Express (/gasp) isn't the most condusive to mailing 
list replies.

> Well, you didn't mention that it's disappeared from the system
> (as opposed to the raid array only).  And no, I for one don't
> know how to re-add it - there are numerous reasons why it may
> had disappeared, and it may be of different kinds of drive too
> (like, SCSI or SATA).  Some cases can be handled (like, sending
> "bus reset" and "start unit" commands followed by bus rescan
> sometimes helps).  But it's safer to just reboot anyway (cold
> reboot, with power off).

It's a SCSI drive; in's a Dell 220F enclosure connected via a QLA2200 
adapter. I've pulled the bad disk (tho not 'yellow' at the hardware level; 
and re-inserted it -- but to no avail. It did cause a reset; but the device 
remains 'disabled'.

Aug 31 11:48:05 abyss kernel: qla2200 0000:00:09.0: LIP reset occured 
(f701).
Aug 31 11:48:07 abyss kernel: qla2200 0000:00:09.0: LOOP DOWN detected.
Aug 31 11:48:07 abyss kernel: qla2200 0000:00:09.0: LIP occured (f7f7).
Aug 31 11:48:07 abyss kernel: qla2200 0000:00:09.0: LOOP UP detected (1 
Gbps).
Aug 31 11:48:11 abyss kernel: qla2200 0000:00:09.0: qla2xxx_eh_abort 
scsi(2:0:6:0): cmd_timeout_in_sec=0x1e.
Aug 31 11:48:22 abyss kernel: qla2200 0000:00:09.0: qla2xxx_eh_abort 
Exiting: status=Failed
Aug 31 11:48:22 abyss kernel: qla2200 0000:00:09.0: scsi(2:0:6:0): DEVICE 
RESET ISSUED.
Aug 31 11:48:33 abyss kernel: qla2200 0000:00:09.0: qla2xxx_eh_device_reset: 
failed while waiting for commands
Aug 31 11:48:33 abyss kernel: qla2200 0000:00:09.0: scsi(2:0:6:0): LOOP 
RESET ISSUED.
Aug 31 11:48:33 abyss kernel: qla2200 0000:00:09.0: LIP reset occured 
(f701).
Aug 31 11:48:33 abyss kernel: qla2200 0000:00:09.0: LIP occured (f7f7).
Aug 31 11:48:44 abyss kernel: qla2200 0000:00:09.0: qla2xxx_eh_bus_reset: 
reset failed
Aug 31 11:48:44 abyss kernel: qla2200 0000:00:09.0: scsi(2:0:6:0): ADAPTER 
RESET issued.
Aug 31 11:48:44 abyss kernel: qla2200 0000:00:09.0: Performing ISP error 
recovery - ha= c21881cc.
Aug 31 11:48:44 abyss kernel: qla2200 0000:00:09.0: LIP reset occured 
(f8f7).
Aug 31 11:48:45 abyss kernel: qla2200 0000:00:09.0: LIP occured (f8f7).
Aug 31 11:48:45 abyss kernel: qla2200 0000:00:09.0: LOOP UP detected (1 
Gbps).
Aug 31 11:48:45 abyss kernel: qla2200 0000:00:09.0: qla2xxx_eh_host_reset: 
reset succeded

-- David M. Strang 


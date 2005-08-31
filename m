From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: raid5: Disk failure on sdm, disabling device
Date: Thu, 01 Sep 2005 00:35:47 +0400
Message-ID: <431614A3.8010406@tls.msk.ru>
References: <003401c5ae61$d982b5d0$c100a8c0@NCNF5131FTH> <4316050B.1060805@tls.msk.ru> <005201c5ae63$ef23e6f0$c100a8c0@NCNF5131FTH> <43160DF2.6000504@tls.msk.ru> <007401c5ae6a$7e9cd160$c100a8c0@NCNF5131FTH>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <007401c5ae6a$7e9cd160$c100a8c0@NCNF5131FTH>
Sender: linux-raid-owner@vger.kernel.org
To: "David M. Strang" <dstrang@shellpower.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

David M. Strang wrote:
[]
> It's a SCSI drive; in's a Dell 220F enclosure connected via a QLA2200 
> adapter. I've pulled the bad disk (tho not 'yellow' at the hardware 
> level; and re-inserted it -- but to no avail. It did cause a reset; but 
> the device remains 'disabled'.
> 
> Aug 31 11:48:05 abyss kernel: qla2200 0000:00:09.0: LIP reset occured (f701).
> Aug 31 11:48:07 abyss kernel: qla2200 0000:00:09.0: LOOP DOWN detected.
> Aug 31 11:48:07 abyss kernel: qla2200 0000:00:09.0: LIP occured (f7f7).
> Aug 31 11:48:07 abyss kernel: qla2200 0000:00:09.0: LOOP UP detected (1 Gbps).
> Aug 31 11:48:11 abyss kernel: qla2200 0000:00:09.0: qla2xxx_eh_abort scsi(2:0:6:0): cmd_timeout_in_sec=0x1e.
> Aug 31 11:48:22 abyss kernel: qla2200 0000:00:09.0: qla2xxx_eh_abort Exiting: status=Failed
> Aug 31 11:48:22 abyss kernel: qla2200 0000:00:09.0: scsi(2:0:6:0): DEVICE RESET ISSUED.
> Aug 31 11:48:33 abyss kernel: qla2200 0000:00:09.0: qla2xxx_eh_device_reset: failed while waiting for commands
> Aug 31 11:48:33 abyss kernel: qla2200 0000:00:09.0: scsi(2:0:6:0): LOOP RESET ISSUED.
> Aug 31 11:48:33 abyss kernel: qla2200 0000:00:09.0: LIP reset occured (f701).
> Aug 31 11:48:33 abyss kernel: qla2200 0000:00:09.0: LIP occured (f7f7).
> Aug 31 11:48:44 abyss kernel: qla2200 0000:00:09.0: qla2xxx_eh_bus_reset: reset failed
> Aug 31 11:48:44 abyss kernel: qla2200 0000:00:09.0: scsi(2:0:6:0): ADAPTER RESET issued.
> Aug 31 11:48:44 abyss kernel: qla2200 0000:00:09.0: Performing ISP error recovery - ha= c21881cc.
> Aug 31 11:48:44 abyss kernel: qla2200 0000:00:09.0: LIP reset occured (f8f7).
> Aug 31 11:48:45 abyss kernel: qla2200 0000:00:09.0: LIP occured (f8f7).
> Aug 31 11:48:45 abyss kernel: qla2200 0000:00:09.0: LOOP UP detected (1 Gbps).
> Aug 31 11:48:45 abyss kernel: qla2200 0000:00:09.0: qla2xxx_eh_host_reset: reset succeded

Ugh.
You'd better ask linux-scsi list about what does it mean.
Note linux does not really support scsi hotplug, at least not automatically.

Well, you can try to do
  echo -n 1 > /sys/block/sdm/device/delete
(or was it 'echo -n y' ?)
and either
   echo -n scsi add-single-device c h t l > /proc/scsi/scsi
(replacing c h t l with proper numbers), or
   echo y > /sys/bus/scsi_host/hostN/rescan

But I'm really not sure if it'll help - sometimes (with some driver combinations)
it helps, and sometimes does not.  I haven't used qla* at all.

/mjt

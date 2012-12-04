From: EJ Vincent <ej@ejane.org>
Subject: Manually failing a disk during a md raid6 reshape
Date: Tue, 04 Dec 2012 13:44:56 -0500
Message-ID: <50BE44A8.1040502@ejane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Greetings,

I currently have a md raid6 reshape (growth, adding a disk) under-way.  
Dmesg is beginning to fill up with:

[23661.913556] ata15.00: status: { DRDY }
[23661.914443] ata15.00: failed command: WRITE FPDMA QUEUED
[23661.915326] ata15.00: cmd 61/80:f0:00:34:e9/00:00:45:00:00/40 tag 30 
ncq 65536 out
[23661.915329]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 
0x4 (timeout)
[23661.917110] ata15.00: status: { DRDY }
[23661.917977] ata15: hard resetting link
[23664.116087] ata15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
[23664.118667] ata15.00: configured for UDMA/100
[23664.118685] ata15.00: device reported invalid CHS sector 0

What's the best way to identify ata15.00 and is it permissible to 
manually fail this device, without damaging and/or interrupting the 
reshape?

I'm also perfectly OK with waiting for it to complete on it's own, 
although the speed of the reshape operation has diminished, by my 
estimate, about 25% since beginning.

Also, any conjecture on what might lead to the above error(s)?

Thank you very much.

Best,
-EJ

From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Subject: what does this mean: ioctl lock interrupted
Date: Sat, 03 Dec 2005 19:55:17 +1100
Message-ID: <43915D75.5040601@eyal.emu.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I am testing my Promise SATA-II-150-TX4.

I ran 'e2fsck -f' for a few hours and all is well.
I then wanted some writing to so I changed to 'e2fsck -cc'.

I am seeing the following messages. Is this a problem?
It seems to continue unharmed though.

Dec  3 18:24:09 eyal kernel: [4322441.538000] md: ioctl lock interrupted, reason -4, cmd 4705
Dec  3 18:35:23 eyal kernel: [4323115.688000] md: ioctl lock interrupted, reason -4, cmd 4705
Dec  3 18:36:42 eyal kernel: [4323194.933000] md: ioctl lock interrupted, reason -4, cmd 4705
Dec  3 18:36:54 eyal kernel: [4323207.259000] md: ioctl lock interrupted, reason -4, cmd 4705
Dec  3 18:37:59 eyal kernel: [4323271.650000] md: ioctl lock interrupted, reason -4, cmd 4705
Dec  3 18:38:21 eyal kernel: [4323293.902000] md: ioctl lock interrupted, reason -4, cmd 4705
Dec  3 19:04:03 eyal kernel: [4324835.969000] md: ioctl lock interrupted, reason -4, cmd 4705


$ uname -a
Linux e7 2.6.15-rc4 #2 PREEMPT Fri Dec 2 08:09:23 EST 2005 i686 GNU/Linux

-- 
Eyal Lebedinsky (eyal@eyal.emu.id.au) <http://samba.org/eyal/>
	attach .zip as .dat

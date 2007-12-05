From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Kernel 2.6.23.9 / P35 Chipset + WD 750GB Drives (reset port)
Date: Tue, 04 Dec 2007 19:26:41 -0600
Message-ID: <4755FE51.5090603@shaw.ca>
References: <fa.hhS4g1h0uppt8Xx/ZZfNNQfAv1Q@ifi.uio.no>
 <fa.YIWyRfjQw18aIH2fKaze37Gwuzo@ifi.uio.no>
 <fa.ib4H8TQ3raADIWdsEBy+eSL/1RU@ifi.uio.no>
 <fa.S4u1AwoYnqrSuegcUaP78D3SFXQ@ifi.uio.no>
 <fa.H1nTe/xQV/oyEMTHAkOjqgqu7jY@ifi.uio.no>
 <fa.YpQ6xCPOijQOCKsLJr1SDINFURI@ifi.uio.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-reply-to: <fa.YpQ6xCPOijQOCKsLJr1SDINFURI@ifi.uio.no>
Sender: linux-ide-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org, apiszcz@solarrain.com
List-Id: linux-raid.ids

Justin Piszcz wrote:
> The badblocks did not do anything; however, when I built a software raid 
> 5 and the performed a dd:
> 
> /usr/bin/time dd if=/dev/zero of=fill_disk bs=1M
> 
> I saw this somewhere along the way:
> 
> [30189.967531] RAID5 conf printout:
> [30189.967576]  --- rd:3 wd:3
> [30189.967617]  disk 0, o:1, dev:sdc1
> [30189.967660]  disk 1, o:1, dev:sdd1
> [30189.967716]  disk 2, o:1, dev:sde1
> [42332.936615] ata5.00: exception Emask 0x2 SAct 0x7000 SErr 0x0 action 
> 0x2 frozen
> [42332.936706] ata5.00: spurious completions during NCQ issue=0x0 
> SAct=0x7000 FIS=004040a1:00000800
> [42332.936804] ata5.00: cmd 61/08:60:6f:4d:2a/00:00:27:00:00/40 tag 12 
> cdb 0x0 data 4096 out
> [42332.936805]          res 40/00:74:0f:49:2a/00:00:27:00:00/40 Emask 
> 0x2 (HSM violation)
> [42332.936977] ata5.00: cmd 61/08:68:77:4d:2a/00:00:27:00:00/40 tag 13 
> cdb 0x0 data 4096 out
> [42332.936981]          res 40/00:74:0f:49:2a/00:00:27:00:00/40 Emask 
> 0x2 (HSM violation)
> [42332.937162] ata5.00: cmd 61/00:70:0f:49:2a/04:00:27:00:00/40 tag 14 
> cdb 0x0 data 524288 out
> [42332.937163]          res 40/00:74:0f:49:2a/00:00:27:00:00/40 Emask 
> 0x2 (HSM violation)
> [42333.240054] ata5: soft resetting port
> [42333.494462] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [42333.506592] ata5.00: configured for UDMA/133
> [42333.506652] ata5: EH complete
> [42333.506741] sd 4:0:0:0: [sde] 1465149168 512-byte hardware sectors 
> (750156 MB)
> [42333.506834] sd 4:0:0:0: [sde] Write Protect is off
> [42333.506887] sd 4:0:0:0: [sde] Mode Sense: 00 3a 00 00
> [42333.506905] sd 4:0:0:0: [sde] Write cache: enabled, read cache: 
> enabled, doesn't support DPO or FUA
> 
> Next test, I will turn off NCQ and try to make the problem re-occur.
> If anyone else has any thoughts here..?
> I ran long smart tests on all 3 disks, they all ran successfully.
> 
> Perhaps these drives need to be NCQ BLACKLISTED with the P35 chipset?

The problem won't recur with NCQ off, because spurious completions are 
impossible in that case.

It was originally thought that these AHCI spurious NCQ completions were 
busted NCQ implementations on the drives, but I think there theory is 
that it's some other timing problem or some such, given the number of 
drives across all makers which are reported to do this. I believe Tejun 
is investigating?

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/


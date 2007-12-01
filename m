From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Kernel 2.6.23.9 / P35 Chipset + WD 750GB Drives (reset port)
Date: Sat, 01 Dec 2007 14:08:38 -0600
Message-ID: <4751BF46.8040904@shaw.ca>
References: <fa.hhS4g1h0uppt8Xx/ZZfNNQfAv1Q@ifi.uio.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <fa.hhS4g1h0uppt8Xx/ZZfNNQfAv1Q@ifi.uio.no>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org, apiszcz@solarrain.com
List-Id: linux-raid.ids

Justin Piszcz wrote:
> I am putting a new machine together and I have dual raptor raid 1 for 
> the root, which works just fine under all stress tests.
> 
> Then I have the WD 750 GiB drive (not RE2, desktop ones for ~150-160 on 
> sale now adays):
> 
> I ran the following:
> 
> dd if=/dev/zero of=/dev/sdc
> dd if=/dev/zero of=/dev/sdd
> dd if=/dev/zero of=/dev/sde
> 
> (as it is always a very good idea to do this with any new disk)
> 
> And sometime along the way(?) (i had gone to sleep and let it run), this 
> occurred:
> 
> [42880.680144] ata3.00: exception Emask 0x10 SAct 0x0 SErr 0x4010000 
> action 0x2 frozen
> [42880.680231] ata3.00: irq_stat 0x00400040, connection status changed
> [42880.680290] ata3.00: cmd ec/00:00:00:00:00/00:00:00:00:00/00 tag 0 
> cdb 0x0 data 512 in
> [42880.680292]          res 40/00:ac:d8:64:54/00:00:57:00:00/40 Emask 
> 0x10 (ATA bus error)
> [42881.841899] ata3: soft resetting port
> [42885.966320] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [42915.919042] ata3.00: qc timeout (cmd 0xec)
> [42915.919094] ata3.00: failed to IDENTIFY (I/O error, err_mask=0x5)
> [42915.919149] ata3.00: revalidation failed (errno=-5)
> [42915.919206] ata3: failed to recover some devices, retrying in 5 secs
> [42920.912458] ata3: hard resetting port
> [42926.411363] ata3: port is slow to respond, please be patient (Status 
> 0x80)
> [42930.943080] ata3: COMRESET failed (errno=-16)
> [42930.943130] ata3: hard resetting port
> [42931.399628] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [42931.413523] ata3.00: configured for UDMA/133
> [42931.413586] ata3: EH pending after completion, repeating EH (cnt=4)
> [42931.413655] ata3: EH complete
> [42931.413719] sd 2:0:0:0: [sdc] 1465149168 512-byte hardware sectors 
> (750156 MB)
> [42931.413809] sd 2:0:0:0: [sdc] Write Protect is off
> [42931.413856] sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
> [42931.413867] sd 2:0:0:0: [sdc] Write cache: enabled, read cache: 
> enabled, doesn't support DPO or FUA
> 
> Usually when I see this sort of thing with another box I have full of 
> raptors, it was due to a bad raptor and I never saw it again after I 
> replaced the disk that it happened on, but that was using the Intel P965 
> chipset.
> 
> For this board, it is a Gigabyte GSP-P35-DS4 (Rev 2.0) and I have all of 
> the drives (2 raptors, 3 750s connected to the Intel ICH9 Southbridge).
> 
> I am going to do some further testing but does this indicate a bad 
> drive? Bad cable?  Bad connector?

Could be any of the above.

> 
> As you can see above, /dev/sdc stopped responding for a little bit and 
> then the kernel reset the port.

It looks like the first thing that happened is that the controller 
reported it lost the SATA link, and then the drive didn't respond until 
it was bashed with a few hard resets..

> 
> Why is this though?  What is the likely root cause?  Should I replace 
> the drive?  Obviously this is not normal and cannot be good at all, the 
> idea is to put these drives in a RAID5 and if one is going to timeout 
> that is going to cause the array to go degraded and thus be worthless in 
> a raid5 configuration.
> 
> Can anyone offer any insight here?
> 
> Thank you,
> 
> Justin.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/


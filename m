From: Ray Morris <support@bettercgi.com>
Subject: Re: Raid failure - drives or controller?
Date: Wed, 7 Mar 2012 13:33:49 -0600
Message-ID: <20120307133349.1a1fb307@bettercgi.com>
References: <4F57A05E.6000204@agenda.si>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F57A05E.6000204@agenda.si>
Sender: linux-raid-owner@vger.kernel.org
To: Danilo Godec <danilo.godec@agenda.si>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> drives or controller?

Don't forget cables and loose connections. 
We've had more cable problems than anything else.
-- 
Ray Morris
support@bettercgi.com

Strongbox - The next generation in site security:
http://www.bettercgi.com/strongbox/

Throttlebox - Intelligent Bandwidth Control
http://www.bettercgi.com/throttlebox/

Strongbox / Throttlebox affiliate program:
http://www.bettercgi.com/affiliates/user/register.php




On Wed, 07 Mar 2012 18:52:30 +0100
Danilo Godec <danilo.godec@agenda.si> wrote:

> Hi,
> 
> I had two drive failure on a RAID5 in short time (unfortunately to
> short to rebuild on a spare disk). However - drives seem to work on a
> test machine and didn't report any errors. I also stuck them back
> into the orig. server (after rebooting) and they work now.
> 
> The first drive's errors were:
> 
> > Mar  6 05:15:19 san1 kernel: [10681162.473960] sd 4:0:3:0: [sde] 
> > Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> > Mar  6 05:15:19 san1 kernel: [10681162.473965] sd 4:0:3:0: [sde]
> > Sense Key : Aborted Command [current]
> > Mar  6 05:15:19 san1 kernel: [10681162.473969] sd 4:0:3:0: [sde]
> > Add. Sense: No additional sense information
> > Mar  6 05:15:19 san1 kernel: [10681162.473973] sd 4:0:3:0: [sde]
> > CDB: Read(10): 28 00 07 af 38 3f 00 00 08 00
> > Mar  6 05:15:19 san1 kernel: [10681162.473980] end_request: I/O
> > error, dev sde, sector 128923711
> > Mar  6 05:17:53 san1 kernel: [10681316.885221] sd 4:0:3:0: [sde] 
> > Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> > Mar  6 05:17:53 san1 kernel: [10681316.885225] sd 4:0:3:0: [sde]
> > Sense Key : Illegal Request [current]
> > Mar  6 05:17:53 san1 kernel: [10681316.885229] sd 4:0:3:0: [sde]
> > Add. Sense: Logical block address out of range
> > Mar  6 05:17:53 san1 kernel: [10681316.885234] sd 4:0:3:0: [sde]
> > CDB: Write(10): 2a 08 74 70 58 c7 00 00 08 00
> > Mar  6 05:17:53 san1 kernel: [10681316.885242] end_request: I/O
> > error, dev sde, sector 1953519815
> > Mar  6 05:17:53 san1 kernel: [10681316.885246] end_request: I/O
> > error, dev sde, sector 1953519815
> > Mar  6 05:17:53 san1 kernel: [10681316.885252] raid5: Disk failure
> > on sde1, disabling device.
> > Mar  6 05:20:27 san1 kernel: [10681470.600610] sd 4:0:3:0: [sde] 
> > Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> > Mar  6 05:20:27 san1 kernel: [10681470.600615] sd 4:0:3:0: [sde]
> > Sense Key : Illegal Request [current]
> > Mar  6 05:20:27 san1 kernel: [10681470.600619] sd 4:0:3:0: [sde]
> > Add. Sense: Logical block address out of range
> > Mar  6 05:20:27 san1 kernel: [10681470.600624] sd 4:0:3:0: [sde]
> > CDB: Write(10): 2a 08 74 70 59 27 00 00 08 00
> > Mar  6 05:20:27 san1 kernel: [10681470.600631] end_request: I/O
> > error, dev sde, sector 1953519911
> > Mar  6 05:20:27 san1 kernel: [10681470.600636] end_request: I/O
> > error, dev sde, sector 1953519911
> > Mar  6 05:20:28 san1 kernel: [10681471.664682]  disk 3, o:0,
> > dev:sde1 Mar  6 05:21:47 san1 kernel: [10681549.746852] sd 4:0:3:0:
> > [sde] Synchronizing SCSI cache
> > Mar  6 05:21:47 san1 kernel: [10681549.746905] sd 4:0:3:0: [sde] 
> > Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
> 
> The second drive did this:
> 
> > Mar  7 02:31:37 san1 kernel: [10757598.197391] sd 4:0:5:0: [sdg] 
> > Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> > Mar  7 02:31:37 san1 kernel: [10757598.197396] sd 4:0:5:0: [sdg]
> > Sense Key : Aborted Command [current]
> > Mar  7 02:31:37 san1 kernel: [10757598.197400] sd 4:0:5:0: [sdg]
> > Add. Sense: No additional sense information
> > Mar  7 02:31:37 san1 kernel: [10757598.197404] sd 4:0:5:0: [sdg]
> > CDB: Read(10): 28 00 07 12 05 9f 00 00 10 00
> > Mar  7 02:31:37 san1 kernel: [10757598.197411] end_request: I/O
> > error, dev sdg, sector 118621599
> > Mar  7 02:31:37 san1 kernel: [10757598.583990] raid5: Disk failure
> > on sdg1, disabling device.
> > Mar  7 02:31:37 san1 kernel: [10757598.616232]  disk 5, o:0,
> > dev:sdg1
> 
> Can anyone make some actual sense out of these sense messages?
> 
> Are these drives really / likely bad or is it more likely it was a 
> controller failure?
> 
> 
>     D.
> 
> 


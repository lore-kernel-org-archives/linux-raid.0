From: Tim Moore <linux-raid@nsr500.net>
Subject: Re: [PATCH md 2 of 4] Fix raid6 problem
Date: Sat, 05 Feb 2005 19:38:31 -0800
Message-ID: <42059137.4040109@nsr500.net>
References: <200502031743.j13Hha910546@www.watkins-home.com> <42026860.1000409@zytor.com> <Pine.LNX.4.56.0502031822160.9028@lion.drogon.net> <200502040904.38264.andrew@walrond.org> <Pine.LNX.4.56.0502041031470.29133@lion.drogon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <Pine.LNX.4.56.0502041031470.29133@lion.drogon.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Gordon Henderson <gordon@drogon.net>
List-Id: linux-raid.ids


Gordon Henderson wrote:
 > ...
> It seemed more stable with just one PCI card in, so I have a 4-port card
> on order as a last ditch attempt to make it work - I did try re-flashing
> the BIOS on one board, (I have 2) as it seemed to be about a year old and
> there are several updates on the Tyan web-site, however that resulted in
> wiping out the BIOS - it seemed to be going just fine, then it went beep
> and was silent forever more )-: Anyone in the SW have a flash
> programmer/copier handy???

I had this happen when flashing 2.02b.  Reboot was an endless cycle of 15 
short beeps.  Turns out the 2.02 memory configuration is so different than 
the 1.?? it couldn't boot.  Swapped the 1GB PC2700 (ATP) memory with 512MB 
modules, cleared CMOS, rebooted, reconfigured the BIOS, shut down, replaced 
the 1GB production modules, rebooted.  Perfect ever since.

The sil 3114 onboard w software RAID5 has been flawless (RH 7.3 base, 
2.4.29 kernel, SCSI/sil driver).  The only other problem was that two of 
the 4 short black SATA cables that came with the board were intermittent. 
Once replaced all is well.

I'd give 2.02 beta Bios a run and make sure PCI-X slot configuration is 
matched to the controller card.  2.02 BIOS is very different than earlier 
versions.

Iwill quad opteron boards and are quite happy to never go back to intel 
ever again.

t.
-- 


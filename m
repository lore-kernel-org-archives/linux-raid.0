From: Tim Moore <tim.moore@nsr500.net>
Subject: Re: [PATCH md 2 of 4] Fix raid6 problem
Date: Sun, 13 Feb 2005 20:56:13 -0800
Message-ID: <42102F6D.7060703@nsr500.net>
References: <Pine.LNX.4.44.0502131602470.16537-100000@coffee.psychology.mcmaster.ca> <Pine.LNX.4.56.0502132113430.29594@lion.drogon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <Pine.LNX.4.56.0502132113430.29594@lion.drogon.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Gordon Henderson wrote:
> On Sun, 13 Feb 2005, Mark Hahn wrote:
> I was about to post that I've solved my problems with that Tyan dual
> opteron motherboard, but it's still crap. I upgraded the BIOS to the 2.02
> beta and it seemed to work a lot better.  Still couldn't boot off it with
> all 8 drives in, but solved that with the use of a 32MB flash IDE unit
> holding /boot... However, it dropped a drive during initial sync of the
> raid6 arrays with lots of SCSI errors, and had given lots of DMA interrupt
> missing, etc. thorugh the day when I've run soaktests on it, so I'm going

2 of the 4 SATA cables packaged with the K8W were intermittent bad 
(SCSI/DMA errors, BIOS didn't see them at boot).  New cables, no problem.

No I don't work for AMD or Tyan :)  I tried the K8W as a high throughput 
client driver platform because I couldnt take the budget hit on an Iwill 
QK8S which we use in production...they work like perfect screaming daemons.

Also considered the MSI board but no numa memory interconnect and no 64bit 
slots.

Good luck.

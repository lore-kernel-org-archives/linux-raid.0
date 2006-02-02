From: Matthias Urlichs <smurf@smurf.noris.de>
Subject: Re: RAID 16?
Date: Thu, 02 Feb 2006 21:24:30 +0100
Message-ID: <pan.2006.02.02.20.24.27.869975@smurf.noris.de>
References: <43E19FAB.4000603@cogweb.net> <pan.2006.02.02.16.17.03.859560@smurf.noris.de> <Pine.GSO.4.62.0602021726010.14030@shaka.acc.umu.se> <Pine.LNX.4.56.0602021651370.19057@lion.drogon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi, Gordon Henderson wrote:

> I've actually had very good results hot swapping  SCSI drives on a live
> linux system though. I guess you do run the risk of something crowbarring
> the SCSI bus for a few cycles when the drive is unplugged or plugged in,
> but it's all parity/checksummed, isn't it?

You run the very real risks of unbalancing the bus when you plug/unplug,
thereby creating power spikes which may or may not destry your hardware.

I did what you do for years. Always when the bus was idle, and with
antistatic precautions. One day, all SCSI driver chips on the bus were
shot afterwards. That was the last time I *ever* touched a powered SCSI
bus.

(I had to replace the SCSI interface chip in my tape drive (fiddly work
 with the soldering iron); luckily it used a standard one that was
 available.)

-- 
Matthias Urlichs   |   {M:U} IT Design @ m-u-it.de   |  smurf@smurf.noris.de
Disclaimer: The quote was selected randomly. Really. | http://smurf.noris.de
 - -
Reality continues to ruin my life.
		-- Calvin



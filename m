From: Tejun Heo <htejun@gmail.com>
Subject: Re: Machine hanging on synchronize cache on shutdown 2.6.22-rc4-git[45678]
Date: Mon, 18 Jun 2007 20:33:37 +0900
Message-ID: <46766D91.90303@gmail.com>
References: <200706181129.l5IBT0Sa002063@harpo.it.uu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <200706181129.l5IBT0Sa002063@harpo.it.uu.se>
Sender: linux-ide-owner@vger.kernel.org
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: brad@wasp.net.au, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mikael Pettersson wrote:
> FWIW, I'm seeing scsi layer accesses (cache flushes) after things
> like rmmod sata_promise. They error out and don't seem to cause
> any harm, but the fact that they occur at all makes me nervous.

That's okay.  On rmmod, as the low level device (ATA) goes away first
just as in hot unplug, sd gets notified *after* the device is gone but
sd still tries to clean up and issues the commands which are properly
rejected by the SCSI midlayer as the device is marked offline already,
so nothing to worry about there.

-- 
tejun

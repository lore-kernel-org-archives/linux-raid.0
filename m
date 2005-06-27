From: "Catalin(ux aka Dino) BOIE" <util@deuroconsult.ro>
Subject: Re: Adding spare to running array?
Date: Mon, 27 Jun 2005 16:28:30 +0300 (EEST)
Message-ID: <Pine.LNX.4.62.0506271627540.10339@webhosting.rdsbv.ro>
References: <200506271512.30327.infomails@tronserver.dyndns.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200506271512.30327.infomails@tronserver.dyndns.org>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Frotscher <infomails@tronserver.dyndns.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 27 Jun 2005, Michael Frotscher wrote:

> Hello,
>
> I experienced what probably many of you experienced before me: one disk in my
> RAID-1-array died, I got a new one and reconstructed the array. Everything
> went fine. However, there was warranty on the dead drive and I eventually got
> it back, now having one spare drive.
> Is there a way to integrate that drive as a hot spare so the array will not
> fall into degraded mode even if another drive fails?
>
> I mean, I could write a config-file which contains this array with a spare and
> do a "raidhotadd --configfile=", but will that work and leave my data
> untouched?

Use mdadm and you can hot add the spare.

> Sincerely,
> -- 
> Dipl.-Chem. Michael Frotscher
> Institute of Inorganic and Applied Chemistry
> University of Hamburg, Germany
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

---
Catalin(ux aka Dino) BOIE
catab at deuroconsult.ro
http://kernel.umbrella.ro/

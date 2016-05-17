From: Wolfgang Denk <wd@denx.de>
Subject: Re: MD RAID6 corrupted by Avago 9260-4i controller [SOLVED]
Date: Tue, 17 May 2016 20:42:02 +0200
Message-ID: <20160517184202.7D19C10035C@atlas.denx.de>
References: <20160515133740.85EC3100879@atlas.denx.de> <20160515153121.GA11365@EIS.leimen.priv> <20160515182524.7B12D100A8E@atlas.denx.de> <20160515183128.GA12823@EIS.leimen.priv> <20160515193516.2C457100879@atlas.denx.de> <20160515203446.GA13218@EIS.leimen.priv> <20160515231046.E3685100A8E@atlas.denx.de> <20160516083903.GA29380@EIS.leimen.priv> <20160516120600.5428910035C@atlas.denx.de> <20160516125801.20A1A100879@atlas.denx.de> <20160516131439.GA2850@metamorpher.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <20160516131439.GA2850@metamorpher.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Andreas,

In message <20160516131439.GA2850@metamorpher.de> you wrote:
> On Mon, May 16, 2016 at 02:58:01PM +0200, Wolfgang Denk wrote:
> > Seems I was lucky - already the second of the 120 possible
> > combination turned out to be working: b a c d f e
> 
> Find a large enough file (disks * chunksize) and verify it.

Running "fsck -f -n" over one of the (big, multi million files) file
systems turned out to be a quick and good enough test.

> With GPT partition table, I set PARTLABEL to mdnumber-role so that's 
> another place that has metadata in case mdadm loses its own... 
> Since GPT lives at beginning and end of the disk it should have a 
> good chance of surviving accidents, and you can address them as 
> /dev/disk/by-partlabel/mdnumber-* in the correct order...

So far I did not use any partitioning at all on such drives.  never
needed it...

> Anyway, glad you (hopefully, finally?) got your data back.

Yes, indeed, all data recovered.  And I really owe you a beer...

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
Lispers are among  the  best  grads  of  the  Sweep-It-Under-Someone-
Else's-Carpet  School of Simulated Simplicity. [Was that sufficiently
incendiary? :-)]  - Larry Wall in <1992Jan10.201804.11926@netlabs.com

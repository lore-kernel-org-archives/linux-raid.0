From: Wolfgang Denk <wd@denx.de>
Subject: Re: MD RAID6 corrupted by Avago 9260-4i controller [SOLVED]
Date: Mon, 16 May 2016 13:05:26 +0200
Message-ID: <20160516110526.5156410035C@atlas.denx.de>
References: <20160515124534.A42D0100879@atlas.denx.de> <20160515133740.85EC3100879@atlas.denx.de> <20160515153121.GA11365@EIS.leimen.priv> <20160515182524.7B12D100A8E@atlas.denx.de> <20160515183128.GA12823@EIS.leimen.priv> <20160515193516.2C457100879@atlas.denx.de> <20160515203446.GA13218@EIS.leimen.priv> <20160515231046.E3685100A8E@atlas.denx.de> <20160516083903.GA29380@EIS.leimen.priv> <20160516100642.D4B4D10035C@atlas.denx.de> <20160516102418.GA2347@metamorpher.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <20160516102418.GA2347@metamorpher.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Andreas,

In message <20160516102418.GA2347@metamorpher.de> you wrote:
> On Mon, May 16, 2016 at 12:06:42PM +0200, Wolfgang Denk wrote:
> > Hm... is --data-offset the only parameter I can play with?
> 
> There is also --layout=

The output of the initial create command was 

	mdadm: layout defaults to left-symmetric
	mdadm: size set to 976762448K
	mdadm: array /dev/md2 started.

so this should be known...

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
I think animal testing is a terrible idea; they get all  nervous  and
give the wrong answers.

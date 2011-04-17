From: "Guy Watkins" <linux-raid@watkins-home.com>
Subject: RE: Recommended pci-e 1x SATA cards.
Date: Sun, 17 Apr 2011 17:25:25 -0400
Message-ID: <51FCFA8F0AE04DB3B3B8BB89DCCB88B1@m5>
References: <4DA6CCFE.8020708@crc.id.au>	<20110414185304.5bc1cca5@natsu>
	<4DA6F3B2.8080402@crc.id.au>	<4DA7513C.5020505@hardwarefreak.com>
	<20110415105846.1c4ec630@natsu>	<4DA8B91C.8050005@hardwarefreak.com>
 <20110416111554.09066e73@natsu> <4DA959E4.2080605@fnarfbargle.com>
 <4DA9FED8.2000308@hardwarefreak.com> <4DAA7E46.6040309@fnarfbargle.com>
 <4DAB3344.2090502@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <4DAB3344.2090502@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Stan Hoeppner' <stan@hardwarefreak.com>, 'Brad Campbell' <lists2009@fnarfbargle.com>
Cc: 'Roman Mamedov' <rm@romanrm.ru>, 'Steven Haigh' <netwiz@crc.id.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

} -----Original Message-----
} From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
} owner@vger.kernel.org] On Behalf Of Stan Hoeppner
} Sent: Sunday, April 17, 2011 2:37 PM
} To: Brad Campbell
} Cc: Roman Mamedov; Steven Haigh; linux-raid@vger.kernel.org
} Subject: Re: Recommended pci-e 1x SATA cards.
} 
} Brad Campbell put forth on 4/17/2011 12:44 AM:
} 
} > Hells bells, there is even a case that Roman pointed to where the
} > precise controller you recommend as being of suitable quality
} > demonstrates the exact fault we are talking about, and you try to blame
} > the copy program or the Windows driver.
} >
} > There appears to be an insidious flaw in these chips that only manifests
} > itself under "perfect storm" conditions, but when it does it silently
} > eats your data.
} 
} I've been in the hardware game a long time, and all the evidence I'm
} seeing WRT this silent data corruption issue points simply to QC, not a
} chip design flaw.  If the problem were a chip design flaw, we'd see far
} more widespread reporting, as millions of this chip have shipped into
} the marketplace.

I disagree.  In fact, Intel recalled their new chip (sandy bridge I think)
that had a design flaw that was very unlikely to cause any problems.
However, Intel did not want the risk, so recalled them all.

} 
} The fact that the Russian with 5 cards purchased in Dubai could
} routinely demonstrate this problem with 2 of 5 identical cards, and
} never on the other 3, points directly to a board QC isue.  Again, if the
} problem were a design flaw in the IC itself, all 5 cards would have
} exhibited the problem.

I would bet the cards were based on the reference design.  Maybe the
reference design has the flaw?  Chip or board design, signal timing could be
really close to some limit, add a bit extra solder here or there and you
have a bad card.  No 2 cards are identical.  If they were identical, you
would only need to test the first card made, and know the rest are
identical, so no extra testing is needed.

Guy

} 
} --
} Stan
} --
} To unsubscribe from this list: send the line "unsubscribe linux-raid" in
} the body of a message to majordomo@vger.kernel.org
} More majordomo info at  http://vger.kernel.org/majordomo-info.html


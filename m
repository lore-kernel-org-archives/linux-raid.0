From: "Guy Watkins" <linux-raid@watkins-home.com>
Subject: RE: md software raid
Date: Tue, 27 Oct 2009 23:35:18 -0400
Message-ID: <90A9A736F2D34AA2907A05658347BEC5@m5>
References: <4D87015385157D4285D56CA6101072FF3A6675B8@exchange07.valvesoftware.com> <20091028030811708.FQZG2056@cdptpa-omta04.mail.rr.com> <4D87015385157D4285D56CA6101072FF3A6675B9@exchange07.valvesoftware.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D87015385157D4285D56CA6101072FF3A6675B9@exchange07.valvesoftware.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Chris Green' <cgreen@valvesoftware.com>, 'Leslie Rhorer' <lrhorer@satx.rr.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

If you just used the 300 dots per inch as 1 bit per dot, you could store
15120000 (300*300*8*10.5) bits per side (assuming 1/4 inch border on 8.5x11
paper 2 sided).  That is 1.8MB per page.  You would need 555556 pages.  That
would stack 463 feet high (assuming 100 pages per inch).

} -----Original Message-----
} From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
} owner@vger.kernel.org] On Behalf Of Chris Green
} Sent: Tuesday, October 27, 2009 11:12 PM
} To: 'Leslie Rhorer'; linux-raid@vger.kernel.org
} Subject: RE: md software raid
} 
} I was thinking 300dpi on letter paper gives you about 1mbyte, and you'd
} bloat it by 2x for redundancy, using both sides of the paper.
} But I guess 300 dpi is actually 300 dots per square inch, not 300 per
} linear inch, which means its only 10s of k per page.
} 
} 
} -----Original Message-----
} From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
} owner@vger.kernel.org] On Behalf Of Leslie Rhorer
} Sent: Tuesday, October 27, 2009 8:08 PM
} To: linux-raid@vger.kernel.org
} Subject: RE: md software raid
} 
} > I'm guessing you could get about a megabyte per sheet of paper this way.
} 
} 	You've got to be kidding!  At 72 points/in, a font size of 8 allows
} for one byte and one space per inch, or about 10 bytes per line.  One can
} fairly easily display 1KB per page, but nowhere near 1MB.
} 
} > So a 1TB drive would take up 1000000 sheets of paper. Looking at
} > staples.com,
} 
} 	Make that more like a billion pages.  Remember, the entire Library
} of Congress can fit on a 1T drive.
} 
} > it looks like that would cost you in the neighborhood of $8000. The ink
} > cartridges
} 
} 	It's more like $8 million.
} 
} --
} To unsubscribe from this list: send the line "unsubscribe linux-raid" in
} the body of a message to majordomo@vger.kernel.org
} More majordomo info at  http://vger.kernel.org/majordomo-info.html
} --
} To unsubscribe from this list: send the line "unsubscribe linux-raid" in
} the body of a message to majordomo@vger.kernel.org
} More majordomo info at  http://vger.kernel.org/majordomo-info.html


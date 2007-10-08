From: "Guy Watkins" <linux-raid@watkins-home.com>
Subject: RE: very degraded RAID5, or increasing capacity by adding discs
Date: Mon, 8 Oct 2007 16:08:54 -0400
Message-ID: <200710082008.l98K8xV14216@www.watkins-home.com>
References: <470A846B.9090805@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <470A846B.9090805@sauce.co.nz>
Sender: linux-raid-owner@vger.kernel.org
To: 'Richard Scobie' <richard@sauce.co.nz>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

} -----Original Message-----
} From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
} owner@vger.kernel.org] On Behalf Of Richard Scobie
} Sent: Monday, October 08, 2007 3:27 PM
} To: linux-raid@vger.kernel.org
} Subject: Re: very degraded RAID5, or increasing capacity by adding discs
} 
} Janek Kozicki wrote:
} 
} > Is it possible anyhow to create a "very degraded" raid array - a one
} > that consists of 4 drives, but has only TWO ?
} 
} No, but you can make a degraded 3 drive array, containing 2 drives and
} then add the next drive to complete it.
} 
} The array can then be grown (man mdadm, GROW section), to add the fourth.
} 
} Regards,
} 
} Richard

I think someone once said you could create a 2 disk degraded RAID5 array
with just 1 disk.  Then add one later.  Then expand as needed.  Someone
should test this.


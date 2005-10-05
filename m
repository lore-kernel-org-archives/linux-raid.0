From: Trevor Cordes <trevor@tecnopolis.ca>
Subject: Re: RAID 6 corruption : please help!
Date: Wed, 5 Oct 2005 12:14:52 -0500 (CDT)
Message-ID: <200510051714.j95HEqvA026621@pog.tecnopolis.ca>
References: <20051005152638.GA24382@pog.tecnopolis.ca>
Mime-Version: 1.0
Content-Type: TEXT/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20051005152638.GA24382@pog.tecnopolis.ca>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Followup: Mr Anvin, the author of the RAID6 bits, pointed out to me that
a major bug in RAID6 in degraded mode existed pre 2.6.10 or so.  Since I
had just freshly installed FC3, I was using the stock FC3 DVD 2.6.9.
That caused major corruption on write when degraded.

I'm still playing around to see if I can recover at the filesystem
level, since I didn't do much writing.

Thanks to all who helped.  If anyone has any other ideas, please shout.


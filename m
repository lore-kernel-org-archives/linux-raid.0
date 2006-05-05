From: Erik Mouw <erik@harddisk-recovery.com>
Subject: Re: Two-disk RAID5?
Date: Fri, 5 May 2006 12:24:05 +0200
Message-ID: <20060505102405.GA4900@harddisk-recovery.com>
References: <216D6FA68B0F304DA93E95C5B786F2D12FCBBC@bart.corp.egenera.com> <Pine.LNX.4.61.0604261518020.1846@soloth.lewis.org> <20060501171128.GA18811@harddisk-recovery.com> <445AA801.6050404@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <445AA801.6050404@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Jon Lewis <jlewis@lewis.org>, "Jansen, Frank" <fjansen@egenera.com>, Tuomas Leikola <tuomas.leikola@gmail.com>, John Rowe <rowe@excc.ex.ac.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, May 04, 2006 at 09:18:57PM -0400, Bill Davidsen wrote:
> Erik Mouw wrote:
> >No, the other way around: RAID1 is a special case of RAID5.
> >
> No it isn't. If you have N drives in RAID1 you have N independent copies 
> of the data and no parity, there's just no corresponding thing in RAID5, 
> which has one copy of the data, plus parity. There is no special case, 
> it just doesn't work that way. Set N>2 and report back.

Just write out the formulas and it becomes obvious.

> Sorry, I couldn't find a diplomatic way to say you're completely wrong.

I guess we have to agree to disagree.


Erik

-- 
+-- Erik Mouw -- www.harddisk-recovery.com -- +31 70 370 12 90 --
| Lab address: Delftechpark 26, 2628 XH, Delft, The Netherlands

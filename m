From: maarten <maarten@ultratux.net>
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard)
Date: Tue, 4 Jan 2005 22:05:13 +0100
Message-ID: <200501042205.13061.maarten@ultratux.net>
References: <Pine.LNX.4.44.0501042052430.3584-100000@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0501042052430.3584-100000@uplift.swm.pp.se>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday 04 January 2005 20:57, Mikael Abrahamsson wrote:
> On Tue, 4 Jan 2005, Maarten wrote:
> > failures within the first 10 years, let alone 20, to even remotely
> > support that outrageous MTBF claim.
>
> One should note that environment seriously affects MTBF, even on
> non-movable parts, and probably even more on movable parts.

Yes.  Heat especially above all else.

> I've talked to people in the reliability business, and they use models
> that say that MTBF for a part at 20 C as opposed to 40 C can differ by a
> factor of 3 or 4, or even more. A lot of people skimp on cooling and then
> get upset when their drives fail.
>
> I'd venture to guess that a drive that has an MTBF of 1.2M at 25C will
> have less than 1/10th of that at 55-60C.

Yes. I know that full well.  Therefore my server drives are mounted directly 
behind two monstrous 12cm fans...  I don't take no risks.  :-)

Still, two western digitals have died within the first or second year in that 
enclosure. So much for MTBF vs. real world expectancy I guess.

It should be public knowledge by now that heat is the number 1 killer for 
harddisks.  However, you still see PC cases everywhere where disks are 
sandwiched together and with no possible airflow at all. Go figure... 

Maarten

-- 


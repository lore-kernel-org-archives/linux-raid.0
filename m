From: Konstantin Olchanski <olchansk@triumf.ca>
Subject: Re: Hard drive lifetime: wear from spinning up or rebooting vs running
Date: Sun, 5 Feb 2006 19:57:59 -0800
Message-ID: <20060206035759.GB25631@sam.triumf.ca>
References: <Pine.LNX.4.44.0602022119380.12829-100000@firewall2.tmr.com> <43E68D62.4080704@cogweb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <43E68D62.4080704@cogweb.net>
Sender: linux-raid-owner@vger.kernel.org
To: David Liontooth <liontooth@cogweb.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Feb 05, 2006 at 03:42:26PM -0800, David Liontooth wrote:
> In designing an archival system, we're trying to find data on when it
> pays to power or spin the drives down versus keeping them running.
>
> Temperature obviously matters -- a linear approximation might look like this,
>      Lifetime = 60 - 12 [(t-40)/2.5]

I would expect an exponential rather than linear formula (linear formula yelds
negative life times). L = ... exp(-T) or L = ... exp(1/kT)

> Does anyone have an actual formula?

I doubt it, because it requires measuring lifetimes, which takes
years, by which time the data are useless because the disks you used
are obsolete.

> Or are different components stressed in a running drive versus one that
> is spinning up, so it's not possible to translate the cost of one into
> the currency of the other?

I would expect that spinning-up a drive is very stressful and is likely
to kill the drive [spindle motor power electronics]. In my experience
disk die about evenly from 3 causes: no spinning (dead spindle motor
power electronics), heads do not move (dead head motor power
electronics), or spontaneusly developing bad sectors (disk platter
contamination?).

Hmm... NASA-type people may have data for life times of power electronics,
at least the shape of the temperature dependance (linear or exp or ???).

-- 
Konstantin Olchanski
Data Acquisition Systems: The Bytes Must Flow!
Email: olchansk-at-triumf-dot-ca
Snail mail: 4004 Wesbrook Mall, TRIUMF, Vancouver, B.C., V6T 2A3, Canada

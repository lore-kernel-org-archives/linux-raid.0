From: Francois Barre <francois.barre@gmail.com>
Subject: Re: multiple Sata SATAII 150, TX4 - how to tell which drive is which?headaches galore!
Date: Tue, 24 Jan 2006 18:21:44 +0100
Message-ID: <fd8d0180601240921l7ed29964n@mail.gmail.com>
References: <43D62360.5060001@dgreaves.com>
	 <20060124161043.e90064b0@ted.secure-tunnel.com>
	 <fd8d0180601240912g41b5d645s@mail.gmail.com>
	 <Pine.LNX.4.56.0601241716070.20760@lion.drogon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.56.0601241716070.20760@lion.drogon.net>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Some drives do support quiet vs. performance modes.
>
> hdparm will set this for you, however, from the hdparm manual page:
>
>       -M     Get/set Automatic Acoustic Management (AAM) setting. Most modern
>              harddisk drives have the ability to speed down  the  head  move-
>              ments  to  reduce  their  noise output.  The possible values are
>              between 0 and 254. 128 is the most quiet (and therefore slowest)
>              setting and 254 the fastest (and loudest). Some drives have only
>              two levels (quiet / fast), while others may have different  lev-
>              els  between  128 and 254.  THIS FEATURE IS EXPERIMENTAL AND NOT
>              WELL TESTED. USE AT YOUR OWN RISK.
>
> Good luck!
>
> Gordon
>

Did it ever work for you ?
I may be unlucky, but I never seen this work for any of my drives.
Or maybe my ears are always polluted, and I hear the heads move even
in my dreams :-p....

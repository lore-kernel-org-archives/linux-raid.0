From: Erik Mouw <erik@harddisk-recovery.com>
Subject: Re: Looking for the cause of poor I/O performance
Date: Fri, 3 Dec 2004 12:46:35 +0100
Message-ID: <20041203114635.GB21302@harddisk-recovery.com>
References: <200412030630.51004.systemloc@earthlink.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200412030630.51004.systemloc@earthlink.net>
Sender: linux-raid-owner@vger.kernel.org
To: TJ <systemloc@earthlink.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Dec 03, 2004 at 06:30:51AM -0500, TJ wrote:
> I'm cheap. I use a crossover so I didn't have to spring for the switch. The 
> NICs are Intel 82540EM's. I got them for around $55 per. I didn't think that 
> was too bad for gigabit. Of course, these controllers may be complete trash, 
> I dunno. 

You won't do any better than fast ethernet when you're using a
crossover cable. Gigabit ethernet doesn't need crossover cables for
direct connections, it uses all four wire pairs in cat5 cable and will
automatically figure out if there's a direct connection and do the
right thing (all mandatory by the gigE standard, so every NIC will
support it). If you use a fast ethernet cross cable, the NICs will
autonegotiate to 100 MB/s full-duplex.

The Intel gigE NICs are very good: good hardware, good driver, good
support. Gigabit ethernet switches are becoming rather cheap: 200 EUR
buys you an 8 port switch.


Erik

-- 
+-- Erik Mouw -- www.harddisk-recovery.com -- +31 70 370 12 90 --
| Lab address: Delftechpark 26, 2628 XH, Delft, The Netherlands

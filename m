From: Stephan van Hienen <raid@a2000.nu>
Subject: Re: Promise FastTrak TX4 losing interrupts (with apic mode)
Date: Thu, 6 Feb 2003 19:15:11 +0100 (CET)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.53.0302061913210.17629@ddx.a2000.nu>
References: <Pine.GSO.4.30.0302060728320.15885-100000@multivac.sdsc.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.GSO.4.30.0302060728320.15885-100000@multivac.sdsc.edu>
To: "Peter L. Ashford" <ashford@sdsc.edu>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 6 Feb 2003, Peter L. Ashford wrote:

> I just saw, and fixed, a very similar problem last night (lost interrupts,
> but partition table was eventually read).  The system was a dual Xeon on a
> P4DP6.  The Promise card was an Ultra100TX2.  The OS was RedHat 7.3.
>
> The fix was to increase the bus master time for the PCI slot in the BIOS.
> This was also tried under SuSE 8.1, where it did NOT work.

ultra100tx2 / ultra66 cards work ok in the machines i tested it in (and
also the onboard fasttrak100 on the xeon server (intel mainbord))


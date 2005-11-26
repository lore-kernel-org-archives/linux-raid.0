From: Lajber Zoltan <lajbi@lajli.gau.hu>
Subject: Re: RAID0 performance question
Date: Sat, 26 Nov 2005 20:47:27 +0100 (CET)
Message-ID: <Pine.LNX.4.58.0511262045390.1482@lajli.gau.hu>
References: <437E2CB6.2030903@xss.co.at> <17282.22120.327672.720044@cse.unsw.edu.au>
 <20051122220531.GU26862@skl-net.de> <015c01c5f292$57e0e270$0400a8c0@dcccs>
 <5d96567b0511260756t3989df8ep8c98326fc394ca18@mail.gmail.com>
 <01ca01c5f2a3$ab6ebf00$0400a8c0@dcccs> <Pine.LNX.4.58.0511261810350.1482@lajli.gau.hu>
 <01f901c5f2af$a4312550$0400a8c0@dcccs>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <01f901c5f2af$a4312550$0400a8c0@dcccs>
Sender: linux-raid-owner@vger.kernel.org
To: JaniD++ <djani22@dynamicweb.hu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

If you don't speak hungarian, forget this sentence:

Beszelsz magyarul? akkor folytathatjuk ugy is.


On Sat, 26 Nov 2005, JaniD++ wrote:

> Intel xeon motherboard, intel e1000 x2. (64bit)
> But i already write that, if i cut out the raid, and starts the 4 cat at one
> time the traffic is rise to 780-800 Mbit! :-)
>
> This is not hardware related problem.
> Only tune, or missconfiguration problem.  - I think...

What is in the /proc/interrupts? interruts distibuted over cpus, or all
irq goes for one cpu? What about, if you switch off HT?

Bye,
-=Lajbi=----------------------------------------------------------------
 LAJBER Zoltan               Szent Istvan Egyetem,  Informatika Hivatal
 Most of the time, if you think you are in trouble, crank that throttle!

From: TJ <systemloc@earthlink.net>
Subject: Re: Looking for the cause of poor I/O performance
Date: Fri, 3 Dec 2004 10:09:23 -0500
Message-ID: <200412031009.23717.systemloc@earthlink.net>
References: <200412030630.51004.systemloc@earthlink.net> <20041203114635.GB21302@harddisk-recovery.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20041203114635.GB21302@harddisk-recovery.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Erik Mouw <erik@harddisk-recovery.com>
List-Id: linux-raid.ids

> You won't do any better than fast ethernet when you're using a
> crossover cable. Gigabit ethernet doesn't need crossover cables for
> direct connections, it uses all four wire pairs in cat5 cable and will
> automatically figure out if there's a direct connection and do the
> right thing (all mandatory by the gigE standard, so every NIC will
> support it). If you use a fast ethernet cross cable, the NICs will
> autonegotiate to 100 MB/s full-duplex.

I did not know that auto-sensing was part of the Gigabit standard. I don't 
understand why you would think that performance would be worse with a 
crossover than a straight cable, though. I assure you, the link 
autonegotiates to a gigabit connection. The card driver reports this, the 
card's light indicator reports this, and my benchmarking of throughput has 
proven it.

> The Intel gigE NICs are very good: good hardware, good driver, good
> support. Gigabit ethernet switches are becoming rather cheap: 200 EUR
> buys you an 8 port switch.

Yeah, I knew Intel made good NIC's, and I knew they were linux supported. I'm 
only worried because this is the lowest end model in the line. I wonder if it 
offloads work to the CPU, causing lower throughput on a busy link, while more 
expensive versions handle more work on the card. Also, I have read some 
traffic that the e1000 driver is better tuned for light duty connections, and 
could use some improvement under a heavy workload. If you knew about any 
documentation, or mailing lists on the topic of tuning this, I'd appreciate 
it.

TJ Harrell

From: "Peter L. Ashford" <ashford@sdsc.edu>
Subject: Re: raid5 parity algorithm
Date: Thu, 27 Feb 2003 21:46:35 -0800 (PST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.GSO.4.30.0302272140180.6275-100000@multivac.sdsc.edu>
References: <Pine.LNX.4.53.0302272238300.20334@ddx.a2000.nu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.53.0302272238300.20334@ddx.a2000.nu>
To: Stephan van Hienen <raid@a2000.nu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Stephan,

> Options are: left-asymmetric, left-symmetric, right-asymmetric,
> right-symmetric, la,  ra,  ls,  rs.
> The default is left-symmetric.
>
> What is the difference between this ?

Please see 'http://www.accs.com/p_and_p/RAID/LinuxRAID.html'.  This short
web page provides examples of what the different parity algorithms do to
the segment layout on the disks.  It's easier to read than the code.

> and why do i want to use anything else than the default ?

There exist situations where production applications would be run against
the array.  If speed is CRITICAL, you might want to benchmark the parity
algorithms.  The non-default parity algorithms are more likely to generate
a speedup when the I/O is random.

I hope this helps.
				Peter Ashford


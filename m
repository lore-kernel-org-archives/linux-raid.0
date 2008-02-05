From: Janek Kozicki <janek_listy@wp.pl>
Subject: Re: which raid level gives maximum overall speed? (raid-10,f2 vs.
 raid-0)
Date: Tue, 5 Feb 2008 23:52:15 +0100
Message-ID: <20080205235215.750ea879@szpak>
References: <20080130192133.17b254bf@szpak>
	<20080130220007.GG20173@rap.rap.dk>
	<20080130233639.5d46b044@szpak>
	<20080131015506.GB6617@rap.rap.dk>
	<20080205161036.GA30326@rap.rap.dk>
	<alpine.DEB.1.00.0802051152500.9790@p34.internal.lan>
	<20080205200423.GB17621@rap.rap.dk>
	<alpine.DEB.1.00.0802051726510.10352@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.00.0802051726510.10352@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Justin Piszcz said:     (by the date of Tue, 5 Feb 2008 17:28:27 -0500 (EST))

> I remember testing with bonnie++ and raid10 was about half the speed 
> (200-265 MiB/s) as RAID5 (400-420 MiB/s) for sequential output, 

writing on raid10 is supposed to be half the speed of reading. That's
because it must write to both mirrors.

IMHO raid5 could perform good here, because in *continuous* write
operation the blocks from other HDDs were just have been written,
they stay in cache and can be used to calculate xor. So you could get
close to almost raid-0 performance here.

Randomly scattered small-sized write operations will kill raid5
performance, for sure. Because corresponding blocks from few other
drives must be read, to calculate parity correctly. I'm wondering
how much raid5 performance would go down... Is there a bonnie++ test
for that, or any other benchmark software for this?


> but input was closer to RAID5 speeds/did not seem affected (~550MiB/s).

reading in raid5 and raid10 is supposed to be close to raid-0 speed.

-- 
Janek Kozicki                                                         |

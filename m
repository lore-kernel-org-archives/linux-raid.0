From: John Drescher <drescherjm@gmail.com>
Subject: Re: Safe disk replace
Date: Wed, 5 Sep 2012 10:25:19 -0400
Message-ID: <CAEhu1-6oNLaPuoh-aXtrFsnmPZ2fMGVaQSbtQp7Wkx-sf8MfDg@mail.gmail.com>
References: <20120904041447.GB14445@onthe.net.au>
	<5045D7D9.9000108@hesbynett.no>
	<alpine.DEB.2.00.1209041423250.13902@uplift.swm.pp.se>
	<20120904153342.GA26999@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120904153342.GA26999@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> I'm currently upgrading my RAID-6 arrays via hot-replacement. The
> process I followed (to replace device YYY in array mdXX) is:
>     - add the new disk to the array as a spare
>     - echo want_replacement > /sys/block/mdXX/md/dev-YYY/state
>
> That kicks off the recovery (a straight disk-to-disk copy from YYY to
> the new disk). After the rebuild is complete, YYY gets failed in the
> array, so can be safely removed:
>     - mdadm -r /dev/mdXX /dev/mdYYY
>

Thanks for the info. I wanted this feature for years at work..

I am testing this now on my test box. Here I have 13 x 250GB SATA 1
drives. Yes these are 8+ years old..

md1 : active raid6 sda2[13](R) sdk2[17] sdj2[18] sdf2[16] sdm2[19]
sdl2[14] sdi2[12] sdg2[15] sde2[5] sdd2[4] sdh2[21] sdb2[20] sdc2[1]
      2431477760 blocks super 1.2 level 6, 512k chunk, algorithm 2
[12/12] [UUUUUUUUUUUU]
      [>....................]  recovery =  3.4% (8401408/243147776)
finish=75.9min speed=51540K/sec


Speeds are faster than failing a drive but I would do this more for
the lower chance of failure more than the improved performance:

md1 : active raid6 sdk2[17] sdj2[18] sdf2[16] sdm2[19] sdl2[14]
sdi2[12] sdg2[15] sde2[5] sdd2[4] sdh2[21] sdb2[20] sdc2[1]
      2431477760 blocks super 1.2 level 6, 512k chunk, algorithm 2
[12/11] [_UUUUUUUUUUU]
      [>....................]  recovery =  1.2% (3134952/243147776)
finish=100.1min speed=39954K/sec

John

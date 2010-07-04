From: Janek Kozicki <janek_listy@wp.pl>
Subject: Re: raid5 failed while rebuiling - classical problem
Date: Sun, 4 Jul 2010 10:18:34 +0200
Message-ID: <20100704101834.42976337@atak.bl.pg.gda.pl>
References: <20100702163155.511919c1@atak.bl.pg.gda.pl>
	<20100702231854.105b8612@atak.bl.pg.gda.pl>
	<20100703033659.0cffc6ad@natsu>
	<20100703174727.26a8965a@natsu>
	<20100703155140.01250825@atak.bl.pg.gda.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100703155140.01250825@atak.bl.pg.gda.pl>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

fsck finished, fixed a heft of bad inodes, and now everything seems
to be fine. So now I'm going to upgrade all that, use latest kernel,
then switch to raid6.

I tested /dev/hda with badblocks read-write tests, and now it works
fine, which is kind of disappointing, because it caused to me so much
trouble. Its warranty is going to expire in 3 months, but since it
works fine now I don't think that I could get it replaced. I guess
that it will "really die" after its warranty will expire...

-- 
Janek Kozicki                               http://janek.kozicki.pl/  |

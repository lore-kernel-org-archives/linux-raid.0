From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Storage system
Date: Thu, 6 Feb 2014 19:09:09 +0100
Message-ID: <20140206180909.GA2419@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

this question is only partially related to Linux MD,
but since the experts are here, I think it would not
be a big problem to ask here.

I'm considering a storage system.
This is based on HDD "rust".
It should have RAID-6, for protection agaist disk
failure(s).
It should have LUKS (or similar), in order to simplify
HDD disposal (disk that are still somehow readable will
not need to be wiped out before dumping them).
It should have LVM, as flexible partition system.

Now, given that the HDD are always the lower layer, the
others can be combined in any order.
Six possible combinations, specifically, naming:

H: HDD
R: RAID
E: encryption
L: LVM

We can have:

HREL
HRLE
HLRE
HLER
HERL
HELR

Those are all possible (and valid) configurations.
Some are "better" and some are less "good", depending
on "good" or "bad" definition.
For example, in term of pure performances, I tested
HREL vs. HERL, the first is quite faster than the
second one.
On the other hand, HERL encrypts the RAID header, so
delivers less information to whoever wants to check
the disk content.

HRLE gives the possibility of having volumes encrypted
separately, allowing a finer security control.

HLxy, I think, do not really offer any advantage, but
I'm not sure.

So, finally, the question would be:

Knowing that it depends on requirements, do you think
one of this configuration is better than the other?
Why?

Feel free to elaborate, if you like.

Thanks a lot in advance,

-- 

piergiorgio

From: Franck Routier <franck.routier@axege.com>
Subject: Understanding bonnie++ results
Date: Thu, 28 Feb 2008 10:46:29 +0100
Message-ID: <1204191989.16924.10.camel@franck-gusty>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I am experimenting with Adaptec 31205 hardware raid versus md raid on
raid level 10 with 3 arrays of 4 disks each.
md array was created with f2 option.
I get some results with bonnie++ tests I would like to understand:

- per char sequential output is consistantly around 70k/sec for both
setup
- but block sequential output shows a huge difference between hw and sw
raid: about 160k/sec for hw versus 60k/sec for md. Where can this come
from ??

On the contrary, md beat hw on inputs:
- sequential input show 360k/sec versus 220k/sec for hw
- random seek 1350/sec for md versus 1150/sec for hw

So, these bonnie++ tests show quite huge differences for the same
hardware between adaptec's hardware setup and md driver.

Does anyone has any explanation on this ? (btw, the fs on top of this is
xfs).

Franck



From: Rainer Fuegenstein <rfu@kaneda.iguw.tuwien.ac.at>
Subject: resync duration ?
Date: Thu, 14 May 2009 15:06:47 +0200
Message-ID: <1308264373.20090514150647@kaneda.iguw.tuwien.ac.at>
Reply-To: Rainer Fuegenstein <rfu@kaneda.iguw.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi guys,

I'm a but confused about the duration of a raid5 resync:

- occasionally, my server with 4*750 gb sata raid5 crashed (because of
problems with the power supply); after rebooting it took about 10 to 12
hours to resync the raid5 (guess it just re-created some parity
information or however it works internally, but didn't have to copy
any data)

- right now I replaced one 750GB disk with a 1.5TB disk, but now
resyncing (according to /proc/mdstat) it is supposed to take only 160
minutes ?! although it needs top copy data to a blank disk ?

is this normal or should I be worried, especially before I pull out
the next 750GB disk and replace it with the next 1.5TB disk ?

tnx in advance.


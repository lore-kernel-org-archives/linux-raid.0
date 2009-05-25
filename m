From: Janek Kozicki <janek_listy@wp.pl>
Subject: Adaptec 2405 : hardware or software raid?
Date: Mon, 25 May 2009 17:32:01 +0200
Message-ID: <20090525173201.25dc3f35@hydro.bl.pg.gda.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I've bought the cheap Adaptec 2405 SAS controller for the sole
purpose of using 15k rpm HDDs. It turns out that to expose the HDDs
to the system I must first launch the computer from enclosed CD and
create some logical volumes. Those logical volumes can mix HDDs in
various raid configurations (1,0,10,5) and expose a single
device, eg. /dev/sda from multiple HDDs.

This is the first time when I see the "logical volumes" option
mandatory. I was planning to access the HDDs directly and create
software raid on them with mdadm.

It is possible, however to create ONE logical volume per ONE physical
disc, and then I can use mdadm on them.

But now, having seen this Adaptec software/tool to generate the
hardware raid configurations (and no way around it) I started to
wonder what approach is better?

What do you recommend:

- make one logical volume per disc and use only software raid?
- use Adaptec 2405 hardware raid entirely?
- or do you know some way around the hardware and access the SAS
  discs directly? (is that approach safe?)

What has better linux support (which kernel version), other
considerations, etc...

thanks in advance for your help
-- 
Janek Kozicki

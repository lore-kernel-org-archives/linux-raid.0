From: linux@horizon.com
Subject: Re: suggestions for SATA controllers (PCI-X or PCI-E), e.g. Highpoint,
Date: 26 Sep 2005 13:13:44 -0400
Message-ID: <20050926171344.14414.qmail@science.horizon.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: schmidt@naa.net
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Has abybody used a card like that for this or can anyone sugest a better 
> (cheap) solution in the USD 200 region?

I did a very similar thing with 3x SIIG SC-SAE012-S1 2-port PCIe
SATA controllers.  Running just great right now.  I had to up the 200
MB/sec reconstruction bandwidth limit because I was bumping into it and
throttling while setting up the array.

They're US$50 each, which is the same as $200 for 8 ports but you
can buy less if you want.  And I can definitely suck more than 250 MB/sec
off of 4 drives, so only 2 ports per PCIe x1 actually makes sense.

These are actually Silicon Image Si3132 controller chips, which have
all the modern features and vendor support to the libata developers.
Grab the development "sata_sil24" driver to make it work the best;
the regular sata_sil driver will work, but you need a very recent kernel
or a one-line patch to recognize the PCI ID (1095:3132).

(Not to mention, Silicon Image make th only shipping SATA port multiplier
today, do you know port multiplier support is possible eventually.)

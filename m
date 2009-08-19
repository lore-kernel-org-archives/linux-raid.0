From: Anatolij Gustschin <agust@denx.de>
Subject: Code base for rework of ppc440SPe ADMA driver
Date: Wed, 19 Aug 2009 15:49:16 +0200
Message-ID: <4A8C02DC.8050308@denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Dan,

Currently I am trying to estimate efforts for rework of the
ppc440SPe ADMA driver for inclusion in mainline Linux and a couple of
questions have arisen. As the current ASYNC_TX API in mainline Linux
doesn't contain support for RAID6 offload operations, the current
ppc440SPe ADMA driver have to be reworked to support RAID5 operations
only which would be a step backward and also would require some
changes in the ASYNC_TX code to cope with large dma_addr_t addresses.
Therefore my understanding is that the rework of the ADMA driver for
inclusion in mainline should be better based on code from your raid6
branch. Or what would be a better base?

If I understand it correctly initially the intention was to place
this work in linux-next and probably submit a pull request towards
the end of the 2.6.31 merge window. Is there any plan to proceed with
this?  Did you get a chance to look at per-cpu implementation for the
scribble-buffer?

Thanks,
Anatolij

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: +49-8142-66989-0 Fax: +49-8142-66989-80  Email: office@denx.de

From: Leif Nixon <nixon@nsc.liu.se>
Subject: raid6 check/repair
Date: Thu, 15 Nov 2007 16:28:10 +0100
Message-ID: <m3wssjr0j9.fsf@unna.nsc.liu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I have been looking a bit at the check/repair functionality in the
raid6 personality.

It seems that if an inconsistent stripe is found during repair, md
does not try to determine which block is corrupt (using e.g. the
method in section 4 of HPA's raid6 paper), but just recomputes the
parity blocks - i.e. the same way as inconsistent raid5 stripes are
handled.

Correct?

-- 
Leif Nixon                       -            Systems expert
------------------------------------------------------------
National Supercomputer Centre    -      Linkoping University
------------------------------------------------------------

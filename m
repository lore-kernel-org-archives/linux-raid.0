From: "H. Peter Anvin" <hpa@zytor.com>
Subject: RAID-6
Date: 11 Nov 2002 10:52:36 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <aqou9k$ou5$1@cesium.transmeta.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

I'm playing around with RAID-6 algorithms lately.  With RAID-6 I mean
a setup which needs N+2 disks for N disks worth of storage and can
handle any two disks failing -- this seems to be the contemporary
definition of RAID-6 (the originally proposed "two-dimensional parity"
which required N+2*sqrt(N) drives never took off for obvious reasons.)

Based on my current research, I think the following should be true:

a) write performance will be worse than RAID-5, but I believe it can
   be kept to within a factor of 1.5-2.0 on machines with suitable
   SIMD instruction sets (e.g. MMX or SSE-2);

b) read performance in normal and single failure degraded mode will be
   comparable to RAID-5;

c) read performance in dual failure degraded mode will be quite bad.

I'm curious how much interest there would be in this, since I
certainly have enough projects without it, and I'm probably going to
need some of Neil's time to integrate it into the md driver and the
tools.

	-hpa
-- 
<hpa@transmeta.com> at work, <hpa@zytor.com> in private!
"Unix gives you enough rope to shoot yourself in the foot."
http://www.zytor.com/~hpa/puzzle.txt	<amsp@zytor.com>

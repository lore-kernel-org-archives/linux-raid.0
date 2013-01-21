From: pg@lxra2.for.sabi.co.UK (Peter Grandi)
Subject: Re: Suboptimal raid6 linear read speed
Date: Mon, 21 Jan 2013 20:55:32 +0000
Message-ID: <20733.43844.275852.712757@tree.ty.sabi.co.uk>
References: <20130115125507.GA12184@rabbit.us>
	<50F614F7.20104@hardwarefreak.com>
	<20130116025857.GA31112@rabbit.us>
	<50F70DB7.6020104@hardwarefreak.com>
	<alpine.DEB.2.00.1301171648260.12098@uplift.swm.pp.se>
	<50F90857.3010305@hardwarefreak.com>
	<alpine.DEB.2.00.1301181015270.12098@uplift.swm.pp.se>
	<50F9D32F.7090606@hardwarefreak.com>
	<alpine.DEB.2.00.1301190838440.12098@uplift.swm.pp.se>
	<20732.17741.587765.199649@tree.ty.sabi.co.uk>
	<20130121144039.GA4103@rabbit.us>
	<20733.42432.839120.845767@tree.ty.sabi.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20733.42432.839120.845767@tree.ty.sabi.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


> [ ... ] More generally, given a N data blocks and M "parity"
> blocks per stripe, [ ... ]

As an aside, N or M (not both...) can be 0. When M is zero
that's RAID0, and when N is zero all or (more usefully) a subset
of M "parity" blocks are needed to reconstruct any one data
block; for example M is 5, there are 3 data blocks encoded
across them, and any data block can be reconstructed given any 4
"parity" blocks -- numbers made up BTW.

In general a logical RAID is a matrix of rows of W data and/or
parity blocks times S the number of stripes, and RAID
implementations remap that onto another matrix of D storage
devices each with C blocks; where both the stripe matrix and
athe storage matrix can be be subdivided, by row or column
(usually the stripe matrix columwise and the device matrix
rowwise).

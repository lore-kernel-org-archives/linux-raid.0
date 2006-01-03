From: Konstantin Olchanski <olchansk@triumf.ca>
Subject: Re: SATA performace
Date: Mon, 2 Jan 2006 21:04:15 -0800
Message-ID: <20060103050414.GF28438@sam.triumf.ca>
References: <17336.42843.779496.644030@smtp.charter.net> <000d01c61017$ea630d10$3224050a@avilespaxp> <20060103044759.GA8876@lug.udel.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20060103044759.GA8876@lug.udel.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Ross Vandegrift <ross@jose.lug.udel.edu>
Cc: Paul Aviles <paul.aviles@palei.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Jan 02, 2006 at 11:47:59PM -0500, Ross Vandegrift wrote:
> On Mon, Jan 02, 2006 at 10:43:47PM -0500, Paul Aviles wrote:
> > Are SATA drives similar in performance than IDE drives? I have tested 
> > Barracudas 7200.0 (500Gb) and WD too on the same type of servers (more than 
> > 1 unit) and what I am getting is painfully slow in terms of read/writes. 

In modern systems, disk performance is dominated by the physical disk
characteristics: rotation speed and seek times (ignoring speedups from
Linux-level, controller-level and disk-level i/o reordering and caching).

So you should (and we do) see almost identical performance between
similar PATA and SATA disks. For bulk data streaming, you should see
30-60 Mbytes/sec for a single disk.

The only performance-degrading problems I have seen are a) PATA
disks running in non-DMA modes (bulk data streaming rate = 3 Mbytes/sec)
and b) barely-readable sectors on many new high-density disks (disk-level
read retries, takes seconds to read one sector, kills performance).

Problem (b) is quite evil and hard to diagnose: it seems to be temperature
dependant, it is not reported by SMART, and it is not reported
by Linux (unless it is so bad that you get a read timeouts). For RAID sets,
it causes erratic performance.

-- 
Konstantin Olchanski
Data Acquisition Systems: The Bytes Must Flow!
Email: olchansk-at-triumf-dot-ca
Snail mail: 4004 Wesbrook Mall, TRIUMF, Vancouver, B.C., V6T 2A3, Canada

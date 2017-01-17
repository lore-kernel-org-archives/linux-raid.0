From: Eric Schwarz <eas@sw-optimization.com>
Subject: Soft-Raid 0 Performance | Transfer two Data-Streams (CPU+FPGA) to the
 same Soft-Raid
Date: Tue, 17 Jan 2017 16:00:47 +0100
Message-ID: <0e04b53af8bdf4f39a08b31ea4499626@sw-optimization.com>
References: <21298bd64ef0dc83b29bd45362ead46c@sw-optimization.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <21298bd64ef0dc83b29bd45362ead46c@sw-optimization.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello mailing list,

I have got two questions:

1.) I have set-up a softraid (raid level 0) with mdadm using two M.2 
modules. For one module the throughput is ~350MB/s (no mdadm) for two 
modules the throughput is ~500MB/s which is less than factor 1,5 of the 
throughput of a single drive. The filesystem used is ext4. Is there 
someone having some values for comparison? For me the throughput gain 
seems to be too little. The test was done using a HP Z840 workstation.

2.) We want to configure a softraid (raid level 0) with mdadm which can 
be used from within Linux but also it should be possible to write data 
to the raid w/ DMA directly from the FPGA which is also connected to the 
PCIe bus as a slave as well as the M.2 modules. How can that be achieved 
using existing kernel infrastructure?

Many thanks for helpful replies
Eric

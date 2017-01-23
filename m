From: Coly Li <colyli@suse.de>
Subject: Re: Soft-Raid 0 Performance | Transfer two Data-Streams (CPU+FPGA) to
 the same Soft-Raid
Date: Mon, 23 Jan 2017 16:40:00 +0800
Message-ID: <f2c7fa6f-3061-9baa-d2dd-1abbe7e22cfe@suse.de>
References: <21298bd64ef0dc83b29bd45362ead46c@sw-optimization.com>
 <0e04b53af8bdf4f39a08b31ea4499626@sw-optimization.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <0e04b53af8bdf4f39a08b31ea4499626@sw-optimization.com>
Sender: linux-raid-owner@vger.kernel.org
To: Eric Schwarz <eas@sw-optimization.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2017/1/17 下午11:00, Eric Schwarz wrote:
> Hello mailing list,
> 
> I have got two questions:
> 
> 1.) I have set-up a softraid (raid level 0) with mdadm using two M.2
> modules. For one module the throughput is ~350MB/s (no mdadm) for two
> modules the throughput is ~500MB/s which is less than factor 1,5 of the
> throughput of a single drive. The filesystem used is ext4. Is there
> someone having some values for comparison? For me the throughput gain
> seems to be too little. The test was done using a HP Z840 workstation.
> 

Hi Eric,

Could you attach your testing script as well, than we can have a look.



> 2.) We want to configure a softraid (raid level 0) with mdadm which can
> be used from within Linux but also it should be possible to write data
> to the raid w/ DMA directly from the FPGA which is also connected to the
> PCIe bus as a slave as well as the M.2 modules. How can that be achieved
> using existing kernel infrastructure?
> 

I don't know such existing kernel code. Maybe other people can provide
useful information.

Coly


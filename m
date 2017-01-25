From: Eric Schwarz <eas@sw-optimization.com>
Subject: Re: Soft-Raid 0 Performance | Transfer two Data-Streams (CPU+FPGA) to
 the same Soft-Raid
Date: Wed, 25 Jan 2017 17:49:09 +0100
Message-ID: <082d8b01add3650584dd44a13ca9b78b@sw-optimization.com>
References: <21298bd64ef0dc83b29bd45362ead46c@sw-optimization.com>
 <0e04b53af8bdf4f39a08b31ea4499626@sw-optimization.com>
 <f2c7fa6f-3061-9baa-d2dd-1abbe7e22cfe@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f2c7fa6f-3061-9baa-d2dd-1abbe7e22cfe@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Coly,

>> 1.) I have set-up a softraid (raid level 0) with mdadm using two M.2
>> modules. For one module the throughput is ~350MB/s (no mdadm) for two
>> modules the throughput is ~500MB/s which is less than factor 1,5 of 
>> the
>> throughput of a single drive. The filesystem used is ext4. Is there
>> someone having some values for comparison? For me the throughput gain
>> seems to be too little. The test was done using a HP Z840 workstation.
> 
> Hi Eric,
> 
> Could you attach your testing script as well, than we can have a look.

Create RAID0:
$ mdadm --create /dev/md0 --auto md --level=0 --raid-devices=2 /dev/sdb1 
/dev/sdc1

Write to bare RAID0:
$ dd if=/dev/zero of=/dev/md0 bs=1G count=1 oflag=dsync

dd will show the throughput

Cheers
Eric

From: David Greaves <david@dgreaves.com>
Subject: Re: raid5/lvm setup questions
Date: Mon, 07 Aug 2006 23:28:46 +0100
Message-ID: <44D7BE9E.6020807@dgreaves.com>
References: <20060805165358.GA29177@cm.nu> <44D4D5F9.9080201@dgreaves.com> <87mzagz5d2.fsf@hades.wkstn.nix> <20060807200455.GA29837@cm.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060807200455.GA29837@cm.nu>
Sender: linux-raid-owner@vger.kernel.org
To: Shane <shane@cm.nu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Shane wrote:
> On Mon, Aug 07, 2006 at 08:57:13PM +0100, Nix wrote:
>> On 5 Aug 2006, David Greaves prattled cheerily:
>>> As an example of the cons: I've just set up lvm2 over my raid5 and whilst
>>> testing snapshots, the first thing that happened was a kernel BUG and an oops...
>> I've been backing up using writable snapshots on LVM2 over RAID-5 for
>> some time. No BUGs.
> 
> Just performed some basic throughput tests using 4 SATA
> disks in a raid5 array.  The read performance on the
> /dev/mdx device runs around 180mbps but if lvm is layered
> over that, reads on the lv are around 130mbps.  Not an
> unsubstantial reduction.
Check the readahead at various block levels
blockdev --setra xxx

I think I found the best throughput (for me) was with 0 readahead for /dev/hdX,
0 for /dev/mdX and lots for /dev/vg/lv

> 
> I seem to recall patches to md floating around a couple
> years back for partitioning of md devices.  Are those still
> available somewhere?
man mdadm and see --auto...

David


-- 

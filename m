From: Farkas Levente <lfarkas@bppiac.hu>
Subject: Re: maximum size
Date: Tue, 27 Sep 2005 15:51:10 +0200
Message-ID: <43394E4E.4060702@bppiac.hu>
References: <43394753.9040107@bppiac.hu> <17209.18879.583532.761762@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17209.18879.583532.761762@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Tuesday September 27, lfarkas@bppiac.hu wrote:
> 
>>hi,
>>i'd been already asked, but don't get any answer. what is the maximum 
>>size of a raid5 and raid5 partition in kerenel 2.6? i try to find the 
>>answer but found only kernel 2.4 info.
>>thanks in advance.
>>
> 
> 
> Providing you are using either 64bit hardware, or the 'LBD' (large
> block device) config, then raid5 arrays can be up to 2^64 -
> i.e. enormous - no practical limit.

huu, i don't know. we use 3ware 7506 controller. on it onw homepage it 
said:
---------------------------
Supports up to 12 drives with a single PCI card enabling up to 3.6 
terabytes of storage (dependent on drive capacity, 2TB per array maximum)
---------------------------
but it's all about the hardware raid5. so it's native hardware raid5 
can't be larger than 2TB.
and another quote:
---------------------------
PCI 2.2 compliant 64-bit / 66MHz bus master (2-port controllers are
32-bit / 66MHz PCI compliant)
---------------------------
but it's the pci bus interface not the device.
and as we use in jbod mode there is no info about it. and i read again 
the spec but can't find any info about it.

> I don't know what you mean by 'raid5 partition'.  If you mean like a
> regular partition of a device, then the partition can be nearly as bit
> as the array....

suppose i create the raid device with:
mdadm --create /dev/md0--level=5 --raid-devices=8 --spare-devices=1 
/dev/sd[abcdefgh]1
then what is the maximum size for /dev/md0?
(or more precisely after a mkfs.ext3 /dev/md0).
yours.

-- 
   Levente                               "Si vis pacem para bellum!"


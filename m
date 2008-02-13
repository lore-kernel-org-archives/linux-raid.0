From: David Greaves <david@dgreaves.com>
Subject: Re: transferring RAID-1 drives via sneakernet
Date: Wed, 13 Feb 2008 09:32:14 +0000
Message-ID: <47B2B91E.6000704@dgreaves.com>
References: <e03b90ae0802111659v2889dc52kc6eed9dfc9478f9e@mail.gmail.com>	 <47B1633F.5030403@dgreaves.com>	 <e03b90ae0802121050t192fba6ai5c10338844a60a05@mail.gmail.com>	 <47B1ECD2.8070406@redhat.com> <e03b90ae0802121914q595a492ft844bde202bd09a0d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e03b90ae0802121914q595a492ft844bde202bd09a0d@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Breidenbach <jeff@jab.org>
Cc: Brendan Conoboy <blc@redhat.com>, linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Jeff Breidenbach wrote:
>> It's not a RAID issue, but make sure you don't have any duplicate volume
>> names.  According to Murphy's Law, if there are two / volumes, the wrong
>> one will be chosen upon your next reboot.
> 
> Thanks for the tip. Since I'm not using volumes or LVM at all, I should be
> safe from this particular problem.

Volumes is being used as a generic term here.

You would be safest if, for the disks/partitions you are transferring, you made
the partition type 0x83 (linux) instead of 0xfd to prevent the kernel autodetecting.

Otherwise there is a risk that /dev/md0 and /dev/md1 will be transposed.

Having done that you can manually assemble the array and then configure
mdadm.conf to associate the UUID with the correct md device.

David

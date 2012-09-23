From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: GPT Table broken on a Raid1
Date: Sun, 23 Sep 2012 13:00:51 +0100
Message-ID: <505EF9F3.7000908@anonymous.org.uk>
References: <4961154.0TR9MeFlIq@techz> <2627519.Y2VdWh5VBI@techz> <1BDFB79A-E375-47F2-8EDF-8F51D8774651@colorremedies.com> <1361158.MkTZ6QR6cp@techz> <E9C051A7-65EB-48F5-8D3B-1C374F271E0C@colorremedies.com> <3EC7177F-9973-4D2E-988B-7020298E1727@colorremedies.com> <505DD9E2.7090908@anonymous.org.uk> <F7E53090-1143-4811-86B9-E71923B98AA2@colorremedies.com> <505E368A.4020200@anonymous.org.uk> <6FBE5434-A133-43C0-8296-58978301D32B@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6FBE5434-A133-43C0-8296-58978301D32B@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 22/09/2012 23:30, Chris Murphy wrote:
> On Sep 22, 2012, at 4:07 PM, John Robinson wrote:
[...]
>> I'm saying that when the Linux kernel boots, and the AHCI driver starts, it sees the IMSM member discs as raw discs, which get probed for partitions. The GPT partition probe spots one of the copies of the GPT partition, but can't find the other one because the IMSM metadata's there.
>
> The IMSM metadata will go at the end of the PHYSICAL disk. If you partition the virtual disk, i.e. the array, /dev/md/imsm0, then the GPT alternate header goes at the end of the virtual disk, NOT the end of the physical disk.

That's right. But the main GPT partition table will go at LBA=1 of the 
virtual disc, which maps to LBA=1 of the physical disc. So when the 
physical disc gets probed for partitions, the main GPT partition table 
is visible at LBA=1, but there isn't a secondary GPT partition table at 
the end of the disc, hence the error.

Cheers,

John.


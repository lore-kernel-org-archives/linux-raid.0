From: Miquel van Smoorenburg <mikevs@xs4all.net>
Subject: Re: GPT Table broken on a Raid1
Date: Tue, 25 Sep 2012 09:33:45 +0200
Message-ID: <50615E59.9070503@xs4all.net>
References: <4961154.0TR9MeFlIq@techz> <2627519.Y2VdWh5VBI@techz> <1BDFB79A-E375-47F2-8EDF-8F51D8774651@colorremedies.com> <1361158.MkTZ6QR6cp@techz> <E9C051A7-65EB-48F5-8D3B-1C374F271E0C@colorremedies.com> <3EC7177F-9973-4D2E-988B-7020298E1727@colorremedies.com> <505DD9E2.7090908@anonymous.org.uk> <F7E53090-1143-4811-86B9-E71923B98AA2@colorremedies.com> <505E368A.4020200@anonymous.org.uk> <6FBE5434-A133-43C0-8296-58978301D32B@colorremedies.com> <505EF9F3.7000908@anonymous.org.uk> <142B3AEB-45FE-4A6E-A03F-BEAA9599C2DC@colorremedies.com> <D14F019C-39C6-4C60-88EF-A7565FA93D6F@colorremedies.com> <506029DB.3080407@anonymous.org.uk> <8AB64122-6198-4A2E-BA49-76BD6AFE7907@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8AB64122-6198-4A2E-BA49-76BD6AFE7907@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 24-09-12 7:35 PM, Chris Murphy wrote:
> Further, it seems increasingly clear as I'm reading the UEFI spec on
> GPT, that IMSM is incompatible with GPT. The GPT alternate header by
> spec is expected at the end of the disk, but then IMSM also demands
> to be in basically the exact same location. And yet Intel is shipping
> UEFI hardware, which require GPT disks, with IMSM on board that also
> requires metadata in the same location? How is this not a WTF
> moment?

It isn't. It's just RAID setup with the superblock at the end of the 
disk- as soon as RAID1 is activated, the RAID volume you see is just a 
bit smaller than the raw disksize, and the GPT alternate header is at 
the right place- at the end of the RAID volume.

The thing is that the Linux kernel detects the GPT partition table on 
the raw disks before the RAID1 volume is assembled. More of a cosmetical 
bug.

People have argued before that the kernel should do no partitiontable 
discovery at all, and just leave it to userspace. That's what kpartx is 
for, for example. In that case, with a correctly ordered and configured 
stack, the disks would get detected, any whole-disk RAID volumes would 
get assembled, and only then partition detection would be done. But I 
think that never got popular because of all the "I want to boot a kernel 
without an initramfs" people.

Mike.

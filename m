From: Chris Murphy <lists@colorremedies.com>
Subject: Re: GPT Table broken on a Raid1
Date: Sat, 22 Sep 2012 12:45:39 -0600
Message-ID: <F7E53090-1143-4811-86B9-E71923B98AA2@colorremedies.com>
References: <4961154.0TR9MeFlIq@techz> <2627519.Y2VdWh5VBI@techz> <1BDFB79A-E375-47F2-8EDF-8F51D8774651@colorremedies.com> <1361158.MkTZ6QR6cp@techz> <E9C051A7-65EB-48F5-8D3B-1C374F271E0C@colorremedies.com> <3EC7177F-9973-4D2E-988B-7020298E1727@colorremedies.com> <505DD9E2.7090908@anonymous.org.uk>
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <505DD9E2.7090908@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Sep 22, 2012, at 9:31 AM, John Robinson wrote:

> 
> I don't think there's anything wrong here.
> 
> The kernel sees the whole discs, sda and sdb, and complains that the GPT partition table looks wrong becase the second copy isn't at the end of the discs. That's correct, at the end of the raw discs is the IMSM metadata.

OK so sda and sdb shouldn't have been partitioned in the first place, is what that tells me.


> Don't try to change the partition tables on /dev/sda and sdb or you will damage the IMSM metadata.

Sounds like either imsm metadata is either not well designed for GPT, or it was intended to be placed on an unpartitioned disk in the first place. 


Chris Murphy
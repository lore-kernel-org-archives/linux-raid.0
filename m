From: Chris Murphy <lists@colorremedies.com>
Subject: Re: GPT Table broken on a Raid1
Date: Sun, 23 Sep 2012 11:44:32 -0600
Message-ID: <142B3AEB-45FE-4A6E-A03F-BEAA9599C2DC@colorremedies.com>
References: <4961154.0TR9MeFlIq@techz> <2627519.Y2VdWh5VBI@techz> <1BDFB79A-E375-47F2-8EDF-8F51D8774651@colorremedies.com> <1361158.MkTZ6QR6cp@techz> <E9C051A7-65EB-48F5-8D3B-1C374F271E0C@colorremedies.com> <3EC7177F-9973-4D2E-988B-7020298E1727@colorremedies.com> <505DD9E2.7090908@anonymous.org.uk> <F7E53090-1143-4811-86B9-E71923B98AA2@colorremedies.com> <505E368A.4020200@anonymous.org.uk> <6FBE5434-A133-43C0-8296-58978301D32B@colorremedies.com> <505EF9F3.7000908@anonymous.org.uk>
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <505EF9F3.7000908@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Sep 23, 2012, at 6:00 AM, John Robinson wrote:
> 
> That's right. But the main GPT partition table will go at LBA=1 of the virtual disc, which maps to LBA=1 of the physical disc. So when the physical disc gets probed for partitions, the main GPT partition table is visible at LBA=1, but there isn't a secondary GPT partition table at the end of the disc, hence the error.

The primary header contains the location of the alternate header. So the kernel wouldn't be looking at the end of the physical disk if the GPT were created for the virtual disk, and not the physical disk.

If IMSM only applies an offset to the end of the disk, such that it merely changes the last usable LBA and therefore there is a 1:1 correlation between array LBA's and physical disk LBA's, the kernel would find the alternate GPT header. Yet it isn't, so still something isn't right.

Chris Murphy



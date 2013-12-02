From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Triple parity and beyond
Date: Sun, 01 Dec 2013 22:30:57 -0600
Message-ID: <529C0D01.4040903@hardwarefreak.com>
References: <529B77A1.3070602@clear.net.nz>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <529B77A1.3070602@clear.net.nz>
Sender: linux-raid-owner@vger.kernel.org
To: Richard Scobie <r.scobie@clear.net.nz>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 12/1/2013 11:53 AM, Richard Scobie wrote:
> Stan Hoeppner wrote:
> 
>> ZERO SATA drives are dual ported.  The vast majority of people using
>> md/RAID are using SATA disks, not SAS.
> 
> While admittedly uncommon, they are available.
> 
> http://h30094.www3.hp.com/product/sku/10435415

Assuming that's not a misprint, then this is not a dual ported SATA
drive.  The SATA protocol doesn't support this.  This is a SATA drive in
HP's vendor proprietary carrier with a proprietary factory integrated
external SAS interposer card hanging off the back.  This interposer
allows you to add this SATA drive to an HP dual ported SAS enclosure
backplane and HBAs.  They also offer an interposer to drop SATA drives
into FC enclosures.

Note these SAS-SATA interposers require SAS HBAs and an SAS enclosure.
Given the small price difference between SATA drives w/interposer, and
native nearline SAS drives, and the greater reliability/warranty of the
latter, I don't think you'll see many folks buying these interposer
drives.  Especially given the required investment in SAS infrastructure
between the drives and host.

See:

http://serialstoragewire.net/Articles/2007_07/developer24.html
http://en.wikipedia.org/wiki/Interposer

-- 
Stan

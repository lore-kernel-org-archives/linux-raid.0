From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: RAID performance
Date: Fri, 15 Feb 2013 12:10:07 +1100
Message-ID: <511D8AEF.8040202@websitemanagers.com.au>
References: <51134E43.7090508@websitemanagers.com.au> <CAKHEz2YLpyyqo-3XX=pX+D49QP1Y0DNaKcBN=9tPQDjmHAPfdw@mail.gmail.com> <51137FB8.6060003@websitemanagers.com.au> <CAKHEz2ZyG5xQC78GykbWOfk9EF=r7jcSe_01P=bH7NuJuFBEvA@mail.gmail.com> <5113A2D6.20104@websitemanagers.com.au> <CAKHEz2YgiQiknBXju9a=PR3zV1Hb7ux8yBZWywiTi=BXFm20GA@mail.gmail.com> <51150475.2020803@websitemanagers.com.au> <51157141.90205@hardwarefreak.com> <9ABA2459-DB04-40CA-996E-D02FEE43291B@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <9ABA2459-DB04-40CA-996E-D02FEE43291B@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: "linux-raid@vger.kernel.org list" <linux-raid@vger.kernel.org>, "stan@hardwarefreak.com Hoeppner" <stan@hardwarefreak.com>
List-Id: linux-raid.ids

On 15/02/13 09:42, Chris Murphy wrote:
> (digging back through some things now that the higher priority tasks
> appear covered)
> 
> 
> On Feb 8, 2013, at 2:42 PM, Stan Hoeppner <stan@hardwarefreak.com>
> wrote:
> 
>> These tests use 4KB *aligned* IOs.
> 
> It seems SSD's commonly now are 8KB paged. [1] [2] At least on OS X
> with a Samsung 830 SSD, I'm finding a meaningful difference between
> alignment on 4K vs a 1M alignment. [3]
> 
> Sequential write and rewrite aren't affected. Sequential Input is
> affected, 5.6% improvement by 8K aligning. Random Seeks see an 87%
> improvement with 1M alignment. I haven't retested to see if an 8K
> alignment produces as good a result as a 1M alignment. I haven't
> tested the full effect of Bonnie++ chunk size which is 8KB by
> default; but in all tests so far there's no meaningful difference
> between a chunk size of 4KB and 8KB.
> 
> It's kind of annoying that SSD manufacturers aren't reporting a
> "physical sector" mapped to the SSD page size; similar to how 512e AF
> HDDs report 512 byte logical, 4096 byte physical sectors. The
> implication of an SSD reporting a 512 byte physical sector is that
> alignment doesn't matter. I think it might matter.

So assuming I don't mind wasting a few MB per disk (I was leaving empty
space at the end of the partition anyway), what would I need to instruct
fdisk and/or md to do to get the alignment right?

Current partition/disk is as follows:
fdisk -l /dev/sdc
Disk /dev/sdc: 480 GB, 480101368320 bytes
255 heads, 63 sectors/track, 58369 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/sdc1               1       58000   465884968   fd  Lnx RAID auto

fdisk -ul /dev/sdc:
Disk /dev/sdc: 480 GB, 480101368320 bytes
255 heads, 63 sectors/track, 58369 cylinders, total 937697985 sectors
Units = sectors of 1 * 512 = 512 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/sdc1              63   931769999   465884968   fd  Lnx RAID auto

Thanks,
Adam

-- 
Adam Goryachev
Website Managers
www.websitemanagers.com.au

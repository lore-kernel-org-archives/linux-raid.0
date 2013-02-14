From: Chris Murphy <lists@colorremedies.com>
Subject: Re: RAID performance
Date: Thu, 14 Feb 2013 15:42:37 -0700
Message-ID: <9ABA2459-DB04-40CA-996E-D02FEE43291B@colorremedies.com>
References: <51134E43.7090508@websitemanagers.com.au> <CAKHEz2YLpyyqo-3XX=pX+D49QP1Y0DNaKcBN=9tPQDjmHAPfdw@mail.gmail.com> <51137FB8.6060003@websitemanagers.com.au> <CAKHEz2ZyG5xQC78GykbWOfk9EF=r7jcSe_01P=bH7NuJuFBEvA@mail.gmail.com> <5113A2D6.20104@websitemanagers.com.au> <CAKHEz2YgiQiknBXju9a=PR3zV1Hb7ux8yBZWywiTi=BXFm20GA@mail.gmail.com> <51150475.2020803@websitemanagers.com.au> <51157141.90205@hardwarefreak.com>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51157141.90205@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org list" <linux-raid@vger.kernel.org>
Cc: Adam Goryachev <mailinglists@websitemanagers.com.au>, "stan@hardwarefreak.com Hoeppner" <stan@hardwarefreak.com>
List-Id: linux-raid.ids

(digging back through some things now that the higher priority tasks appear covered)


On Feb 8, 2013, at 2:42 PM, Stan Hoeppner <stan@hardwarefreak.com> wrote:

> These tests use 4KB *aligned* IOs.

It seems SSD's commonly now are 8KB paged. [1] [2] At least on OS X with a Samsung 830 SSD, I'm finding a meaningful difference between alignment on 4K vs a 1M alignment. [3] 

Sequential write and rewrite aren't affected. Sequential Input is affected, 5.6% improvement by 8K aligning. Random Seeks see an 87% improvement with 1M alignment. I haven't retested to see if an 8K alignment produces as good a result as a 1M alignment. I haven't tested the full effect of Bonnie++ chunk size which is 8KB by default; but in all tests so far there's no meaningful difference between a chunk size of 4KB and 8KB.

It's kindof annoying that SSD manufacturers aren't reporting a "physical sector" mapped to the SSD page size; similar to how 512e AF HDDs report 512 byte logical, 4096 byte physical sectors. The implication of an SSD reporting a 512 byte physical sector is that alignment doesn't matter. I think it might matter.


> If you've partitioned the SSDs, and your partition boundaries fall in
> the middle of erase blocks instead of perfectly between them, then your
> IOs will be unaligned, and performance will suffer.

There doesn't appear to be a way to know what LBA's mark such a boundary. [3] There also is inconsistent understanding of the erase block size, I see 128KB to 2MB erase block sizes published in media, but nothing from manufacturers. So I don't know how we'd know this.

Also, everything I've read indicates that the LBA's in an erase block are not sequential. Only pages have sequential LBA's. LBA 0-7 could be a page on dye 4, while LBA 8-15 could be on dye 2. The firmware manages the relationship between LBAs and physical pages; similar to how HDD firmware will remap an LBA to a different physical sector in case of bad sectors; except in this case it's SOP to manage wear leveling and the fact a static mapping can likely mean mapping to physical pages that aren't yet erased (garbage collected). Writes would be significantly negatively impacted by this.

Anyway, I'm skeptical we have sufficient knowledge beyond 4K or 8K alignment. At least on linux, fortunately, the now common default of LBA 2048 is of course aligned 0.5K through 1M. But it seems the LBA 40 set by Apple might not be a good idea.



[1]  http://arstechnica.com/information-technology/2012/06/inside-the-ssd-revolution-how-solid-state-disks-really-work/3/
[2]  http://www.anandtech.com/show/4244/intel-ssd-320-review/2

[3]  By that I mean a partition that starts on LBA 40 vs an LBA of 2048. OS X's Disk Utility defaults to using GPT partition scheme with partition 1 starting at LBA 40. Results are repeatable by setting to an LBA that is divisible by 8 sectors, but not divisible by 16; compared to an LBA that's divisible by 2048 sectors. (Sectors defined as a 512 byte sector.)

[4]  "Over time SSDs can get into a fairly fragmented state, with pages distributed randomly all over the LBA range."
http://www.anandtech.com/show/6328/samsung-ssd-840-pro-256gb-review/6



Chris Murphy


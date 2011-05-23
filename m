From: David Brown <david@westcontrol.com>
Subject: Re: HBA Adaptor advice
Date: Mon, 23 May 2011 13:35:58 +0200
Message-ID: <irdgqh$47n$1@dough.gmane.org>
References: <4DD50C89.8060006@wildgooses.com>	<20110520020853.GC4759@bitfolk.com>	<4DD61948.8050302@wildgooses.com>	<4DD6409F.9070904@hardwarefreak.com>	<4DD79F4E.7000509@wildgooses.com>	<4DD8D1A7.1090803@hardwarefreak.com>	<4DD8E0D3.1030905@fnarfbargle.com>	<4DD9633E.5000101@hardwarefreak.com>	<4DD99A16.5010108@fnarfbargle.com> <20110523100939.0c019ea2@natsu> <4DD9F6B2.4070708@fnarfbargle.com> <4DDA3A00.8010904@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DDA3A00.8010904@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 23/05/2011 12:42, Stan Hoeppner wrote:
> On 5/23/2011 12:54 AM, Brad Campbell wrote:
>
>> Most sane operating systems use cluster sizes of 4k or larger and have
>> done for years, so I really don't see what all the fuss is about.
>>
>> Peoples inability to properly align the data on their disks can be read
>> either as a failing in the technology (the partitioning applications
>> have not caught up yet) or simply a lack of understanding on how to
>> apply the technology.
>>
>> Don't blame the drive manufacturers, this should have happened _years_ ago.
>
> I don't think anyone has an issue w/native 4KB sectors and operating
> system support for it.  That would have been the big win.  What folks
> have issue with is the hybrid 512/4096 drives which has created the
> alignment offset problems.
>
> The industry (BIOS/firmware), commercial and FOSS OSes, should have
> worked together to migrate directly to 4KB native sectors.  I don't know
> why this didn't happen, usual suspects I guess.  It seems, from my
> limited POV, that the Linux partition tool people and kernel folks
> simply don't care at this point.
>

The problem is Windows XP - neither more nor less.  XP only supports 512 
byte sectors, and the installed base is so large that manufacturers 
can't ignore it.  Linux has been happy with 4K sectors for many years - 
the problem only came when WD produced disks that had 4K sectors but 
claimed to be 512, so that they could work with XP.

The worst case is hybrid disks that offset the sector number, so that 
512-byte "sector" number 63 is at the beginning of a 4K native sector. 
The idea is that these will be fast with XP and other systems that have 
the first partition starting at sector 63 - but it screws up everything 
else.

> I've not paid recent attention.  Have fdisk, cfdisk, parted, etc, all
> come up to speed now, and automatically handle offsets correctly for
> hybrid sector size disks?
>

Modern versions should automatically align partitions appropriately. 
Typically you use 1 MB boundaries - that works well with all sorts of 
disks (SSDs prefer alignment of perhaps 64K or 128K for erase blocks), 
and should work well for future disks.



From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: HBA Adaptor advice
Date: Mon, 23 May 2011 05:42:08 -0500
Message-ID: <4DDA3A00.8010904@hardwarefreak.com>
References: <4DD50C89.8060006@wildgooses.com>	<20110520020853.GC4759@bitfolk.com>	<4DD61948.8050302@wildgooses.com>	<4DD6409F.9070904@hardwarefreak.com>	<4DD79F4E.7000509@wildgooses.com>	<4DD8D1A7.1090803@hardwarefreak.com>	<4DD8E0D3.1030905@fnarfbargle.com>	<4DD9633E.5000101@hardwarefreak.com>	<4DD99A16.5010108@fnarfbargle.com> <20110523100939.0c019ea2@natsu> <4DD9F6B2.4070708@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DD9F6B2.4070708@fnarfbargle.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <lists2009@fnarfbargle.com>
Cc: Roman Mamedov <rm@romanrm.ru>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 5/23/2011 12:54 AM, Brad Campbell wrote:

> Most sane operating systems use cluster sizes of 4k or larger and have
> done for years, so I really don't see what all the fuss is about.
> 
> Peoples inability to properly align the data on their disks can be read
> either as a failing in the technology (the partitioning applications
> have not caught up yet) or simply a lack of understanding on how to
> apply the technology.
> 
> Don't blame the drive manufacturers, this should have happened _years_ ago.

I don't think anyone has an issue w/native 4KB sectors and operating
system support for it.  That would have been the big win.  What folks
have issue with is the hybrid 512/4096 drives which has created the
alignment offset problems.

The industry (BIOS/firmware), commercial and FOSS OSes, should have
worked together to migrate directly to 4KB native sectors.  I don't know
why this didn't happen, usual suspects I guess.  It seems, from my
limited POV, that the Linux partition tool people and kernel folks
simply don't care at this point.

I've not paid recent attention.  Have fdisk, cfdisk, parted, etc, all
come up to speed now, and automatically handle offsets correctly for
hybrid sector size disks?

-- 
Stan

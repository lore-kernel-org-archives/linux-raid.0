From: Peter Daum <gator_ml@yahoo.de>
Subject: Re: SuSE 9.2 and 3ware 8506 card
Date: Tue, 31 Jan 2006 08:38:55 +0100
Message-ID: <drn46f$tor$1@sea.gmane.org>
References: <5.1.0.14.2.20060130164019.0ce71eb8@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5.1.0.14.2.20060130164019.0ce71eb8@localhost>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

tw_clin is the (binary only) command line tool for maintaining 3ware
controllers. All you can do with the web frontend can be done this
way, too.

Performance of the 3ware 8506 is pretty reasonable (I got a data rate
of ~ 80 MB/s with RAID 10 , 55-60 with RAID 1 ) and about the same
for reading and writing.

Unfortunately, after my experiences (see above), i have some serious
concerns regarding data integrity, though ...

Regards,
                   Peter Daum


Tom Peters wrote:
> 
> Hi, brand new newbie (is that redundant?) here, who soon to be the proud 
> owner of a 3ware 8506-4 RAID card, on its way in the mail. I'm running 
> an old P3 on SuSE 9.2 and would like to know what to read to get up to 
> speed on setting this card up and maintaining it once I do. I'm pretty 
> new to linux and get a lot of advice that is pitched just slightly above 
> my level of understanding, so please go slow.
> 
> I'm currently using a Compaq SmartArray 3200 with 8 drives and I've 
> about given up getting any kind of reasonable performance out of it. 
> That, plus the outrageous cost of SCSI drives, is the reason for the 
> switch to SATA. I can borrow a pair of 300 GB drives for a while to 
> prove the concept (the 3ware card wasn't that pricey) and if I can get 
> it to work reasonably well, buy some drives. I think there's some voodoo 
> in the BIOS of a real Compaq server that makes it work properly; for me 
> it's a dog and writes unbelievably slow.
> 
> I've been reading this group for a few weeks and hear some hints and 
> intimations about things I should probably learn about. For example, 
> someone just mentioned tw_cli maint verify, is that a 3ware thing or a 
> ext3 thing? And the fact that there is a 3ware knowledgebase (e.g. 
> http://www.3ware.com/KB/article.aspx?id=13247 should help.
> 
> So what else do I need to know?
> 
> -T
> 
> 
> 
> 
> 
> 
> [Philosophy] There is nothing that somebody, somewhere, will not
> consider immoral. --Jan.Six@uku.fi


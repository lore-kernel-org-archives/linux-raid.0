From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Recovering from an URE on a RAID5 rebuild/resize
Date: Fri, 25 Jan 2013 13:43:42 -0700
Message-ID: <8845EDB3-0DA1-4EBC-842F-6DAF73891A8D@colorremedies.com>
References: <20130125171459.5f855c92@natsu> <B744BEEF-E703-439A-AD82-94CCFE13A795@colorremedies.com>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <B744BEEF-E703-439A-AD82-94CCFE13A795@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Jan 25, 2013, at 1:28 PM, Chris Murphy <lists@colorremedies.com> wrote:
> 
> In a way you'd be better off just blowing away that whole stripe

http://smartmontools.sourceforge.net/badblockhowto.html

So if you do a smartctl -t long on the affected drive, it will stop the test at the first bad sector and report the LBA. If you write zeros to that LBA only, the drive firmware will "fix" the problem, but now you have zeros for that sector.

Note how this document says part of the data in the file will be overwritten with zeros. Well, this is not a file, it's part of an md chunk, which is part of a stripe, then it's a file system, then it's a file. So by zeroing one sector, you've got ambiguous data in the whole stripe.

But, even if you have a totally wrong reconstruction on a whole stripe, at least the rest of the rebuild has a chance to proceed without further URE. So then it's an open question what was affected. If it's a movie, maybe you lose 5 seconds of video or sound, depending on how it's encoded. Depending the player's tolerances, maybe it crashes. Who knows.

Chris Murphy
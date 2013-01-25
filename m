From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Recovering from an URE on a RAID5 rebuild/resize
Date: Fri, 25 Jan 2013 13:50:38 -0700
Message-ID: <0D5BB6C7-6167-410F-B531-2ADD8AFA4BC4@colorremedies.com>
References: <20130125171459.5f855c92@natsu> <B744BEEF-E703-439A-AD82-94CCFE13A795@colorremedies.com> <8845EDB3-0DA1-4EBC-842F-6DAF73891A8D@colorremedies.com>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8845EDB3-0DA1-4EBC-842F-6DAF73891A8D@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Jan 25, 2013, at 1:43 PM, Chris Murphy <lists@colorremedies.com> wrote:

> But, even if you have a totally wrong reconstruction on a whole stripe, at least the rest of the rebuild has a chance to proceed without further URE. So then it's an open question what was affected. If it's a movie, maybe you lose 5 seconds of video or sound, depending on how it's encoded. Depending the player's tolerances, maybe it crashes. Who knows.

And if it's file system, it may or may not be repairable with an fsck. So another unknown. Which means you may need to backup the whole thing (if you even can, which is uncertain if it's a bad file system corruption now); or trash it.

So my tentative conclusion is that if the data is valuable enough to go to this much effort to raise an array basically from the dead, it's worth backing up the data, and just starting it all from scratch and restoring it. If the data is important enough to be available in case of a URE during rebuild, then it needs to be a RAID6 or RAID10.

Chris Murphy


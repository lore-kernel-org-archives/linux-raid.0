From: Neil Brown <neilb@suse.de>
Subject: Re: Expanding RAID array?
Date: Tue, 17 Jan 2006 09:37:24 +1100
Message-ID: <17356.8228.325002.652805@cse.unsw.edu.au>
References: <1137424449.3953.38.camel@kenny>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from John Rowe on Monday January 16
Sender: linux-raid-owner@vger.kernel.org
To: John Rowe <rowe@excc.ex.ac.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday January 16, rowe@excc.ex.ac.uk wrote:
> I have a 5-disk RAID5 array. Is it possible to add disks to increase the
> array size and/or convert it to RAID6? (Indeed, what is the status of
> RAID6?)

- add disks to increase size of raid5
    Possible offline with raidreconfig
    Possible online with alpha-quality patches that I am
      working on today. Will publish for experimentation/testing
      later this week.  Hopefully stable by late Feb.

- add disks to convert to raid6.
    I don't think this is possible, but you should check the latest
    raid reconfig.
    Might be supported online with a limited raid6 in which the Q
    syndrome (second 'parity' block) isn't rotated among disks.

- status of RAID6
    I believe it is as stable/reliable as raid5.

NeilBrown

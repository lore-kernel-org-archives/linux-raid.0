From: NeilBrown <neilb@suse.de>
Subject: Re: RAID5 won't mount after reducing disks from 8 to 6
Date: Thu, 17 Feb 2011 12:42:14 +1100
Message-ID: <20110217124214.00ad25dd@notabene.brown>
References: <C2D86BF5-AECE-49B3-B139-1CD6375DCFC9@mac.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <C2D86BF5-AECE-49B3-B139-1CD6375DCFC9@mac.com>
Sender: linux-raid-owner@vger.kernel.org
To: Matt Tehonica <matt.tehonica@mac.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 16 Feb 2011 19:24:41 -0500 Matt Tehonica <matt.tehonica@mac.com>
wrote:

> Hi all,
> 
> I converted my RAID5 from 8 disks to 6 disks using "mdadm --grow /dev/md0 --array-size" and then "mdadm --grow /dev/md0 --raid-devices=6" and after rebooting, it won't mount.  It has been running fine for about a year.  File system is XFS.  Here is some info on it....

.... uhmm... you did resize the filesystem to be smaller before you resized
the array to be smaller ... didn't you?

Because if you didn't you have probably just lost 1/3 of your data.

That is the whole point of having to set the array-size first.  You then make
sure your data is still safe before performing the irreversible reshape.

If you did reshape the XFS filesystem first, then something else must be
wrong.

NeilBrown



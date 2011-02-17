From: Matt Tehonica <matt.tehonica@mac.com>
Subject: Re: RAID5 won't mount after reducing disks from 8 to 6
Date: Wed, 16 Feb 2011 20:47:08 -0500
Message-ID: <00E3AF11-6D18-4C5D-A165-56C86823A6D2@mac.com>
References: <C2D86BF5-AECE-49B3-B139-1CD6375DCFC9@mac.com>
 <20110217124214.00ad25dd@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <20110217124214.00ad25dd@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

To be honest, I couldn't find good directions on how exactly to resize an array to be smaller so I put some bits and pieces together to do it.  Guess I didn't understand everything beforehand because I didn't read anything about resizing the file system.  I thought setting the "array-size" would take care of moving data before rebuilding onto the 6 disks.

Since I haven't resized the XFS filesystem, any recommendations on what to do next?  Think it's possible to recover any of the data?  For what it's worth, I haven't done anything to the 2 disks that I was going to remove.

Thanks for the help.


On Feb 16, 2011, at 8:42 PM, NeilBrown wrote:

> On Wed, 16 Feb 2011 19:24:41 -0500 Matt Tehonica <matt.tehonica@mac.com>
> wrote:
> 
>> Hi all,
>> 
>> I converted my RAID5 from 8 disks to 6 disks using "mdadm --grow /dev/md0 --array-size" and then "mdadm --grow /dev/md0 --raid-devices=6" and after rebooting, it won't mount.  It has been running fine for about a year.  File system is XFS.  Here is some info on it....
> 
> .... uhmm... you did resize the filesystem to be smaller before you resized
> the array to be smaller ... didn't you?
> 
> Because if you didn't you have probably just lost 1/3 of your data.
> 
> That is the whole point of having to set the array-size first.  You then make
> sure your data is still safe before performing the irreversible reshape.
> 
> If you did reshape the XFS filesystem first, then something else must be
> wrong.
> 
> NeilBrown
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


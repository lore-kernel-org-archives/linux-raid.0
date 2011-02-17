From: Matt Tehonica <matt.tehonica@mac.com>
Subject: Re: RAID5 won't mount after reducing disks from 8 to 6
Date: Wed, 16 Feb 2011 20:39:00 -0500
Message-ID: <49F0C863-F2E0-46FD-883C-D4D458CA4A4E@mac.com>
References: <C2D86BF5-AECE-49B3-B139-1CD6375DCFC9@mac.com>
 <4D5C7A33.90007@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <4D5C7A33.90007@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks for the response!  All I did was truncate the array using "mdadm --grow /dev/md0 --array-size" and then resize the array using "mdadm --grow /dev/md0 --raid-devices=6" so I guess I didn't resize the XFS FS first.  Is that something I can do now or am I screwed?

On Feb 16, 2011, at 8:30 PM, Phil Turmel wrote:

> On 02/16/2011 07:24 PM, Matt Tehonica wrote:
>> Hi all,
>> 
>> I converted my RAID5 from 8 disks to 6 disks using "mdadm --grow /dev/md0 --array-size" and then "mdadm --grow /dev/md0 --raid-devices=6" and after rebooting, it won't mount.  It has been running fine for about a year.  File system is XFS.  Here is some info on it....
> 
> Did you resize (shrink) the XFS filesystem first?
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


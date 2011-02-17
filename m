From: Joe Landman <joe.landman@gmail.com>
Subject: Re: RAID5 won't mount after reducing disks from 8 to 6
Date: Wed, 16 Feb 2011 22:11:46 -0500
Message-ID: <4D5C91F2.8000200@gmail.com>
References: <C2D86BF5-AECE-49B3-B139-1CD6375DCFC9@mac.com> <20110217124214.00ad25dd@notabene.brown> <00E3AF11-6D18-4C5D-A165-56C86823A6D2@mac.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <00E3AF11-6D18-4C5D-A165-56C86823A6D2@mac.com>
Sender: linux-raid-owner@vger.kernel.org
To: Matt Tehonica <matt.tehonica@mac.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/16/2011 08:47 PM, Matt Tehonica wrote:
> To be honest, I couldn't find good directions on how exactly to
> resize an array to be smaller so I put some bits and pieces together
> to do it.  Guess I didn't understand everything beforehand because I
> didn't read anything about resizing the file system.  I thought
> setting the "array-size" would take care of moving data before
> rebuilding onto the 6 disks.
>
> Since I haven't resized the XFS filesystem, any recommendations on
> what to do next?  Think it's possible to recover any of the data?
> For what it's worth, I haven't done anything to the 2 disks that I
> was going to remove.

XFS isn't shrinkable.  See if

	xfs_check /dev/mdX

tells you anything.  If you have a backup, a restore would be the 
fastest option.  If you don't, and you have no other possible way of 
recovering the data from another source, try

	xfs_repair /dev/mdX

I usually run it with the verbose flag on so I can see what its doing.

I am not sure it will work, or result in recoverable data.

If you need to shrink xfs file systems, in general, it is best to use 
xfsdump/xfsrestore or tar.

> -- To unsubscribe from this list: send the line "unsubscribe
> linux-raid" in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Joe Landman
landman@scalableinformatics.com

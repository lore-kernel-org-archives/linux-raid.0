From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Spares and partitioning huge disks
Date: Mon, 10 Jan 2005 15:09:04 -0500
Message-ID: <200501102009.j0AK9C922554@www.watkins-home.com>
References: <200501101924.57445.maarten@ultratux.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200501101924.57445.maarten@ultratux.net>
Sender: linux-raid-owner@vger.kernel.org
To: 'maarten' <maarten@ultratux.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I know the log files are very annoying, but...

I wonder if all that switching is causing md to void its cache?
It may be a performance problem for md to change the strip cache size so
often.

I use ext3 filesystems.  No problems with performance (that I know of).
I have never tried any others.

Do you think the performance difference of the various filesystems would
affect your PVR?

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of maarten
Sent: Monday, January 10, 2005 1:25 PM
To: linux-raid@vger.kernel.org
Subject: Re: Spares and partitioning huge disks

On Monday 10 January 2005 18:13, Guy wrote:
> In my log files, which go back to Dec 12
>
> I have 4 of these:
> raid5: switching cache buffer size, 4096 --> 1024
>
> And 2 of these:
> raid5: switching cache buffer size, 1024 --> 4096

Heh. Is that all...? :-))

Now THIS is my log:

dozer:/var/log # cat  messages | grep "switching cache buffer size" | wc -l
  55880

So that is why I'm a bit worried.  Usually when my computer tells me
something 
_every_second_ I tend to take it seriously.  But maybe it's just lonely and 
looking for some attention. Heh. ;)

> I found this from Neil:
> "You will probably also see a message in the kernel logs like:
>              raid5: switching cache buffer size, 4096 --> 1024
>
> The raid5 stripe cache must match the request size used by any client.
> It is PAGE_SIZE at start up, but changes whenever is sees a request of a
> difference size.
> Reading from /dev/mdX uses a request size of 1K.
> Most filesystems use a request size of 4k.
>
> So, when you do the 'dd', the cache size changes and you get a small
> performance drop because of this.
> If you make a filesystem on the array and then mount it, it will probably
> switch back to 4k requests and resync should speed up.

Okay.  So with as many switches as I see, it would be likely that something 
either accesses the md device concurrently with the FS, or that the FS does 
this constant switching by itself.  Now my FS is XFS, maybe that filesystem 
has this behaviour ?  Anyone having a raid-5 with XFS on top can confirm 
this ?  I usually use Reiserfs, but it seems that XFS is particularly good /

fast with big files, whereas reiserfs excels with small files, that is why I

use it here.  As far as I know there are no accesses that bypass the FS; no 
Oracle, no cat, no dd.  Only LVM and XFS (but it did this before LVM too).

Maarten

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


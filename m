From: maarten <maarten@ultratux.net>
Subject: Re: Spares and partitioning huge disks
Date: Mon, 10 Jan 2005 19:24:57 +0100
Message-ID: <200501101924.57445.maarten@ultratux.net>
References: <200501101713.j0AHDx922062@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200501101713.j0AHDx922062@www.watkins-home.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

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

So that is why I'm a bit worried.  Usually when my computer tells me something 
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


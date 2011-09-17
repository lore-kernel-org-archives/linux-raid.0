From: David Brown <david.brown@hesbynett.no>
Subject: Re: additional feature for linear
Date: Sat, 17 Sep 2011 17:03:41 +0200
Message-ID: <j52csd$3c2$1@dough.gmane.org>
References: <CAC_HdUr9DHt9uQGj=zJcgGvTknckfhyykDBX11XgX+wgOhHQUg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAC_HdUr9DHt9uQGj=zJcgGvTknckfhyykDBX11XgX+wgOhHQUg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 17/09/11 09:12, Henti Smith wrote:
> Good day,
>
> I have an itch I'm hoping somebody can provide me information with to
> scratch it. Please be patient, I'm not very well versed in  all the
> technical information regarding RAID, so I'm still finding my way
> around.
>
> Lets start with the itch.
>
> I'm looking for a way to take 3 drives and create one pool. This is
> similar to linear mode, but in this case if a drive in the linear mode
> fail the rest of the pool is intact and just the missing files are
> removed from the "device"
>
>  From my reading it looks like linear mode is the most likely
> candidate, but there is no guarantee that the remaining data will be
> accessible.
>
> "If one disk crashes you will most probably lose all your data. You
> can however be lucky to recover some data, since the filesystem will
> just be missing one large consecutive chunk of data"
>
> Would it not be possible to add functions to linear mode to mark this
> missing chunks as "bad blacks" and let the FS deal with it as such
> thereby allowing you to mount the linear device as per normal and
> still access the remaining data ?
>
> Id this is not possible, is there not some other way to implement this ?
>
> I see there is some mails regarding adding additional drives to linear
> as well and that the correct way is to stop the linear array and
> recreate it with additional drives. Is this correct ?
>
> I also see there was work being done on extending the array while
> online. Was this ever done ?
>
> Regards
> Henti

All this would require a filesystem that can cope with suddenly losing 
large numbers of disk blocks.  Most file systems can't - so even if the 
raid layer simply marked the missing chunks as bad, the filesystem would 
die.

What you are asking for here is a filesystem that understands the 
separate disks, and is careful to put individual files and related 
metadata and directories onto individual disks (so that when a disk 
dies, the file is either intact or completely lost), as well as 
duplicating its critical metadata so that it will survive a disk loss. 
All of this is the direct antithesis of raid, which aims to make 
multiple disks look like a single block device.

I believe at the moment, your only answer (other than to re-think your 
requirements) is ZFS.  It may be that btrfs has the features you need - 
they are certainly planned, as far as I know - but you'd have to be sure 
of using a recent kernel and utilities.



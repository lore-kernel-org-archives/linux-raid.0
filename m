From: Neil Brown <neilb@suse.de>
Subject: Re: pata_via with software raid1: "attempt to access beyond end of
 device"
Date: Fri, 20 Jul 2007 12:14:31 +1000
Message-ID: <18080.6791.774446.512592@notabene.brown>
References: <dju2n4-lcf.ln1@tux.abusar.org>
	<18078.57482.951240.250360@notabene.brown>
	<mpm4n4-dr3.ln1@tux.abusar.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Daniel Fraga on Thursday July 19
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday July 19, fragabr@gmail.com wrote:
> On Thu, 19 Jul 2007 13:54:50 +1000
> Neil Brown <neilb@suse.de> wrote:
> 
> > The resierfs filesystem is trying to access beyond the end of the
> > raid1 array.  Maybe some indexing information in the array is
> > corrupted.
> > Did you recreate the array (mdadm --create) after changing to the new
> > drivers?  If so, could you have accidentally made it a little smaller?
> > 
> > Possibly try running fsck and see if it finds anything to fix.
> 
> 	Hi Neil, I recreated the array after changing to libata. I
> checked the whole filesystem with reiserfsck --rebuild-tree, then
> started it again and the problem happens suddenly.
> 
> 	And regarding the size of array, I just added the whole
> partition to the array:
> 
> Filesystem           1K-blocks      Used Available Use% Mounted on
> /dev/md1              77639736  30127524  47512212  39% /
> 
>      Array Size : 77642048 (74.05 GiB 79.51 GB)
>   Used Dev Size : 77642048 (74.05 GiB 79.51 GB)
> 
> 	Can I compare both values (77639736 with 77642048)? If so,
> there is a difference, if not, I don't know.

Filesystems always reserve some space for internal use, so the size
reported by df is always smaller than the total number of block on the
devices.

What does
      od -D -j 65536 -N 4 /dev/md1
show.  This is the size the reiserfs thinks it is using.  Multiply by
4 and you should get 77642048 or maybe a little less.  If you get
more, then reiserfs think the device is bigger than it is.  If don't
then I have no idea what the problem is.

NeilBrown

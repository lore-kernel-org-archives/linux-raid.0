From: Daniel Reurich <daniel@centurion.net.nz>
Subject: Re: When does the raid bitmap actually work.
Date: Tue, 16 Nov 2010 00:25:57 +1300
Message-ID: <1289820357.8451.514.camel@localhost.localdomain>
References: <1288389039.5147.35.camel@localhost.localdomain>
	 <20101115150422.468ecde1@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101115150422.468ecde1@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, 2010-11-15 at 15:04 +1100, Neil Brown wrote:
> On Sat, 30 Oct 2010 10:50:39 +1300
> Daniel Reurich <daniel@centurion.net.nz> wrote:
> 
> > Hi,
> > 
> > I'm wondering why if I fail and remove a drive from an array and then
> > re-add it a couple of minutes later that this forces a full resync even
> > though there is a bitmap setup.  I was lead to believe that when using a
> > bitmap that it would only resync the areas of the array that have been
> > written too in the meantime.  Am I mistaken in how the bitmap works?  Or
> > is simply that I'm running either a too old kernel or version of mdadm?
> > 
> > The particular scenario I'm dealing with is having to drop members out
> > of the array to alter the partition table of each host disk one at a
> > time, and when I re-add the disks I'm having to wait for a full re-sync
> > taking 3 - 4 hours before doing the next members disk.  As a result of
> > the partitioning changes, the device name changes from /dev/sd(X)2
> > to /dev/sd(X)3 but the partition itself remains untouched and in the
> > same location on disk.
> 
> This should work.  I have just performed a simple test myself and it did work.
> I used a slightly newer kernel and mdadm, but I don't recall any recent
> changes which would affect this functionality.

Ok.
> 
> However I must have used a different mechanism to change the partitioning
> that you did, as sdb2 remained as sdb2 (i used cfdisk).

Gdisk actually - I had to change to gpt partition table and add a boot
partition.  (I stole space from the raid1 /dev/md0 /boot partition which
I'd shrunk, and then dropped and re-added each member to that array).  

This was all in order to make grub work properly as between versions it
went from fitting the raid enabled boot image in the embedding space to
not fitting, thus the need for adding gpt + bios boot volume.
 
> The mostly likely explanation is that the partition was changed somehow even
> though you think it wasn't.  
Maybe.  I did change the partition table from msdos to gpt and added a
boot partition at the start of the disk (causing the renumbering).
Anyway I successfully completed the job albeit after waiting for a full
resync after each disc manipulation, so it wasn't critical, just took
ages longer then I had hoped for.

Thanks anyway.

-- 
Daniel Reurich.

Centurion Computer Technology (2005) Ltd
Mobile 021 797 722




From: Neil Brown <neilb@suse.de>
Subject: Re: Zeroing multiple superblocks
Date: Tue, 2 Feb 2010 08:44:31 +1100
Message-ID: <20100202084431.5cb261aa@notabene.brown>
References: <20100122200924.GA29183@psychosis.jim.sh>
	<20100125095221.GV21495@skl-net.de>
	<20100129233111.5c9cc1d0@notabene>
	<4B674611.2030402@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B674611.2030402@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Andre Noll <maan@systemlinux.org>, Jim Paris <jim@jtan.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 01 Feb 2010 16:22:25 -0500
Bill Davidsen <davidsen@tmr.com> wrote:

> Neil Brown wrote:
> > On Mon, 25 Jan 2010 10:52:21 +0100
> > Andre Noll <maan@systemlinux.org> wrote:
> >
> >   
> >> On 15:09, Jim Paris wrote:
> >>
> >>     
> >>> I guess the only way to be fully safe with the current approach is to
> >>> do a zero-superblock over and over until it complains.
> >>>       
> >> mdadm --zero-superblock tries to guess the location of the superblock.
> >> If more than one superblock is found, the one with the latest creation
> >> time is being zeroed. So yes, the method you describe works and I think
> >> it is the most reliable way to remove all superblocks of a device.
> >>
> >> Maybe we could teach mdadm --zero-superblock to honor the --metadata=x
> >> option which would zero-out the region of the device where the
> >> version-x superblock is located.
> >>     
> >
> > Latest mdadm has this feature.
> > And if --metadata= isn't given, it repeatedly trying to find and zero a
> > superblock until no more superblocks can be found.
> >   
> 
> That would be potentially a bad thing, people do run things like RAID1+5 
> and might want to clear on block and save the other, still possibly part 
> of a running array, one. I'm not sure that's a safe default behavior.
> 

The situation you describe would not normally cause any problems.
"mdadm --zero-superblock" only erases metadata that looks like valid
metadata at a valid location.
If you have a disk (sda) inside a RAID5 (md0) inside a RAID1 (md1),
then:
   mdadm --zero-superblock /dev/sda
would only see the metadata for the RAID5 and so would only clear that.
   mdadm --zero-superblock /dev/md0
would only see the metadata for the RAID1 and so would only clear that.
   mdadm --zero-superblock /dev/md1
would not see any metadata.

However, if you used v1.0 metadata for the RAID1, and v1.1 metadata for
the RAID5, then
   mdadm --zero-superblock /dev/sda

would see both and could erase both.
But then 
   mdadm --assemble
would also see both and get equally confused.

Also  if you are erasing the RAID5 metadata from sda, then it won't be
inclued in the RAID5, so it won't be included indirectly in the RAID1, so
remove the RAID1 metadata as well is no loss.

So I really don't think there is a problem here.   However if you can
describe a credible case which will cause a problem, I'd be very happy to
consider it.

Thanks,
NeilBrown

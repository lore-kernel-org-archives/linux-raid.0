From: Frank Blendinger <fb@intoxicatedmind.net>
Subject: Re: Failed RAID-5 with 4 disks
Date: Fri, 16 Sep 2005 21:09:28 +0200
Message-ID: <20050916190928.GJ21856@intoxicatedmind.net>
References: <20050726170329.GA30354@intoxicatedmind.net> <42E6B213.8020108@dtbb.net> <20050916113622.GI21856@intoxicatedmind.net> <432AFA95.3040709@h3c.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <432AFA95.3040709@h3c.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Sep 16, 2005 at 10:02:13AM -0700, Mike Hardy wrote:
> Frank Blendinger wrote:
> > This is what I did so far: I got one of the two bad drives (the one that
> > failed first) replaced with a new one. I copied the other bad drive to
> > the new one with dd. I guess that not everything could be copied
> > alright, I got 10 "Buffer I/O error on device hdg, logical sector
> > ..." and about 35 "end_request: I/O error, hdg, sector ..." error
> > messages in my syslog.
> > 
> > Now I'm stuck re-activating the array with the dd'ed hde and the working
> > hdi and hdk. I tried "mdadm --assemble --scan /dev/md0", which told me
> > "mdadm: /dev/md0 assembled from 2 drives - not enough to start the array."
> 
> Does an mdadm -E on the dd'd /dev/hde show that it has the superblock
> and knows about the array? That would confirm that it has the data and
> is ready to go.

mdadm -E /dev/hde tells me: 
mdadm: No super block found on /dev/hde (Expected magic a92b4efc, got
00000000)


> Given that, you want to do a version of the create/assemble that
> forcibly uses all three drives, even though one of them is out of date
> from the raid set's perspective.
> 
> I believe its possible to issue a create line that has a 'missing' entry
> for the drive missing, but order is important. Luckily since one drive
> is missing, md won't resync or anything so you should get multiple tries.
> 
> Something like 'mdadm --create --force -level 5 -n 4 /dev/md0 /dev/hda
> /dev/hdb /dev/hde missing' is what you're looking for.
> 
> Obviously I don't know what your disk names are, so put the correct ones
> in there, not the ones I used. If you don't get a valid raid set from
> that, you could try moving the order around.

OK, sounds good. I tried this:

$ mdadm --create --force --level 5 -n 4 /dev/md0 /dev/hdi /dev/hdk /dev/hde missing
mdadm: /dev/hdi appears to be part of a raid array:
level=5 devices=4 ctime=Mon Apr 18 21:05:23 2005
mdadm: /dev/hdk appears to contain an ext2fs file system
size=732595200K  mtime=Sun Jul 24 03:08:46 2005
mdadm: /dev/hdk appears to be part of a raid array:
level=5 devices=4 ctime=Mon Apr 18 21:05:23 2005
Continue creating array? 

I'm not quite sure about the output, hdk gets listed twice (once false
as an ext2) and hde (this is the dd'ed disk) not at all.
Should i continue here?


> Each time you do that, you'll be creating a brand new raid set with new
> superblocks, but the layout will hopefully match, and it won't update
> the data because a drive is missing. After the raid is created the right
> way, you should find your data.
> 
> Then you can hot-add a new drive to the array, to get your redundancy
> back. I'd definitely use smartctl -t long on /dev/hdg to find the blocks
> that are bad, and use the BadBlockHowTo (google for that) so you can
> clear the bad blocks.

Of course I don't want the second broken hard drive as spare. I just
used it to dd its content to the new disk. I am going to get a new drive
for the second failed one once I got the array back up and running
(without redundancy).

Should a check for bad blocks on hdg and then repeat the dd to the new
disk?

 
> Alternatively you could forcibly assemble the array as it was with
> Neil's new faulty-read-correction patch, and the blocks will probably
> get auto-cleared.

I am still using mdadm 1.9.0 (the package that came with Debian sarge).
Would you suggest me to manually upgrade to a 2.0 version?

 
> > I then tried hot-adding hde with "mdadm --add /dev/hde [--force] /dev/md0"
> > but that only got me "mdadm: /dev/hde does not appear to be an md
> > device".
> 
> You got the array and the drive in the wrong positions here, thus the
> error message, and you can't hot-add to an array that isn't started.
> hot-add is to add redundancy to an array that is already running - for
> instance after a drive has failed you hot-remove it, then after you've
> cleared bad blocks, you hot-add it.

I see, I completely misunderstood the manpage there.


Greets,
Frank

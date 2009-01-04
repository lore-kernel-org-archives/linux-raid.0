From: "Jon Nelson" <jnelson-linux-raid@jamponi.net>
Subject: Re: Raid 5 --grow to fewer, larger drives
Date: Sat, 3 Jan 2009 18:32:39 -0600
Message-ID: <cccedfc60901031632y609b3640g163d234f7e91198d@mail.gmail.com>
References: <de6d3ea90901031521va35b7b5uf3050995561592c0@mail.gmail.com>
	 <de6d3ea90901031527x4af0dfcfm28f2d8890698a931@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <de6d3ea90901031527x4af0dfcfm28f2d8890698a931@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Rippy <jrippy@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

If you are using LVM on top of the raid (the raid is the only PV -
physical volume - backing the volume group) then it's much easier.

Create a *new* array of your 3x 1TB drives (let's call it md99)
Identify the raid is a new physical volume:

pvcreate /dev/md99

Add the array to the volume group:

vgextend YourVolumeGroup /dev/md99

Now, disable allocation on the old array:

pvchange --allocatable n /dev/oldMD

Use pvmove to move all extents from the old pv to the new one:

pvmove /dev/oldMD

When that is done, you can vgreduce the volume group which removes the
old array, and then you can do whatever you want with the old array.

This is how I have upgraded arrays for the past few years or more.


On Sat, Jan 3, 2009 at 5:27 PM, Jeff Rippy <jrippy@gmail.com> wrote:
> I too am looking at this.  My current setup is 4x 500GB drives and I
> want to move to 3x  >=1TB drives.
> My usable space should increase from 1.5TB to >= 2TB with this move if possible.
>
> I'm fairly new to linux-raid in general but I know you can replace
> drives with bigger ones.  You just can't use their space until all
> drives in the array are of that size.  So I'm thinking of replacing 3
> of the 500's with the 1 TBs.  Then fail and remove the 4th drive
> (assuming enough free space) and somehow forcing a reshape on the
> remaining 3 drives.  Not sure if that is possible but I can't imagine
> why it wouldn't be.  After the resync, finally grow to the new size
> and be done.
>
> Can someone tell me if this is even possible?  I saw the one reply in
> Nov. to Alex's email but I don't have another machine to swap the
> disks too.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Jon

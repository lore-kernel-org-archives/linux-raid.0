From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Fwd: Raid 5 --grow to fewer, larger drives
Date: Sun, 04 Jan 2009 01:34:14 +0000
Message-ID: <49601216.4090203@anonymous.org.uk>
References: <de6d3ea90901031521va35b7b5uf3050995561592c0@mail.gmail.com> <de6d3ea90901031527x4af0dfcfm28f2d8890698a931@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <de6d3ea90901031527x4af0dfcfm28f2d8890698a931@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Rippy <jrippy@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 03/01/2009 23:27, Jeff Rippy wrote:
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

No, it'll only work if you move to 4x1TB, but even then it would be 
risky; you wouldn't have any redundancy during 3 rebuilds and a reshape, 
and if one drive goes bad you'll lose your data.

If you can physically fit the 3 new drives, just build the new array and 
copy over instead. Jon Nelson's suggestion sounds to me like a good one 
to make the copying easy if you're using LVM.

If you can physically fit 2 more drives, you can either:
a) build the new array with a drive missing, copy the data, then pull 
the old array and resync with the third new drive, or
b) go read-only, yank one of the old drives, build the new array and 
copy over

If you can physically fit 1 more drive, you can do both of the above 
simultaneously, i.e. go read-only, pull one of the old drives, build the 
new array with a disc missing, copy the data, then resync with the third 
new disc.

If you can't fit any more drives, err, open the case and hang the drives 
outside the case?

Actually there is a funky thing you can do if you can't fit any more 
drives, as long as your data will fit on just one of the new drives: go 
read-only, pull one of the old drives, install one of the new ones, 
create a 2-disc RAID-5 with a disc missing (! - yes, this works), copy 
the data, pull the rest of the old array, add the second new disc and 
resync the new array onto it, add the third new disc and reshape the 
array onto it.

None of the above methods where I say "go read-only" will work with the 
LVM copy method, but your old array will remain intact so you won't lose 
data, as long as you're being careful about what you're doing.

If you're going to do any of this b*ggering about, you'd be well advised 
to make a backup first, save a copy of your mdadm.conf and various 
outputs from mdadm --examine, perhaps even on paper(!), and try to keep 
track of what drives came from where, in case it all goes horribly wrong.

Cheers,

John.

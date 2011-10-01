From: Danny Rawlins <monster.romster@gmail.com>
Subject: Re: Safely swapping a disk in a RAID456
Date: Sat, 01 Oct 2011 13:38:37 +1000
Message-ID: <4E868B3D.3090400@gmail.com>
References: <20110930154217.GA11732@albatross.gern.madduck.net> <4E860435.5040902@yuiop.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E860435.5040902@yuiop.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

John Robinson wrote:
> On 30/09/2011 16:42, martin f krafft wrote:
>> Dear list,
>>
>> I would like to swap out a drive in a RAID6 (4 drives), but ideally
>> without letting the RAID degrade. I was thinking that it should be
>> possible to declare the new disc a copy of the old one, let it sync,
>> then remove the old one and let the new one take over, but MD does
>> not seem to support that.
>
> Not yet, but it's in the roadmap as a hot-replace. In the mean time,
> you can do something very similar by hand with almost no lost of
> redundancy, if your RAID456 has a bitmap.
>
>> Next, I thought that I could add the new disc as a spare, grow the
>> array to 5 discs, and somehow shrink it back to 4 again, but of
>> course that does not work either, since 4=E2=86=925 is a reshape, an=
d there
>> seems to be no way to control which disc to remove from the RAID6 on
>> a shrink (making it a spare), without degrading the array in the
>> process.
>
> Doing a shrink while specifying which drive to remove is also on the
> roadmap, I believe. But doing huge reshapes like this are not the way
> forward for a hot-replace.
>
>> Does anyone have any ideas? This should not be so hard=E2=80=A6
>
> I'd be glad to hear of any "real" RAID card that made it easier, or
> even possible.
>
> Something along the lines of:
>
> # briefly remove your disc from the array
> mdadm --manage /dev/md_raid456 --remove /dev/the_disc_i_want_to_remov=
e
> # make a temp raid1 with only the one disc, using build so metadata i=
s
> # only in RAM and nothing is written to the disc
> mdadm --build /dev/md_temp_raid1 --level 1
> /dev/the_disc_i_want_to_remove missing
> # now re-add something which looks identical to your original disc,
> # but is actually a single-sided mirror, back into the array
> # the above can all be done very quickly so your raid456 only runs
> # without a drive for seconds
> mdadm --manage /dev/md_raid456 --re-add /dev/md_temp_raid1
> # now get md to make a mirror (copy) to the new disc
> mdadm --manage /dev/md_temp_raid1 --add /dev/the_new_disc
> # wait for it to finish, or just wait for it yourself
> mdadm --wait /dev/md_temp_raid1
> # and switch back again: remove the temporary raid1
> mdadm --manage /dev/md_raid456 --remove /dev/md_temp_raid1
> # stop it so the new disc becomes available again
> mdadm --stop /dev/md_temp_raid1
> # and put the new disc which is now a complete copy of the old one
> # back in to the array
> mdadm --manage /dev/md_raid456 --re-add /dev/the_new_disc
> # and you're done
>
> This is all fine if your old disc has no faulty sectors. If it does
> have, you need more help from someone much more clued-up than me
> (because it is already possible to do partial rebuilds by manipulatin=
g
> /sys), or mdadm's roadmap feature of hot-replace, which will do the
> above and also automatically perform partial rebuilds from the rest o=
f
> the array when the old disc has bad sectors.
>
> Hope this helps.
>
> Cheers,
>
> John.
>
=46or bad disks I use GNU ddrescue in two pass like this.

ddrescue -n -f /dev/sda /dev/sdb ddrescue.log
ddrescue -d -f -r 10 /dev/sda /dev/sdb ddrescue.log

I recently found partclone can make a domain-log for ddrescue to only
rescue from used file system blocks (but not applicable to this situati=
on)

I should get in touch with the GNU ddrescue author to see if (s)he is
willing to restructure the ddrescue binary as a library and the ddresuc=
e
front end then tings like lvm2 and mdadm could put the ddrescue library
to use in recovering as much as they can from said faulty disk before
discarding it.

PS great idea on adding a bitmap to the raid6 removing disk making a
raid1with external metadata then syncing both raid1 disks then removing
the raid1 from the raid6 and then breaking the raid1 to put the new dis=
k
back into the raid1 group. Seems a little over kill for raid6 but that
would make more sense for raid5, though taking less chances on raid6
hitting some sleeping bad blocks (which i like to call them landmines)
is a good thing.

Regards,
Danny Rawlins
Romster @ freenode
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

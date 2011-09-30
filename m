From: John Robinson <john.robinson@yuiop.co.uk>
Subject: Re: Safely swapping a disk in a RAID456
Date: Fri, 30 Sep 2011 19:02:29 +0100
Message-ID: <4E860435.5040902@yuiop.co.uk>
References: <20110930154217.GA11732@albatross.gern.madduck.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110930154217.GA11732@albatross.gern.madduck.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 30/09/2011 16:42, martin f krafft wrote:
> Dear list,
>
> I would like to swap out a drive in a RAID6 (4 drives), but ideally
> without letting the RAID degrade. I was thinking that it should be
> possible to declare the new disc a copy of the old one, let it sync,
> then remove the old one and let the new one take over, but MD does
> not seem to support that.

Not yet, but it's in the roadmap as a hot-replace. In the mean time, yo=
u=20
can do something very similar by hand with almost no lost of redundancy=
,=20
if your RAID456 has a bitmap.

> Next, I thought that I could add the new disc as a spare, grow the
> array to 5 discs, and somehow shrink it back to 4 again, but of
> course that does not work either, since 4=E2=86=925 is a reshape, and=
 there
> seems to be no way to control which disc to remove from the RAID6 on
> a shrink (making it a spare), without degrading the array in the
> process.

Doing a shrink while specifying which drive to remove is also on the=20
roadmap, I believe. But doing huge reshapes like this are not the way=20
forward for a hot-replace.

> Does anyone have any ideas? This should not be so hard=E2=80=A6

I'd be glad to hear of any "real" RAID card that made it easier, or eve=
n=20
possible.

Something along the lines of:

# briefly remove your disc from the array
mdadm --manage /dev/md_raid456 --remove /dev/the_disc_i_want_to_remove
# make a temp raid1 with only the one disc, using build so metadata is
# only in RAM and nothing is written to the disc
mdadm --build /dev/md_temp_raid1 --level 1=20
/dev/the_disc_i_want_to_remove missing
# now re-add something which looks identical to your original disc,
# but is actually a single-sided mirror, back into the array
# the above can all be done very quickly so your raid456 only runs
# without a drive for seconds
mdadm --manage /dev/md_raid456 --re-add /dev/md_temp_raid1
# now get md to make a mirror (copy) to the new disc
mdadm --manage /dev/md_temp_raid1 --add /dev/the_new_disc
# wait for it to finish, or just wait for it yourself
mdadm --wait /dev/md_temp_raid1
# and switch back again: remove the temporary raid1
mdadm --manage /dev/md_raid456 --remove /dev/md_temp_raid1
# stop it so the new disc becomes available again
mdadm --stop /dev/md_temp_raid1
# and put the new disc which is now a complete copy of the old one
# back in to the array
mdadm --manage /dev/md_raid456 --re-add /dev/the_new_disc
# and you're done

This is all fine if your old disc has no faulty sectors. If it does=20
have, you need more help from someone much more clued-up than me=20
(because it is already possible to do partial rebuilds by manipulating=20
/sys), or mdadm's roadmap feature of hot-replace, which will do the=20
above and also automatically perform partial rebuilds from the rest of=20
the array when the old disc has bad sectors.

Hope this helps.

Cheers,

John.

--=20
John Robinson, yuiop IT services
0131 557 9577 / 07771 784 058
46/12 Broughton Road, Edinburgh EH7 4EE
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

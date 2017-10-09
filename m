From: NeilBrown <neilb@suse.com>
Subject: Re: mdadm: Patch to restrict --size when shrinking unless forced
Date: Mon, 09 Oct 2017 12:36:53 +1100
Message-ID: <87mv51yudm.fsf@notabene.neil.brown.name>
References: <22997.8664.67459.119616@quad.stoffel.home> <87a81637lq.fsf@notabene.neil.brown.name> <23002.37193.492253.120639@quad.stoffel.home> <87shetz207.fsf@notabene.neil.brown.name> <23002.52854.478610.499870@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <23002.52854.478610.499870@quad.stoffel.home>
Sender: linux-raid-owner@vger.kernel.org
Cc: John Stoffel <john@stoffel.org>, Eli Ben-Shoshan <eli@benshoshan.com>, Jes.Sorensen@gmail.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 08 2017, John Stoffel wrote:

>>>>>> "NeilBrown" =3D=3D NeilBrown  <neilb@suse.com> writes:
>
> NeilBrown> On Sun, Oct 08 2017, John Stoffel wrote:
>>>>>>>> "NeilBrown" =3D=3D NeilBrown  <neilb@suse.com> writes:
>>>=20
> NeilBrown> On Wed, Oct 04 2017, John Stoffel wrote:
>>>>> Since Eli had such a horrible experience where he shrunk the
>>>>> individual component raid device size, instead of growing the overall
>>>>> raid by adding a device, I came up with this hacky patch to warn you
>>>>> when you are about to shoot yourself in the foot.
>>>>>=20
>>>>> The idea is it will warn you and exit unless you pass in the --force
>>>>> (or -f) switch when using the command.  For example, on a set of loop
>>>>> devices:
>>>>>=20
>>>>> # cat /proc/mdstat
>>>>> Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5]
>>>>> [raid4] [multipath] [faulty]
>>>>> md99 : active raid6 loop4p1[4] loop3p1[3] loop2p1[2] loop1p1[1]
>>>>> loop0p1[0]
>>>>> 606720 blocks super 1.2 level 6, 512k chunk, algorithm 2 [5/5]
>>>>> [UUUUU]
>>>>>=20
>>>>> # ./mdadm --grow /dev/md99 --size 128
>>>>> mdadm: Cannot set device size smaller than current component_size of =
/dev/md99 array.  Use -f to force change.
>>>>>=20
>>>>> # ./mdadm --grow /dev/md99 --size 128 -f
>>>>> mdadm: component size of /dev/md99 has been set to 0K
>>>>>=20
>>>=20
> NeilBrown> I'm not sure I like this.
> NeilBrown> The reason that mdadm will quietly accept a size change like t=
his is
> NeilBrown> that it is trivial to revert - just set the same to a big numb=
er and all
> NeilBrown> your data is still there.
>>>=20
>>> This is wrong, because if you use --grow --size ### with a small
>>> enough number, it destroys the MD raid superblock.
>
> NeilBrown> If that is true, then it is a kernel bug and should be fixed i=
n the kernel.
>
> That's a better solution of course.  I'll see if I can figure this
> out, but my testing will be slower... :-)
>
>>> So again, I think
>>> the --force option is *critical* here.  Or we need to block the size
>>> change from going smaller than the superblock size.  Here's my test,
>>> where I just warn if the size is going to be smaller:
>>>=20
>>> # ./mdadm --grow /dev/md99 --size 128
>>> mdadm: setting raid component device size from 202240 to 128 in array /=
dev/md99,
>>> this may need to be reverted if new size is smaller.
>>> mdadm: component size of /dev/md99 has been set to 0K
>>>=20
>>> # ./mdadm --grow /dev/md99 --size 202240
>>> mdadm: setting raid component device size from 0 to 202240 in array /de=
v/md99,
>>> this may need to be reverted if new size is smaller.
>>> mdadm: Cannot set device size in this type of array.
>>>=20
>>> # mdadm -E /dev/md99
>>> mdadm: No md superblock detected on /dev/md99.
>>>=20
>>> So I think this argues for a much stronger check, and/or the --force
>>> option when shrinking.  I'll re-spin my patch series into two chunks,
>>> one just the message if changing size.  The second to require the
>>> --force option.
>
> NeilBrown> Why don't you like my suggestion that you should need to reduc=
e the
> NeilBrown> --array-size first?
>
> Ok, so assuming at RAID6 with 4 x 100mb loop devices:
>
>   mdadm --create /dev/md99 --name md99 --level 6 -n 4 /dev/loop?p1
>
> Now we have a 200mb visible size array, using 100mb on each disk.  I
> want to shrink them by 50mb each:
>
>   mdadm --grow md## --array-size 100m=20=20
>
> So now the array should be just using the first 50mb on each loop device.
>
>   mdadm --grow md## --size 50m
>
> Then we've shrunk each loop device to 50m.  So since the docs say that
> the --array-size does't change anything, the only way to make a
> --array-size change permanent is using --size ## correct?

Yes.

>
> But doesn't
>
>   mdadm --grow md99 -size 0
>
> imply that we *exapand* the array component sizes, along with the
> --array_size of the array?

Does it?  "mdadm --grow .. --size max" certainly means that.
Maybe "--size 0" has the same effect, but in then "0" is a special case.


>                              When does that change become permanent?

As you say, when you set "--size".

> This is the part of mdadm management that gets wonky in my mind.  We
> make it too difficult for the SysAdmin to know what has to happen
> here.
>
> And looking at the mdadm man page:
>
>        -z, --size=3D Amount (in Kibibytes) of space to use from each
> 		   drive in RAID levels 1/4/5/6.  This must be a multiple of the chunk
> 		   size, and must leave about 128Kb of space at the end of the drive for
> 		   the RAID superblock.  If this is not specified (as it normally is no=
t)
> 		   the smallest drive (or partition) sets the size, though if there is a
> 		   vari=E2=80=90 ance among the drives of greater than 1%, a warning is=
 issued.
>
> This is the possible error we're seeing, since setting a --size of 128
> is *way* too small.  We need at least 128k * num_devices.

Why is this "*way* too small"?? It is too small precisely if there is a
meaningful chunk size, and if the chunk size is > 128k.
num_devices has nothing to do with this.

Where it says "leave 128K as the end of the drive" it means that the
given size should be at least 128K less than that actual size of the
partition/device.


>                                                             So now I
> know what to check in the kernel...  The _about_ is the worrying
> phrase, we should be able to be more precise here, and show how to
> figure this number from the mdadm -E or -D commands.

The 128K is for 0.90 metadata.
The precise number here is "size of device/partition, rounded down to a
multiple of 64K, with 64K then subtracted".
For 1.0, the hard number if like that but with 4K, except that it is
nice to leave extra space for bitmaps etc.
If you ask mdadm to make the --size larger than it can support -
i.e. large enough that there would be no space for the metadata - mdadm
will not let you.

So I don't think there is a need to spell out a precise number.
Anything that works should be acceptable.

NeilBrown


>
> Thanks again for all your work on this Neil, you've been amazing,
> truly!
>
> Thanks,
> John
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlna0rUACgkQOeye3VZi
gbmBWw//a3kFI6LS4SeEqLzOqaot8HqmTUJ2JgTdXpZD+6hSNH/tLhmDLdqcwYhy
JykRKRVLBzt/HBetJOsdVJiRiQYmPaSeqgfpLlb8W/ciG/28WJhY5XK42CRQipVB
BldcogUvZM+y6Uzb6mJ+doVFPg2665VDb91vCvqxh/VJkUJS606SuF6HmHdXHGk5
l8X0eUdSGudiCibC+yGJ3v3do0JKfO6DQbhfgwtv+7l6QemLxojJpR/UnxDK58SO
fnCk5vJ8G1Uo5/MKiaYZCNMIWxm/OVbNZayNQvPIZiOtPmqZOcWTiUndUUCOrOhO
nMMObCHEfdql8bpOmMKe0/SursKXor+q11dBoc110+78w10p+cqR/jzdXLhgJ0rh
rMsskg9Uj5qmW6QcOpFx0BgXkcxTfMJwaZZuBLq7ORUnvQzsFulFc7vqd4pPSikZ
HV3SSsQR3tr7jmc7RGO/4xH+HpwXbpUN0qxYMSFz9KYWogYIf3zCfQ4Tg6oADfPe
96hvs9aP5wFddlKfM6PkYjkogrfzX/Jr5y0dDgVLG28pa96UdBAisk0w+85r7SPm
9wGsDqgseTESWmNrdEhU5lZP+whpD7P0TBkp0T+4CVa4t0eiFW+tY0BS1UXychmy
KvHHXTU7j1jhYP5JA3mHwmgvLlu2tN7+DHhk/nnQfqMwR0EuMAE=
=2GbX
-----END PGP SIGNATURE-----
--=-=-=--

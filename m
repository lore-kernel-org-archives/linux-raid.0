From: NeilBrown <neilb@suse.com>
Subject: Re: Recovering a RAID6 after all disks were disconnected
Date: Fri, 23 Dec 2016 10:25:26 +1100
Message-ID: <87k2arpmvt.fsf@notabene.neil.brown.name>
References: <CAOxFTczhq3Gr4WW=-sMamaYDmAoMFGh7kkanwJzhXe5NBdMHHQ@mail.gmail.com> <22600.7486.444800.536687@quad.stoffel.home> <CAOxFTczn4Su6KwjDGS0S5BrUdirv9Tu_zCeo26iFMvL3378xpw@mail.gmail.com> <22601.44638.79418.124438@quad.stoffel.home> <CAOxFTcwYujHCHeiJiwUc4aA5RpN_9ocoBGfLS1kfgaz=sKSOSQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAOxFTcwYujHCHeiJiwUc4aA5RpN_9ocoBGfLS1kfgaz=sKSOSQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>, John Stoffel <john@stoffel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Fri, Dec 23 2016, Giuseppe Bilotta wrote:

> Hello again,
>
> On Thu, Dec 8, 2016 at 8:02 PM, John Stoffel <john@stoffel.org> wrote:
>>
>> Sorry for not getting back to you sooner, I've been under the weather
>> lately.  And I'm NOT an expert on this, but it's good you've made
>> copies of the disks.
>
> Don't worry about the timing, as you can see I haven't had much time
> to dedicate to the recovery of this RAID either. As you can see, it
> was not that urgent ;-)
>
>
>> Giuseppe> Here it is. Notice that this is the result of -E _after_ the attempted
>> Giuseppe> re-add while the RAID was running, which marked all the disks as
>> Giuseppe> spares:
>>
>> Yeah, this is probably a bad state.  I would suggest you try to just
>> assemble the disks in various orders using your clones:
>>
>>    mdadm -A /dev/md0 /dev/sdc /dev/sdd /dev/sde /dev/sdf
>>
>> And then mix up the order until you get a working array.  You might
>> also want to try assembling using the 'missing' flag for the original
>> disk which dropped out of the array, so that just the three good disks
>> are used.  This might take a while to test all the possible
>> permutations.
>>
>> You might also want to look back in the archives of this mailing
>> list.  Phil Turmel has some great advice and howto guides for this.
>> You can do the test assembles using loop back devices so that you
>> don't write to the originals, or even to the clones.
>
> I've used the instructions on using overlays with dmsetup + sparse
> files on the RAID wiki
> https://raid.wiki.kernel.org/index.php/Recovering_a_damaged_RAID
> to experiment with the recovery (and just to be sure, I set the
> original disks read-only using blockdev; might be worth adding this to
> the wiki).
>
> I also wrote a small script to test all combinations (nothing smart,
> really, simply enumeration of combos, but I'll consider putting it up
> on the wiki as well), and I was actually surprised by the results. To
> test if the RAID was being re-created correctly with each combination,
> I used `file -s` on the RAID, and verified that the results made
> sense. I am surprised to find out that there are multiple combinations
> that make sense (note that the disk names are shifted by one compared
> to previous emails due a machine lockup that required a reboot and
> another disk butting in to a different order):
>
> trying /dev/sdd /dev/sdf /dev/sde /dev/sdg
> /dev/md111: Linux rev 1.0 ext4 filesystem data,
> UUID=0031565c-38dd-4445-a707-f77aef1cbf7e, volume name "oneforall"
> (needs journal recovery) (extents) (large files) (huge files)
>
> trying /dev/sdd /dev/sdf /dev/sdg /dev/sde
> /dev/md111: Linux rev 1.0 ext4 filesystem data,
> UUID=0031565c-38dd-4445-a707-f77aef1cbf7e, volume name "oneforall"
> (needs journal recovery) (extents) (large files) (huge files)
>
> trying /dev/sde /dev/sdf /dev/sdd /dev/sdg
> /dev/md111: Linux rev 1.0 ext4 filesystem data,
> UUID=0031565c-38dd-4445-a707-f77aef1cbf7e, volume name "oneforall"
> (needs journal recovery) (extents) (large files) (huge files)
>
> trying /dev/sde /dev/sdf /dev/sdg /dev/sdd
> /dev/md111: Linux rev 1.0 ext4 filesystem data,
> UUID=0031565c-38dd-4445-a707-f77aef1cbf7e, volume name "oneforall"
> (needs journal recovery) (extents) (large files) (huge files)
>
> trying /dev/sdg /dev/sdf /dev/sde /dev/sdd
> /dev/md111: Linux rev 1.0 ext4 filesystem data,
> UUID=0031565c-38dd-4445-a707-f77aef1cbf7e, volume name "oneforall"
> (needs journal recovery) (extents) (large files) (huge files)
>
> trying /dev/sdg /dev/sdf /dev/sdd /dev/sde
> /dev/md111: Linux rev 1.0 ext4 filesystem data,
> UUID=0031565c-38dd-4445-a707-f77aef1cbf7e, volume name "oneforall"
> (needs journal recovery) (extents) (large files) (huge files)
> :
> So there are six out of 24 combinations that make sense, at least for
> the first block. I know from the pre-fail dmesg that the g-f-e-d order
> should be the correct one, but now I'm left wondering if there is a
> better way to verify this (other than manually sampling files to see
> if they make sense), or if the left-symmetric layout on a RAID6 simply
> allows some of the disk positions to be swapped without loss of data.
>

You script has reported all arrangements with /dev/sdf as the second
device.  Presumably that is where the single block you are reading
resides.

To check if a RAID6 arrangement is credible, you can try the raid6check
program that is include in the mdadm source release.  There is a man
page.
If the order of devices is not correct raid6check will tell you about
it.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlhcYOYACgkQOeye3VZi
gbkTJA/+OpKSz+5S+b1lhs5V4W6Kr9vpo6R8oktp9NGp49jZGvifkcD8DpRwduKK
sKXLWhd9G+BdJtgyahnzLfkMvTAcgdOLj4MFuY/o0883HarhWEy8TDBl21M7gb23
mmljGH3twOxJNYHu7J3Xgh0VPOgVxkBS7aF46OqjzDXW/eZn8o7OS+xt7uRpYD9i
day8G+8b3TFG+lSjBes4BnDV5ieXyzcEzTaPTBNBKgAxnEnx2zJpwojx3egWKPyc
El6DRU/4W7H2tF5Uo0nPE0LQj3zhY7UjdLiG/mEV05JCzbEatGnuan3lA3UBM751
Y6xMFzNdlg0NAJccTfx75Mu3LvnOEB+dHDoUyPeaDp0XL4R8lZG+RvjhKRxSDFdw
rVxzO+qsXsY5f7lPLf+Ho8bqmU8H2Dg7SUFXh1CCoSUuhYGSJqqG/pW17ihL8vJ9
UEADyuqTbs844lIPM/sEByUemAPdm7hsWjx25pbR7GB/OuveCFZyfXI1FsqKex86
0228FD6BfbTM9UP1gvPqAg447JFqncnarxJ1cH7BazUG77gfCiCDGUZ6YfTdnP92
wSrsNjrBQGOWN3Nf/d3kH87nkJJsX0+343ce1jyPBU0rzSoIYHtI04cy/HslOmh7
AhvH9EFy//iVbokvSwx8tw8mVDrhzcE+U+2cd7+/7FQAD68ICc0=
=YZxQ
-----END PGP SIGNATURE-----
--=-=-=--

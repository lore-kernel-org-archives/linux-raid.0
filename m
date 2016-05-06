From: NeilBrown <nfbrown@novell.com>
Subject: Re: problems with lots of arrays
Date: Fri, 06 May 2016 16:43:21 +1000
Message-ID: <87k2j7vg8m.fsf@notabene.neil.brown.name>
References: <CAK9wOaB+Cic3nR5kzB3n=nVpbRtfo8+Qr9j_VNM3hh5tJRw6YA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAK9wOaB+Cic3nR5kzB3n=nVpbRtfo8+Qr9j_VNM3hh5tJRw6YA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Lovell <mike.lovell@endurance.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Fri, May 06 2016, Mike Lovell wrote:

> we have a number of systems that have a large number of software
> arrays running. its in the couple hundred range. we have been using a
> custom built kernel based on 3.4 but are wanting to update to a
> mainline kernel and have been experimenting with 4.4. the systems are
> running recent centos 6 releases but we have been downgrading the
> mdadm version from 3.3.2 in 6.7 to a custom build 3.2.6. we installed
> the downgraded version due to a problem with array numbering. i
> emailed the list a while ago explaining the issue and submitting a
> patch to fix [1]. i never heard anything back and since we had a
> simple fix i didn't follow up on it.
>
> unfortunately, when testing the 3.2.6 mdadm with linux kernel 4.4
> wasn't working. mdadm and the kernel would complain about the devices
> not having a valid v1.2 superblock and not start the array. testing
> with 3.3.2 from the current centos repos worked. i'd like to update
> but we still have the issue with lots of arrays mentioned previously.
>
> i spent some time checking to make sure that my patch rebases against
> master properly (and it does) but during testing i was unable to
> create an array with number larger than /dev/md511 when using the 4.4
> kernel we were testing as well as the 4.2 kernel i had on another test
> box. creating one larger than 511 on a system with a 3.16 kernel
> worked. it looks like something broke between kernel 3.16 and 4.2 that
> limited the number of arrays to 512 (/dev/md0 to /dev/md511). this was
> a problem regardless of mdadm version and i haven't yet done much
> digging into the problem.
>
> there are a couple things that could potentially be done. the easiest,
> would be to just modify find_free_devnm() in mdopen.c from wrapping to
> (1<<20)-1 and instead have it wrap around to (1<<9))-1. this would
> limit mdadm to 512 auto-generated array numbers. i'm guessing this
> would be sufficient for the vast majority of cases and would solve the
> problem i'm facing at work. the next option would be to apply the
> patch in my previous email and then figuring out why the newer
> versions of the kernel don't support more than 512 arrays. this would
> take more work but probably the better long term approach.
>

I know why newer kernels don't seem to support more than 512 array.

Commit: af5628f05db6 ("md: disable probing for md devices 512 and over.")


You can easily use many more md devices by using a newish mdadm and
setting

   CREATE names=yes

in /etc/mdadm.conf

You cannot use names like "md512" because that gets confusing, but any
name that isn't a string of digits is fine.  e.g. create /dev/md/foo
and the array will be named "md_foo" in the kernel rather than "md127".

I guess this qualifies as a regression and regressions are bad.....
But I really wanted to be able to have arrays that didn't get magically
created simply because you open a file in /dev.  That just leads to
races with udev.

The magic number "512" appears three times in the kernel.

                /* find an unused unit number */
                static int next_minor = 512;

and

        blk_register_region(MKDEV(MD_MAJOR, 0), 512, THIS_MODULE,
                            md_probe, NULL, NULL);
and
        blk_unregister_region(MKDEV(MD_MAJOR,0), 512);

A boot parameter which set that to something larger would probably be OK
and would solve your immediate problem.

But if you could transition to using named arrays instead of numbered
arrays - even if that are "/dev/md/X%d", that would be be good I think.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXLD0JAAoJEDnsnt1WYoG5lN8QAJJqW+EGY+O1bU4ldaXRqlpF
FhyykFhOHV6S0kOKm/Hmcg1ZHWkGfAr7yuAIL6hW4140UfU5wchHCsJLTjHCqmrl
EasEEj5OZV+kgWjaHJKjwMuP+Z9S72Y3YwKpaXnhH4KFPi0Y3cH2Gnv0K4oEue2W
l03ox5E6SA4nCqvZKfmv8tIJnLYMy6hGijNeh6Lw2Scd7ii2CpXkxOrMZnRDHqxg
PM5lybjp5D7Ra3nSE6GivKCI2uMNnt2W1TCRWRAc7UbYYRWO8xhr8YT6DRmlrRjV
LrTXc8TQwCrCa+cE4E0+KGWDuB22XJT1b5SYVqHljbq2r0peTyljKKTOQrLR66XF
GuDvSbq+rxtz/YWCDCOF6dJE4A8xgj2B/iGNJAvStv4OieptAggpWQQLytehsX/z
x9gm/1FbsDOaOwp/Qb+Ll1xd2Lwv3wObbpbBfzHKsIvZ37OQe0CGKpMhM85djyxF
gUwH3VUpsHak7R2rlPMdWIwoY7BHOngjkPtvxm/ciSYRynUPLK+JUDhvGJgxxNZi
FdEheddIFhl7Dz6w0PM2n07hnd5ceQLKAFp3ExFIG6yxo/bQhXStWduxX/1lZKAh
qa7VynSVKReUX13tU+QPOdebjXxVGuF6VjSfp4S6G5DXyXR6NAOpuKcMEI5aE0U8
A7kQiERAQAiJJRgdHNr7
=8ViZ
-----END PGP SIGNATURE-----
--=-=-=--

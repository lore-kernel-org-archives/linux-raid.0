From: NeilBrown <neilb@suse.de>
Subject: Re: Can we deprecate ioctl(RAID_VERSION)?
Date: Thu, 06 Apr 2017 08:32:10 +1000
Message-ID: <87h922trit.fsf@notabene.neil.brown.name>
References: <wrfjvaqid9ih.fsf@gmail.com> <wrfjr316d6f5.fsf@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wrfjr316d6f5.fsf@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: jes.sorensen@gmail.com
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Thu, Apr 06 2017, jes.sorensen@gmail.com wrote:

> jes.sorensen@gmail.com writes:
>> Hi Neil,
>>
>> Looking through the code in mdadm, I noticed a number of cases calling
>> ioctl(RAID_VERSION). At first I had it confused with metadata version,
>> but it looks like RAID_VERSION will always return 90000 if it's a valid
>> raid device.
>>
>> In the cases we want to confirm the fd is a valid raid array,
>> ioctl(GET_ARRAY_INFO) should do, or sysfs_read(GET_VERSION).
>>
>> Am I missing something obvious here, or do you see any reason for
>> leaving this around?
>
> Sorry the above is wrong, it will always return 900, not 90000. Some of
> the code that stood out is in util.c:
>
> int md_get_version(int fd)
> {
>         struct stat stb;
>         mdu_version_t vers;
>
>         if (fstat(fd, &stb)<0)
>                 return -1;
>         if ((S_IFMT&stb.st_mode) != S_IFBLK)
>                 return -1;
>
>         if (ioctl(fd, RAID_VERSION, &vers) == 0)
>                 return  (vers.major*10000) + (vers.minor*100) + vers.patchlevel;
>         if (errno == EACCES)
>                 return -1;
>         if (major(stb.st_rdev) == MD_MAJOR)
>                 return (3600);
>         return -1;
> }
>
> ....
>
> int set_array_info(int mdfd, struct supertype *st, struct mdinfo *info)
> {
>         /* Initialise kernel's knowledge of array.
>          * This varies between externally managed arrays
>          * and older kernels
>          */
>         int vers = md_get_version(mdfd);
>         int rv;
>
> #ifndef MDASSEMBLE
>         if (st->ss->external)
>                 rv = sysfs_set_array(info, vers);
>         else
> #endif
>                 if ((vers % 100) >= 1) { /* can use different versions */
>                 mdu_array_info_t inf;
>                 memset(&inf, 0, sizeof(inf));
>                 inf.major_version = info->array.major_version;
>                 inf.minor_version = info->array.minor_version;
>                 rv = ioctl(mdfd, SET_ARRAY_INFO, &inf);
>         } else
>                 rv = ioctl(mdfd, SET_ARRAY_INFO, NULL);
>         return rv;
> }
>
> This has been around since at least 2008, the current code came in
> f35f25259279573c6274e2783536c0b0a399bdd4, but it looks like even the
> prior code made the same assumptions.
>
> In either case, the above 'if ((vers % 100) >= 1)' will always trigger
> since the kernel does #define MD_PATCHLEVEL_VERSION 3
>
> It's not like we have been updating MD_PATCHLEVEL_VERSION for a
> while. Was the code meant to be looking at the superblock minor version?
> I've been staring at this for a while now, so please beat me over the
> head if I missed something blatantly obvious.
>
> Jes

It is hard to get versioning right...

The version returned by the RAID_VERSION ioctl is meant to reflect the
capabilities of the implementation.  We could use the kernel version
number for that (and sometimes do), but as distro's often backport
features, that isn't always reliable.

I've incremented the MD_PATCHLEVEL_VERSION when a change is made that
cannot easily be detected from user-space.  As you note, we are up to
three.  The last change was in 2.6.15.
I've never contemplated changing the other two numbers that RAID_VERSION
return.  They don't seem to mean anything useful.

What exactly do you mean by "deprecate" the ioctl?
If you remove the code in mdadm that calls it, mdadm will not work
correctly on kernels older than 2.6.15, and it will be harder to
and an future capability that is not easily visible from user space.
If you remove the code in the kernel that handles it, you'll break
mdadm.

What is the goal here?

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljlcGoACgkQOeye3VZi
gbnftA//bRaFr/pNrqL05nM+P6oaQ9W1LmhOydpVbjKLsZifGvpsvE9xciba8xmj
0osvDrhvSioVfmlv03e5C6FWgcY6P/pQNoCnd6QE0/12YRXr+BtstHV1KTGNwhlL
JKGk3MrpAdjEgEhsmQ6eezAkH1+OAtVc9KJIGecdlzapMHOCAP4sS8lfavj6gjFc
ALDpcr+/fvyh4JpeCmm22YX2y+1O9LRq9Mb/gjLN7Pcad/ceFDAtl2z5IhWYFDsJ
wpNrec3uvxpRdsc6YGQTqHMT8SFLMZdGwr7neEqqsfKWSktBQ/UBMJ473mf5HmKo
dXqMWexgqv0HJN4kZaIgXAPEEyHIMgM3QzL0ZR69Y69AEZdFcTogaN97GOmEf6Ra
etNZA3qQHqXT4B16cVIKnvvo4mfhDCDpHKb1qksHBv289SAgKSkYb4y2FIganLMT
9DBzw5hTrF5CeHv2sIzlRSOu3VOa2OEs2dKQx/moB1k6IASHshjf1R3FCV/CsZrg
qNpF2YBaJhze1pL8skJzoljFBoxGdaD1hX7XysGcT7rGi9czDeiq3PrCV4YPQze1
pKGq92CsSqCpbIrOMBiXCjdE5+WlyNSAZLkoxWnXcKE9a9nJglPTOEpVKsZSiiqD
yv8D6ymcRLrbnpkSYSxDYCRWTuGn/NNqPMPD1ZkeyXutvWFimpc=
=PPc4
-----END PGP SIGNATURE-----
--=-=-=--

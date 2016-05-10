From: NeilBrown <neilb@suse.de>
Subject: Re: problems with lots of arrays
Date: Wed, 11 May 2016 08:39:53 +1000
Message-ID: <87wpn1sfk6.fsf@notabene.neil.brown.name>
References: <CAK9wOaB+Cic3nR5kzB3n=nVpbRtfo8+Qr9j_VNM3hh5tJRw6YA@mail.gmail.com> <wrfj8tzhk5by.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wrfj8tzhk5by.fsf@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>, Mike Lovell <mike.lovell@endurance.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Wed, May 11 2016, Jes Sorensen wrote:

> Mike Lovell <mike.lovell@endurance.com> writes:
>> we have a number of systems that have a large number of software
>> arrays running. its in the couple hundred range. we have been using a
>> custom built kernel based on 3.4 but are wanting to update to a
>> mainline kernel and have been experimenting with 4.4. the systems are
>> running recent centos 6 releases but we have been downgrading the
>> mdadm version from 3.3.2 in 6.7 to a custom build 3.2.6. we installed
>> the downgraded version due to a problem with array numbering. i
>> emailed the list a while ago explaining the issue and submitting a
>> patch to fix [1]. i never heard anything back and since we had a
>> simple fix i didn't follow up on it.
>
> [snip]
>
>> what do you all think?
>>
>> thanks
>> mike
>>
>> [1] http://marc.info/?l=linux-raid&m=142387809409798&w=2
>
> Staying consistent in using dev_t rather than casting back and forth to
> int seems a reasonable fix to apply to mdadm. It obviously won't change
> the issues with the newer kernels, but I don't see any reason why we
> shouldn't apply that fix to mdadm.
>
> Neil any thoughts on this?

I agree that changing "int" to "dev_t" is a good idea.

We should really fix the more general problem too.

On any kernel with  /sys/module/md_mod/parameters/new_array
find_free_devnm avoid trying anything above 511. (1<<9)-1.

If that fails to find a free number, then it should probably try a name
like "md_NN" and act as though ci->name is set.

Also, when a "name" given for the md array that is longer than 28 bytes
we need to fall back to choose an array name ourselves even if ci->name
is set.  Start with md_512 and work upwards.
Rather than probing we should read /sys/block looking for "md_*" and
maybe choose 1 more than the largest number found.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXMmM5AAoJEDnsnt1WYoG5QkwQAJmJJU4dGnlJb/4pHPWxXegn
s6XgdThzVnNumyG26NPvI54T33VCmG1R/TykGsE/N2dyfyGEY9zYNAidsHZrDj7q
Z5gLdGddfFvjx+xlnRNJhYe9KPJCSV+MhKlQppAbHawWmufLynqOC+fh5g+yhJbM
I91fzn5FA/tCKDVagkw+PZtFem2L29JcQePtQ5nYIotrgCejVA6ZIYSTw4OzYMJL
JpamA1B5SWZIVyjjYvyMW/+h8L7uPznAld0TTQ4QhgYwiFj4WUaorzpaQF9Nsq2l
hLyipxvjrCgZio0+qLiVUX8pan7S60q0NKXSwm/I6y0/0vmQKeHqE27I5xjXnovZ
/l1lLPd9TBiCOSzASNUvHXJsR3IUF4oDu7JDvCFHAaP4ybwsDsSPr2k7KewYplTJ
iGUabMddL2ObsECAnPEveOb4vkKdwylcmSHo6c0qlcfdShMM3SvxymaYY1SKUAT1
60H24TY1uHEy4PMbCxQlww6/JTCpbENW8IuCHh0u/qztr4i9ddijzSNBKeRR4dLw
paldvRcQeKr7mT2EnQm4Mci2dn+Zdng1PbaJjnc1Dp0XzBGGSR7jRaI+VDS9hjew
/gA9mpf9HFqf1VR6eS/YlmVZpMoGG6U14YWHtLRX8UVIteClcIE1xOSA29KukpKr
wupKFTTNj8vfiizFW9ru
=d7JI
-----END PGP SIGNATURE-----
--=-=-=--

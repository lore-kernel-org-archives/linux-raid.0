From: Hannes Reinecke <hare@suse.de>
Subject: Re: problems with lots of arrays
Date: Thu, 12 May 2016 07:58:06 +0200
Message-ID: <57341B6E.2080604@suse.de>
References: <CAK9wOaB+Cic3nR5kzB3n=nVpbRtfo8+Qr9j_VNM3hh5tJRw6YA@mail.gmail.com>
 <wrfj8tzhk5by.fsf@redhat.com> <87wpn1sfk6.fsf@notabene.neil.brown.name>
 <20160511004550.GB127453@kernel.org>
 <87eg98rqe1.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87eg98rqe1.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>, Shaohua Li <shli@kernel.org>
Cc: Jes Sorensen <Jes.Sorensen@redhat.com>, Mike Lovell <mike.lovell@endurance.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 05/12/2016 03:55 AM, NeilBrown wrote:
> On Wed, May 11 2016, Shaohua Li wrote:
>=20
>> On Wed, May 11, 2016 at 08:39:53AM +1000, NeilBrown wrote:
>>> On Wed, May 11 2016, Jes Sorensen wrote:
>>>=20
>>>> Mike Lovell <mike.lovell@endurance.com> writes:
>>>>> we have a number of systems that have a large number of
>>>>> software arrays running. its in the couple hundred range.
>>>>> we have been using a custom built kernel based on 3.4 but
>>>>> are wanting to update to a mainline kernel and have been
>>>>> experimenting with 4.4. the systems are running recent
>>>>> centos 6 releases but we have been downgrading the mdadm
>>>>> version from 3.3.2 in 6.7 to a custom build 3.2.6. we
>>>>> installed the downgraded version due to a problem with
>>>>> array numbering. i emailed the list a while ago explaining
>>>>> the issue and submitting a patch to fix [1]. i never heard
>>>>> anything back and since we had a simple fix i didn't follow
>>>>> up on it.
>>>>=20
>>>> [snip]
>>>>=20
>>>>> what do you all think?
>>>>>=20
>>>>> thanks mike
>>>>>=20
>>>>> [1] http://marc.info/?l=3Dlinux-raid&m=3D142387809409798&w=3D2
>>>>=20
>>>> Staying consistent in using dev_t rather than casting back
>>>> and forth to int seems a reasonable fix to apply to mdadm. It
>>>> obviously won't change the issues with the newer kernels, but
>>>> I don't see any reason why we shouldn't apply that fix to
>>>> mdadm.
>>>>=20
>>>> Neil any thoughts on this?
>>>=20
>>> I agree that changing "int" to "dev_t" is a good idea.
>>>=20
>>> We should really fix the more general problem too.
>>>=20
>>> On any kernel with  /sys/module/md_mod/parameters/new_array=20
>>> find_free_devnm avoid trying anything above 511. (1<<9)-1.
>>>=20
>>> If that fails to find a free number, then it should probably
>>> try a name like "md_NN" and act as though ci->name is set.
>>>=20
>>> Also, when a "name" given for the md array that is longer than
>>> 28 bytes we need to fall back to choose an array name ourselves
>>> even if ci->name is set.  Start with md_512 and work upwards.=20
>>> Rather than probing we should read /sys/block looking for
>>> "md_*" and maybe choose 1 more than the largest number found.
>>=20
>> I'm wondering why udev open the device with major/minor without
>> checking if the device exists. A simple 'stat' check is neat.
>=20
> A big part of the role of udev is to create the device nodes in
> /dev.
>=20
Not any more.
devtmpfs will create the device nodes automagically,
no need for udev to interfere.

Cheers,

Hannes
- --=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJXNBttAAoJEGz4yi9OyKjPAHcP/R4+cgYjqcNH4acdGLIR9g4x
ASIieuAEe1E4/OkWcSM1pRkOMHy8fjlXw41EKBePZRshkDAL0avoPkwL6QuCbK6T
jktuTHogNKgplGyBn9ibwKBSeXlw3skDHpYU+BoIoNGJD0fGGUcFHgJQj48ptsny
mpuqyy/1LXFQCYI7Sv96cZg1InA60I6vKEJXUud78InE01bJZWS6eHCh4PH9yq9S
7l+yrnMbtMiz78TtYvgSF77CVIFgJkV8xtWO3AExTDHL1V5UtLXnAI+tS4xOtvsE
vA0NTOpiVplwJVaLEwlgRFaAZYs8zFpiko/TUitQmx7BgaxPVas30h7R0uoWhsQY
ejn6HVSQMvKJQWl0guD1JnU8CrPge36OdJnqDtLOY9Dqwqun97EriGWle8j8zpgo
yJG852IchaMYB/YPhZvag4+hDRVgqVZO4XWyC9j5pk/tPBMwFPMMk7gZSDjDKMHD
Rm11uu1O6itUJr/IDMX5broTAI6e+DJDOUn4imXjSUmTp+cWqq+HSuvQR1/Amg6S
QuOSTJbOeEF+bEM209IMmCQj6pG/Fhw2vODGrnptiFI+g5Rsf6v8/DbOnSxJhnVX
QolSvjMigykY/K7JqvjYBjtCMrwvrEgNHOAUTOD9F70SWatetLA2rAbrl71LHMgS
CByHeGYD9xkd/UzzLKy0
=3D4WAN
-----END PGP SIGNATURE-----
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

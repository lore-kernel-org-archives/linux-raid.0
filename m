From: NeilBrown <neilb@suse.com>
Subject: Re: Linear device of two arrays
Date: Fri, 14 Jul 2017 11:57:04 +1000
Message-ID: <87o9sn232n.fsf@notabene.neil.brown.name>
References: <CALee7hZYgLNO2siDJNtFge_BoocTXX-9BSgRHmMJH8MaH6V3LA@mail.gmail.com> <20170705214250.0ea99538@natsu> <595D2ADA.8010907@youngman.org.uk> <CALee7hZqmLK19tSEEFBgSWMKm9TRoUqLBCxUmbNJpwmM45BjTQ@mail.gmail.com> <df053262-9334-1070-c24a-5d2f91402716@hardwarefreak.org> <CALee7haowPD0DKPtEQUN8M8LDCNOq62SDrk5VNMO5C+5iUqtrQ@mail.gmail.com> <5afd5cea-06b8-8524-e4f5-8534f23bd714@hardwarefreak.org> <87van15j9b.fsf@notabene.neil.brown.name> <e394625b-18d7-d141-3957-3c16c9bc6e44@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e394625b-18d7-d141-3957-3c16c9bc6e44@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Veljko <veljko3@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 10 2017, Veljko wrote:

> On 07/10/2017 12:37 AM, NeilBrown wrote:
>> I wasn't clear to me that I needed to chime in..  and the complete lack
>> of details (not even an "mdadm --examine" output), meant I could only
>> answer in vague generalizations.
>> However, seeing you asked.
>> If you really want to have a 'linear' of 2 RAID10s, then
>> 0/ unmount the xfs filesystem
>> 1/ backup the last few megabytes of the device
>>     dd if=3D/dev/mdXX of=3D/safe/place/backup bs=3D1M skip=3D$BIGNUM
>> 2/ create a linear array of the two RAID10s, ensuring the
>>    metadata is v1.0, and the dataoffset is zero (should be default with
>>    1.0)
>>     mdadm -C /dev/mdZZ -l linear -n 2 -e 1.0 --data-offset=3D0 /dev/mdXX=
 /dev/mdYY
>> 3/ restore the saved data
>>     dd of=3D/dev/mdZZ if=3D/safe/place/backup bs=3D1M seek=3D$BIGNUM
>> 4/ grow the xfs filesystem
>> 5/ be happy.
>>
>> I cannot comment on the values of "few" and "$BUGNUM" without seeing
>> specifics.
>>
>> NeilBrown
>
> Thanks for your response, Neil!
>
> md0 is boot (raid1), md1 is root (raid10) and md2 is data (raid10) that=20
> I need to expand. Here are details:

Presumably you also have an md3 raid10 which you want to attach to the
end of md2?

md2 is 5761631232 sectors.
  2880815616 kilobytes
  2813296.5 (binary)megabytes.
=20=20
When you include that into a "linear" you will lose a few K from the
end.
It might be sensible to cause the "linear" to use whole stripes from
the raid10, where a stripe is 1M (2 512K chunks).
If you did that, you would lose a little over 1M.
So backup the last 3.5 M of the raid10.  This is much more than you need.

ie.

  dd if=3D/dev/md2 of=3DSOMEWHERE/SAFE bs=3D1M skip=3D2813293

(dd treats 'M' as 1024*1024, MB is 1000*1000)

If the file this creates is not 3.5M, then something went wrong.  Stop
here.

Just to be safe you might want to backup the first few megabytes.  You
won't need this unless something goes wrong
  dd if=3D/dev/md2 of=3DSOMEWHERE/ELSE bs=3D1M count=3D10

Now create the linear from /dev/md2 and /dev/md3(?).  Be sure to use
"-e 1.0 --data-offset=3D0".  This creates /dev/md4

Now restore the first backup

 dd if=3DSOMEWHERE/SAFE of=3D/dev/md4 bs=3D1M seek=3D2813293

Be sure to use the same bs=3D and seek=3D as you did the first time.
Be sure it is copying from the back and to the new linear raid.

You should now be done. Check your xfs filesystem, and maybe even mount
it and use it.

NeilBrown

>
> # mdadm --detail /dev/md2
> /dev/md2:
>          Version : 1.2
>    Creation Time : Fri Sep 14 12:40:13 2012
>       Raid Level : raid10
>       Array Size : 5761631232 (5494.72 GiB 5899.91 GB)
>    Used Dev Size : 2880815616 (2747.36 GiB 2949.96 GB)
>     Raid Devices : 4
>    Total Devices : 4
>      Persistence : Superblock is persistent
>
>      Update Time : Mon Jul 10 12:32:51 2017
>            State : clean
>   Active Devices : 4
> Working Devices : 4
>   Failed Devices : 0
>    Spare Devices : 0
>
>           Layout : near=3D2
>       Chunk Size : 512K
>

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlloJPIACgkQOeye3VZi
gbkSfA//TXXIhhXj+qYddBv/zD7Rgjc95VdmVFLJedrqvbZErh1FgvJWVw+sxMpD
DpyNidX3QHdUkc4K5LjMaXwHLP+937eBSztRlC3vD+BfKys2gPAP4ED/0YrqB0o7
xkopOszkCvvb962I4fh5NaI5EB50ptQ1hUbNYa74jQAMgInxfa0pzDPvfBFHQiii
57Y2A4Zh3tyhLEBB0ufCr+6CWSbftfemK8PZBOHwBd+BbPvSWpYVlvrpeMC4AnMx
SL01HnBqqwWwMROK5Tb50sk5Cqx+43VVL2SKXspMIgL9BYWMyoXpPv6YoQbZbGy5
3iQCHZC7UMQnlybkuO4oc/2+Ah58aWu4tBuxhOVOVO5QEw2M2/nAg6zKtKbQs3Zq
rZ4btrXNX8jylVJqKqPiUvbKquRB1KHjWYjp0UnH16NE9zleOentXDCSoxbO0ThQ
wEvoI7/mYOe6INNORp7iVrnPHOfFOOvmdJE8Jzt+sm9JVznTT3UVIFAEsaPENQaf
sXGja134BqzvffsabaHP2tcRlYXPiZ6gSKnUdE0X2on0uZSWl/8kL5bhOpL0eVEH
Lc0lczr3J5jzVsjXFnkFlUAWzblmvGLG1p//SyvAspFSOVBQmkMYTeh52fYL6PSd
GFeNv93GR/mX+8R9mokx4Fqg3B477+zjb98JO65PFzAy8li2VrU=
=j5IW
-----END PGP SIGNATURE-----
--=-=-=--

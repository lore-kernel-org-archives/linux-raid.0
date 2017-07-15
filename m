From: NeilBrown <neilb@suse.com>
Subject: Re: Linear device of two arrays
Date: Sat, 15 Jul 2017 10:12:26 +1000
Message-ID: <87shhyzhg5.fsf@notabene.neil.brown.name>
References: <CALee7hZYgLNO2siDJNtFge_BoocTXX-9BSgRHmMJH8MaH6V3LA@mail.gmail.com> <20170705214250.0ea99538@natsu> <595D2ADA.8010907@youngman.org.uk> <CALee7hZqmLK19tSEEFBgSWMKm9TRoUqLBCxUmbNJpwmM45BjTQ@mail.gmail.com> <df053262-9334-1070-c24a-5d2f91402716@hardwarefreak.org> <CALee7haowPD0DKPtEQUN8M8LDCNOq62SDrk5VNMO5C+5iUqtrQ@mail.gmail.com> <5afd5cea-06b8-8524-e4f5-8534f23bd714@hardwarefreak.org> <87van15j9b.fsf@notabene.neil.brown.name> <e394625b-18d7-d141-3957-3c16c9bc6e44@gmail.com> <87o9sn232n.fsf@notabene.neil.brown.name> <1eefd627-1aba-a795-05f0-d2106d3a62a3@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1eefd627-1aba-a795-05f0-d2106d3a62a3@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Veljko <veljko3@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 14 2017, Veljko wrote:

> On 07/14/2017 03:57 AM, NeilBrown wrote:
>>
>> Presumably you also have an md3 raid10 which you want to attach to the
>> end of md2?
>
> Yes, I just created it. It's resyncing.
>
>
>> md2 is 5761631232 sectors.
>>   2880815616 kilobytes
>>   2813296.5 (binary)megabytes.
>>
>> When you include that into a "linear" you will lose a few K from the
>> end.
>> It might be sensible to cause the "linear" to use whole stripes from
>> the raid10, where a stripe is 1M (2 512K chunks).
>> If you did that, you would lose a little over 1M.
>> So backup the last 3.5 M of the raid10.  This is much more than you need.
>>
>> ie.
>>
>>   dd if=3D/dev/md2 of=3DSOMEWHERE/SAFE bs=3D1M skip=3D2813293
>
> I'm little confused. What I'm backuping is last 3.5M of used space,=20
> right? How is that only ~2.7T? df shows 4.8T of used space.

You were right to check.

md2 is 5761631232 kilobytes, not sectors.
so 5626593 (binary) megabytes (exactly)

So command should be

>>   dd if=3D/dev/md2 of=3DSOMEWHERE/SAFE bs=3D1M skip=3D5626590

and expect it to create a 3M file.

Use this 'skip' number of the 'seek' number later.

NeilBrown


>
> Rest of the instructions are clear and I'll try it as soon as md3 is=20
> synced.
>
> Thanks Neil!
>
>> (dd treats 'M' as 1024*1024, MB is 1000*1000)
>>
>> If the file this creates is not 3.5M, then something went wrong.  Stop
>> here.
>>
>> Just to be safe you might want to backup the first few megabytes.  You
>> won't need this unless something goes wrong
>>   dd if=3D/dev/md2 of=3DSOMEWHERE/ELSE bs=3D1M count=3D10
>>
>> Now create the linear from /dev/md2 and /dev/md3(?).  Be sure to use
>> "-e 1.0 --data-offset=3D0".  This creates /dev/md4
>>
>> Now restore the first backup
>>
>>  dd if=3DSOMEWHERE/SAFE of=3D/dev/md4 bs=3D1M seek=3D2813293
>>
>> Be sure to use the same bs=3D and seek=3D as you did the first time.
>> Be sure it is copying from the back and to the new linear raid.
>>
>> You should now be done. Check your xfs filesystem, and maybe even mount
>> it and use it.
>>
>> NeilBrown
>>
>>>
>>> # mdadm --detail /dev/md2
>>> /dev/md2:
>>>          Version : 1.2
>>>    Creation Time : Fri Sep 14 12:40:13 2012
>>>       Raid Level : raid10
>>>       Array Size : 5761631232 (5494.72 GiB 5899.91 GB)
>>>    Used Dev Size : 2880815616 (2747.36 GiB 2949.96 GB)
>>>     Raid Devices : 4
>>>    Total Devices : 4
>>>      Persistence : Superblock is persistent
>>>
>>>      Update Time : Mon Jul 10 12:32:51 2017
>>>            State : clean
>>>   Active Devices : 4
>>> Working Devices : 4
>>>   Failed Devices : 0
>>>    Spare Devices : 0
>>>
>>>           Layout : near=3D2
>>>       Chunk Size : 512K
>>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAllpXe0ACgkQOeye3VZi
gbmHKA//TRAozcxZPD0mn7pI0qer9euJ7bKrA9qVTdRgDodvXlLhaxT9OPha1KrU
Qx1xVlucSsJ1AxQF9Nkh2CsAa8WX1WLfNqABaOU6epCtW5PfuEsmSQPe+Tr5saby
lPULXMcL0nhCV9IIi3w4rHmuvYwTac3DpujBFxDLr6KQ+Y/4t+DOJdQhMMOtbn0t
+uPE6hGz0DeDgSDFie5pyEOi9onoaq1F+v1P3FeQ0EM38WHUWe5atEfR5y1Jr75J
Qj5tiEf8etH3hokN9hhsQk73sFAsIUbmHKjBzWO/Fq1use9gksMSehFCY2hgT+fK
By7D7yzAjo7qsgpmSS82PN4/qL3HALmVNIkZYzaKsebFc51hWNl2WzsgJxlWZZ9k
ixr/O0LHbpOA4Zpjnv4LXFYOvJQDLJSfzTCqdGhKb7ZlggQwITuaeDRJOXm4VHhM
lq4WUdxLNusadB+AsQjzyNzYuXux4mEcyYhJ+7W51cO8o3vW3dP+reSXL7K569dx
2QFobg+0RZHqEmh37zWAqKb56cXksS3d6N6klwPAo0rubsrYsQus0PgqmaROeZic
pk98/TJch71ONc61UdCzFn+3MyffXMP3efGs9dtOauGCr/vBom/Tz7YPXmKuerUj
9EMMT1amus9woKxd5CN4b4Q8NWz7EsUW48i1M5++FzmnDLJd8UM=
=9uyt
-----END PGP SIGNATURE-----
--=-=-=--

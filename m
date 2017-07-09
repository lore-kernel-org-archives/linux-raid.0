From: NeilBrown <neilb@suse.com>
Subject: Re: Linear device of two arrays
Date: Mon, 10 Jul 2017 08:37:52 +1000
Message-ID: <87van15j9b.fsf@notabene.neil.brown.name>
References: <CALee7hZYgLNO2siDJNtFge_BoocTXX-9BSgRHmMJH8MaH6V3LA@mail.gmail.com> <20170705214250.0ea99538@natsu> <595D2ADA.8010907@youngman.org.uk> <CALee7hZqmLK19tSEEFBgSWMKm9TRoUqLBCxUmbNJpwmM45BjTQ@mail.gmail.com> <df053262-9334-1070-c24a-5d2f91402716@hardwarefreak.org> <CALee7haowPD0DKPtEQUN8M8LDCNOq62SDrk5VNMO5C+5iUqtrQ@mail.gmail.com> <5afd5cea-06b8-8524-e4f5-8534f23bd714@hardwarefreak.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5afd5cea-06b8-8524-e4f5-8534f23bd714@hardwarefreak.org>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.org>, veljko3@gmail.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 08 2017, Stan Hoeppner wrote:

> On 07/08/2017 05:26 AM, Veljko wrote:
>> On Sat, Jul 8, 2017 at 12:52 AM, Stan Hoeppner <stan@hardwarefreak.org> =
wrote:
>>> On 07/07/2017 03:26 PM, Veljko wrote:
>>>> I just noticed that I replied to Wol insted to list.
>>>>
>>>> On Wed, Jul 5, 2017 at 8:07 PM, Wols Lists <antlists@youngman.org.uk>
>>>> wrote:
>>>>> On 05/07/17 17:42, Roman Mamedov wrote:
>>>>>> On Wed, 5 Jul 2017 17:34:09 +0200
>>>>>> Veljko <veljko3@gmail.com> wrote:
>>>>>>
>>>>>>> Hello,
>>>>>>>
>>>>>>> I have a RAID10 device which I have formated using the mkfs.xfs
>>>>>>> defaults (Stan helped me with this few years back). I reached 88%
>>>>>>> capacity and it is time to expand it. I bought 4 more drives to cre=
ate
>>>>>>> another RIAD10 array. I would like to create linear device out of
>>>>>>> those two and grow XFS across the 2nd device. How can this be done
>>>>>>> without loosing the existing device's data? I would also like to ad=
d a
>>>>>>> spare HDD. Do I have to have a separate spare HDD for each array or
>>>>>>> one can be used by both of them?
>>>>>> Why make another RAID10? With modern versions of mdadm and kernel you
>>>>>> should
>>>>>> be able to simply reshape the current RAID10 to increase the number =
of
>>>>>> devices used from 4 to 8.
>>>>>>
>>>>>>
>>>>> I was thinking of replying, but isn't that not possible for some
>>>>> versions of RAID-10?
>>>>>
>>>>> My feeling was, if you can't just add drives to the existing raid 10,
>>>>> create a new one which you can expand, migrate the fs across (btrfs
>>>>> would let you do that live, I believe, so xfs probably can too), then
>>>>> you can scrap the old raid-10 and add the drives into the new one.
>>>>>
>>>>> Cheers,
>>>>> Wol
>>>>
>>>> Thanks for your input, Roman and Wol.
>>>>
>>>> Expanding existing RAID is one of the options, but I was advised by
>>>> Stan Hoeppner to do it this way and I tend to believe him on this
>>>> subject. With my metadata heavy backup workload, this will provide
>>>> better performance.
>>>>
>>>> So my question is still, how can an existing array be added to linear
>>>> device, and it's file system expanded over the second array.
>>> For this to work the existing RAID10 array must already be a member of a
>>> linear device with one component device.  If this linear array already
>>> exists then you could add another RAID10 array to the linear device.  I=
f you
>>> currently have an XFS filesystem sitting atop a 'bare' RAID10 then I do=
n't
>>> believe the linear option will work for you.  Thus I'd tend to agree wi=
th
>>> others that reshaping your current RAID10 is the best option.
>>>
>>> My apologies if I wasn't clear in my previous advice.
>>>
>>> Stan
>> Here is your previous advice:
>> "Do not use LVM.  Directly format the RAID10 device using the mkfs.xfs
>> defaults.  mkfs.xfs will read the md configuration and automatically
>> align the filesystem to the stripe width.
>>
>> When the filesystem reaches 85% capacity, add 4 more drives and create
>> another RAID10 array.  At that point we'll teach you how to create a
>> linear device of the two arrays and grow XFS across the 2nd array."
>>
>>  From this I concluded that it is possible to create linear device
>> using existing array, but since it is not the case, I'll just have to
>> create new array, move data to it, than add first array to a new
>> linear device (1 member), copy my data to it, and than join second
>> device to it. I wanted to avoid all this copying but will have to do
>> it. Than I will add one drive to spare-group both arrays will be a
>> members of, as advised by Andreas. Does this sound OK?
>
> Yes.  Although, I was hoping Neil Brown would chime in here. I'm not=20
> entirely sure that you can't do this the way I originally mentioned.

I wasn't clear to me that I needed to chime in..  and the complete lack
of details (not even an "mdadm --examine" output), meant I could only
answer in vague generalizations.
However, seeing you asked.
If you really want to have a 'linear' of 2 RAID10s, then
0/ unmount the xfs filesystem
1/ backup the last few megabytes of the device
    dd if=3D/dev/mdXX of=3D/safe/place/backup bs=3D1M skip=3D$BIGNUM
2/ create a linear array of the two RAID10s, ensuring the
   metadata is v1.0, and the dataoffset is zero (should be default with
   1.0)
    mdadm -C /dev/mdZZ -l linear -n 2 -e 1.0 --data-offset=3D0 /dev/mdXX /d=
ev/mdYY
3/ restore the saved data
    dd of=3D/dev/mdZZ if=3D/safe/place/backup bs=3D1M seek=3D$BIGNUM
4/ grow the xfs filesystem
5/ be happy.

I cannot comment on the values of "few" and "$BUGNUM" without seeing
specifics.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAllisEEACgkQOeye3VZi
gbkMsA//UE1uekQjcsUtKXO2N7rFgpAg7bGnZrrXO/kZD4PqlEhhaHE/dm6kM0iY
XNsu2JASLgEEwK72+rKoqqsnBe5zbsZNVuA3DUF5T9JSnp2QEdJKmHX9FLp6suWF
wjcpTYb0/Q1rz27U8zvlWF4HBE/ILEySWOGu5UDrEtCJ+EdzWJPB62Sw0Cz8jvxG
UyMkMtJUU9Cm6iwdG3jxmJn/bdm5IcpQ7T/gMxC5MuFo75ahen2ImQsGZNmGag01
xFBeII049UqiIMW7S04NCuBqwV7RzgE0hu6s1tWxLPKhJwnqq2pMPopINbswHZE3
5NuR9Veo5qM4V4FX0OV5aYKmSjxSjXazY1jjijOdBSaSSsj06TE4xfjrWhi6+t9S
oiNop9gH5ApIULXvEEXzTeEY/iaS/OgQnYrduZYNaHgmbB7gnSxeoXcCdAlmYYgw
26xDXHBB+NqBXSJQUWiJcDj0rmnfYVbxv4VS7wSnfN8F1I0MNBTayxVyRow/38cx
hQy8iwUbewD+Y2yzSHe5wkLn18FaaDgllzvq++r34y9QALZPezeyLgj2SA8esPXu
OBq8yyl0Yky2bJcpYrxkMRM7QdErteMXf+1VNneW6YcxelBsdqGPdzqP5kfKL/pN
+UvSJquMBk4wi2gDGvCueBwkwzGfbuJu71SMuurTkvZFciaorKw=
=hO9F
-----END PGP SIGNATURE-----
--=-=-=--

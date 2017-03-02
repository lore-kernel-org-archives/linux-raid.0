From: Song Liu <songliubraving@fb.com>
Subject: Re: raid5 - adding journal to an existing device?
Date: Thu, 2 Mar 2017 19:19:28 +0000
Message-ID: <A965D0D0-10A2-4CFF-8901-A786B09DD38C@fb.com>
References: <9447cf1f98aaade8ab5cd3f0ef724f79@admin.virtall.com>
 <20170302183925.xnvvybpui6ldssv6@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170302183925.xnvvybpui6ldssv6@kernel.org>
Content-Language: en-US
Content-ID: <0B309712B7A21746BC08908F071C791E@namprd15.prod.outlook.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Tomasz Chmielewski <mangoo@wpkg.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "jes.sorensen@gmail.com" <jes.sorensen@gmail.com>
List-Id: linux-raid.ids


> On Mar 2, 2017, at 10:39 AM, Shaohua Li <shli@kernel.org> wrote:
>=20
> On Sat, Feb 25, 2017 at 11:12:21PM +0900, Tomasz Chmielewski wrote:
>> mdadm manual specifies the following for create, build and grow modes:
>>=20
>>       --write-journal
>>              Specify journal device for the RAID-4/5/6 array.
>>=20
>> However:
>>=20
>> # mdadm --grow /dev/md2 --write-journal /dev/sdc1
>> mdadm: :option --write-journal not valid in grow mode
>>=20
>>=20
>> Is it not yet supported, will never be supported, or am I simply trying =
to
>> use it in a  wrong way?
>>=20
>>=20
>>=20
>> Tried the following versions:
>>=20
>> # ./mdadm -V
>> mdadm - v3.4-115-ge22fe3a - 29th November 2016
>>=20
>> # mdadm -V
>> mdadm - v3.4 - 28th January 2016
>=20
> Cc: Song and Jes.
>=20
> I think we support hotadd journal. Will let Song clarify.
>=20
> Thanks,
> Shaohua

We have support for hotadd journal to an array with broken/missing journal.=
=20
We haven't implement hotted journal to arrays with no journal ever. We do p=
lan
to add the feature.=20

Thanks,
Song=

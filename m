From: Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH] raid5: use memalloc_noio_save()/restore in
 resize_chunks()
Date: Thu, 30 Apr 2020 06:36:37 +0000
Message-ID: <1B9A34D3-C98E-49A7-9222-7D25F5F7CCC9@fb.com>
References: <20200402081312.32709-1-colyli@suse.de>
 <fa7e30b9-7480-6c03-0f43-d561fed912fb@cloud.ionos.com>
 <5f27365b-768f-eb69-36ec-f4ed0c292c60@suse.de>
 <204e9fd0-3712-4864-2bf5-38913511e658@cloud.ionos.com>
 <20200415114814.GJ4629@dhcp22.suse.cz>
 <a1e83cb5-366c-17a7-3a4b-9cd8a54c3b48@cloud.ionos.com>
 <20200415142303.GN4629@dhcp22.suse.cz>
 <b7584395-6230-36a6-9d78-dd1e1b630bbd@cloud.ionos.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <b7584395-6230-36a6-9d78-dd1e1b630bbd@cloud.ionos.com>
Content-Language: en-US
Content-ID: <E886392282A0F64BAAAA3879F52851FB@namprd15.prod.outlook.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Cc: Michal Hocko <mhocko@kernel.org>, Coly Li <colyli@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, Kent Overstreet <kent.overstreet@gmail.com>
List-Id: linux-raid.ids



> On Apr 15, 2020, at 7:57 AM, Guoqing Jiang <guoqing.jiang@cloud.ionos.com=
> wrote:
>=20
> On 15.04.20 16:23, Michal Hocko wrote:
>> On Wed 15-04-20 16:10:08, Guoqing Jiang wrote:
>>> On 15.04.20 13:48, Michal Hocko wrote:
>>>> On Thu 09-04-20 23:38:13, Guoqing Jiang wrote:
>>>> [...]
>>>>> Not know memalloc_noio_{save,restore} well, but I guess it is better
>>>>> to use them to mark a small scope, just my two cents.
>>>> This would go against the intentio of the api. It is really meant to
>>>> define reclaim recursion problematic scope.
>>> Well, in current proposal, the scope is just when
>>> scribble_allo/kvmalloc_array is called.
>>>=20
>>> memalloc_noio_save
>>> scribble_allo/kvmalloc_array
>>> memalloc_noio_restore
>>>=20
>>> With the new proposal, the marked scope would be bigger than current on=
e
>>> since there
>>> are lots of places call mddev_suspend/resume.
>>>=20
>>> mddev_suspend
>>> memalloc_noio_save
>>> ...
>>> memalloc_noio_restore
>>> mddev_resume
>>>=20
>>> IMHO, if the current proposal works then what is the advantage to incre=
ase
>>> the scope.
>> The advantage is twofold. It serves the documentation purpose because it
>> is clear _what_ and _why_ is the actual allocation restricted context.
>> In this case mddev_{suspend,resume} because XYZ and you do not have to
>> care about __GFP_IO for _any_ allocation inside the scope.
>=20
> Personally, I'd prefer fine grained protection scope, anyway just my own
> flavor. And I think Song has his opinion about the proposal, I will respe=
ct
> his decision.

Thanks Coly, Guoqing, and Michal for these great inputs.=20

Coly's v3 set looks good to me. I will go ahead apply that version to md-ne=
xt
branch.=20

Thanks again,
Song

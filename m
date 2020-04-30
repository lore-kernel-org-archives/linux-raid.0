From: Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH] md/raid0: add config parameters to specify zone layout
Date: Thu, 30 Apr 2020 06:19:26 +0000
Message-ID: <E3616A45-C6D0-4B3B-8112-688B03126F00@fb.com>
References: <1585236500-12015-1-git-send-email-jbaron@akamai.com>
 <0b7aad8b-f0b7-24c6-ad19-99c6202a3036@suse.de>
 <8feb2018-7f99-6e02-c704-9d7fed40bba2@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <8feb2018-7f99-6e02-c704-9d7fed40bba2@akamai.com>
Content-Language: en-US
Content-ID: <D838AE0962CBCF47995E7AC2D4866D5E@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Baron <jbaron@akamai.com>
Cc: Coly Li <colyli@suse.de>, "agk@redhat.com" <agk@redhat.com>, "snitzer@redhat.com" <snitzer@redhat.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Guoqing Jiang <guoqing.jiang@cloud.ionos.com>, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

Hi Jason,

> On Apr 27, 2020, at 2:10 PM, Jason Baron <jbaron@akamai.com> wrote:
>=20
>=20
>=20
> On 4/25/20 12:31 AM, Coly Li wrote:
>> On 2020/3/26 23:28, Jason Baron wrote:
>>> Let's add some CONFIG_* options to directly configure the raid0 layout
>>> if you know in advance how your raid0 array was created. This can be
>>> simpler than having to manage module or kernel command-line parameters.
>>>=20
>>=20
>> Hi Jason,
>>=20
>> If the people who compiling the kernel is not the end users, the
>> communication gap has potential risk to make users to use a different
>> layout for existing raid0 array after a kernel upgrade.
>>=20
>> If this patch goes into upstream, it is very probably such risky
>> situation may happen.
>>=20
>> The purpose of adding default_layout is to let *end user* to be aware of
>> they layout when they use difference sizes component disks to assemble
>> the raid0 array, and make decision which layout algorithm should be
>> used. Such situation cannot be decided in kernel compiling time.
>=20
> I agree that in general it may not be known at compile time. Thus,
> I've left the default as RAID0_LAYOUT_NONE. However, there are
> use-cases where it is known at compile-time which layout is needed.
> In our use-case, we knew that we didn't have any pre-3.14 raid0
> arrays. Thus, we can safely set RAID0_ALT_MULTIZONE_LAYOUT. So
> this is a simpler configuration for us than setting module or command
> line parameters.

I would echo Coly's concern that CONFIG_ option could make it risky.=20
If the overhead of maintaining extra command line parameter, I would
recommend you carry a private patch for this change. For upstream, it
is better NOT to carry the default in CONFIG_.

Thanks,
Song

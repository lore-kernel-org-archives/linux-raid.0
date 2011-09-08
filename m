From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] kill-subarray: fix, cannot kill-subarray with unsupported metadata
Date: Wed, 7 Sep 2011 17:16:42 -0700
Message-ID: <CAA9_cmeB_NPE6w0aD0dhyEHi_ZJ8nexNzHgxbw42d29Odp2RWw@mail.gmail.com>
References: <F9123E44003394499FDD2B17C60621D401BE07@IRSMSX101.ger.corp.intel.com>
	<CABE8wwsfrdgZcHzOdTpA-EM1R8fknw7hCT1+VHGus5h-Pa-3pA@mail.gmail.com>
	<20110907143111.499ae36e@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110907143111.499ae36e@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "Labun, Marcin" <Marcin.Labun@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

On Tue, Sep 6, 2011 at 9:31 PM, NeilBrown <neilb@suse.de> wrote:
> On Tue, 6 Sep 2011 12:16:43 -0700 "Williams, Dan J"
> <dan.j.williams@intel.com> wrote:
>
>> On Mon, Sep 5, 2011 at 7:23 AM, Labun, Marcin <Marcin.Labun@intel.co=
m> wrote:
>> > Subject: [PATCH] kill-subarray: fix, cannot kill-subarray with uns=
upported metadata
>> >
>> > container_content retrieves volume information from disks in the c=
ontainer.
>> > For unsupported volumes the function was not returning mdinfo. Whe=
n all volumes
>> > were unsupported the function was returning NULL pointer to block =
actions on the volumes.
>>
>> Isn't this the purpose of ->ignore_hw_compat?
>>
>> So we could do something simpler like the following instead?
>>
>> diff --git a/Kill.c b/Kill.c
>> index b841a5b..11b27a6 100644
>> --- a/Kill.c
>> +++ b/Kill.c
>> @@ -97,7 +97,9 @@ int Kill_subarray(char *dev, char *subarray, int q=
uiet)
>>
>> =A0 =A0 =A0 =A0 memset(st, 0, sizeof(*st));
>>
>> + =A0 =A0 =A0 st->ignore_hw_compat =3D 1;
>> =A0 =A0 =A0 =A0 fd =3D open_subarray(dev, subarray, st, quiet);
>> + =A0 =A0 =A0 st->ignore_hw_compat =3D 0;
>> =A0 =A0 =A0 =A0 if (fd < 0)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 2;
>
> While that is a *much* nicer patch, I don't think it will actually ad=
dress
> the problem.
> You would at least need container_content_imsm to ignore
> imsm_check_attributes if ->ignore_hw_compat was set.
>
> However I think things are getting a bit messy here and need to be cl=
eaned up.
>
> Marcin's patch has the advantage that it treats the existence of a ba=
d block
> log and incompatible attributes in much the same way.
> However I don't like:
> =A0- the increase in number of magic flag bits
> =A0- the editing of the list of arrays returned by container_content
> =A0- the error messages being printed by super-intel.c
>
> I think I would like:
> =A0- container_content always returns info about all arrays, so Exami=
ne and
> =A0 Kill can work properly
> =A0- it sets a single flags (MD_SB_INVALID??) to say that the array c=
annot be
> =A0 assembled or manipulated, and maybe stored a message string in th=
e 'info'
> =A0 so that common code can print it when it choses to ignore an arra=
y
> =A0- common code checks and ignores MD_SB_INVALID arrays as needed ra=
ther than
> =A0 having them be removed from the list.
>
> Reasonable??

Yes, it would be nice to have a unified interface for reporting
"please, don't assemble this because: foo" while also giving as much
other info about the configuration as possible.

Where foo is:
"configuration crosses hardware domain boundary"
"platform/metadata is using feature X that mdadm does not support"
"raid array cannot be assembled without potentially exposing corrupted =
data"

Then --force can uniformly override those concerns, probably for
"Create" operations as well, but --force already has other meanings
there.

The ->ignore_hw_compat approach had the small beneficial side effect
of whitelisting approved usages of potentially invalid information,
but it should be no big deal to ensure those all get covered.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

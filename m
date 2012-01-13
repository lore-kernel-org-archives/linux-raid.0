From: David Brown <david@westcontrol.com>
Subject: Re: [PATCH 1/1] Work around gcc-4.7's strict aliasing checks
Date: Fri, 13 Jan 2012 13:20:51 +0100
Message-ID: <4F1021A3.6020203@westcontrol.com>
References: <1325762201-23949-1-git-send-email-Jes.Sorensen@redhat.com>	<1325762201-23949-2-git-send-email-Jes.Sorensen@redhat.com> <20120112104320.471910db@notabene.brown> <4F0E8873.8040900@hesbynett.no> <4F0EE3F3.9050906@ziu.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F0EE3F3.9050906@ziu.info>
Sender: linux-raid-owner@vger.kernel.org
To: Michal Soltys <soltys@ziu.info>
Cc: David Brown <david.brown@hesbynett.no>, linux-raid@vger.kernel.org, Jes.Sorensen@redhat.com, dledford@redhat.com
List-Id: linux-raid.ids

On 12/01/2012 14:45, Michal Soltys wrote:
> On 12.01.2012 08:14, David Brown wrote:
>> On 12/01/12 00:43, NeilBrown wrote:
>>> On Thu, 5 Jan 2012 12:16:41 +0100 Jes.Sorensen@redhat.com wrote:
>>>
>>>> From: Jes Sorensen<Jes.Sorensen@redhat.com>
>>>>
>>>> -	info->array.ctime	  = DECADE + __be32_to_cpu(*(__u32*)
>>>> -							 (ddf->anchor.guid+16));
>>>> +	cptr = (__u32 *)(ddf->anchor.guid + 16);
>>>> +	info->array.ctime	  = DECADE + __be32_to_cpu(*cptr);
>
> But going through intermediate (yet incompatible) pointer still breaks
> the aliasing rules - unless the above is related to how 4.7+ in
> particular do things.
>
> Somewhat similar code - on 4.5.2 and 4.4.1 though, of which the former
> will warn about possible break only with the most aggressive (broad)
> -Wstrict-aliasing=1 (and the latter at all levels):
>
> int main(void)
> {
> 	struct s {
> 		uint16_t d[128];
> 	} tab;
> 	uint32_t *p32;
>
> 	tab.d[8] = 0x5678;
> 	tab.d[9] = 0x1234;
>
> 	p32 = (uint32_t *)&tab.d[8];
> 	printf("%X\n", *p32);
>
> 	return 0;
> }
>
>
> Will output 0 on my machines when compiled with -O2 or higher (or -O1
> -fstrict-aliasing) - unless -fno-strict-aliasing is added.
>
> The code clearly breaks the rules, so no wonder optimizations relying on
> them messed up. I'm not sure if/how much changed since then, so perhaps
> it would behave fine on 4.7+.
>
>>
>> The basic rule is that the compiler can assume that objects whose type
>> has different sizes, cannot appear at the same address. Unions are one
>> way to avoid this.
>>
>
> Following this lengthy (but quite interesting) thread it's not (was not
> ?) allowed either:
> http://thread.gmane.org/gmane.comp.gcc.devel/111111
>
> It's 2 years old thread, still the rules and interpretation seem pretty
> well entrenched.
>
> OTOH: __attribute__((__may_alias__)) should(?) always give consistent
> (expected) results with type definitions that are used as aliases. Maybe it
> would be better to go by this route.

I couldn't find that attribute in the gcc manual.

>
> In context of mdadm - I wonder if simply -fno-strict-aliasing wouldn't
> be the overall best thing to do.

I don't know much about the style requirements for kernel code, but it 
might be best to specify this using "#pragma GCC optimize 
("no-strict-aliasing")" to force it into the source code independently 
of any global compiler options.


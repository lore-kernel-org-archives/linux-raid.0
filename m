From: Daniel Axtens <dja@axtens.net>
Subject: Re: [PATCH] raid6/altivec: adding vpermxor implementation for raid6 Q syndrome
Date: Tue, 04 Apr 2017 07:44:32 +1000
Message-ID: <87wpb1kvy7.fsf@possimpible.ozlabs.ibm.com>
References: <20170330051313.31358-1-matthew.brown.dev@gmail.com> <877f31n2mn.fsf@possimpible.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <877f31n2mn.fsf@possimpible.ozlabs.ibm.com>
Sender: linux-raid-owner@vger.kernel.org
To: Matt Brown <matthew.brown.dev@gmail.com>, linux-raid@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org
List-Id: linux-raid.ids

> In that function, the flow is:
>  pagefault_disable();
>  enable_kernel_altivec();
>  <vectorised function>
>  pagefault_enable();
>
> There are a few things that it would be nice (but by no means essential)
> to find out:
>  - what is the difference between pagefault and prempt enable/disable
>  - is it required to disable altivec after the end of the function or
>    can we leave that enabled?

Answering my own question here, dc4fbba11e46 ("powerpc: Create
disable_kernel_{fp,altivec,vsx,spe}()") adds the disable_ function, and
it's a no-op except under debug conditions. So it should stay.

Regards,
Daniel


>
>> +
>> +int raid6_have_altivec_vpermxor(void);
>> +#if $# == 1
>> +int raid6_have_altivec_vpermxor(void)
>> +{
>> +	/* Check if CPU has both altivec and the vpermxor instruction*/
> Please add a space: s|ion*/|ion */|
>> +# ifdef __KERNEL__
>> +	return (cpu_has_feature(CONFIG_ALTIVEC) &&
>> +		cpu_has_feature(CPU_FTR_ARCH_207S));
> I assume this is future-proof - an ISA 3.00 cpu will advertise 2.07S
> compat?
>
>> +# else
>> +	return 1;
>> +#endif
>> +
>> +}
>> +#endif
>> +
>> +const struct raid6_calls raid6_vpermxor$# = {
>> +	raid6_vpermxor$#_gen_syndrome,
>> +	NULL,
>> +	raid6_have_altivec_vpermxor,
>> +	"vpermxor$#",
>> +	0
>> +};
>> +#endif
>> -- 
>> 2.9.3
>
> Apart from that this patch looks good and I expect I will be able to
> formally Review v2.
>
> Regards,
> Daniel

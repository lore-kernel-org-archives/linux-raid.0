From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH] raid6/altivec: adding vpermxor implementation for raid6 Q
 syndrome
Date: Tue, 04 Apr 2017 20:04:44 +1000
Message-ID: <87pogsv683.fsf@concordia.ellerman.id.au>
References: <20170330051313.31358-1-matthew.brown.dev@gmail.com>
 <877f31n2mn.fsf@possimpible.ozlabs.ibm.com>
 <87wpb1kvy7.fsf@possimpible.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <87wpb1kvy7.fsf@possimpible.ozlabs.ibm.com>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
To: Daniel Axtens <dja@axtens.net>, Matt Brown <matthew.brown.dev@gmail.com>, linux-raid@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org
List-Id: linux-raid.ids

Daniel Axtens <dja@axtens.net> writes:

>> In that function, the flow is:
>>  pagefault_disable();
>>  enable_kernel_altivec();
>>  <vectorised function>
>>  pagefault_enable();
>>
>> There are a few things that it would be nice (but by no means essential)
>> to find out:
>>  - what is the difference between pagefault and prempt enable/disable
>>  - is it required to disable altivec after the end of the function or
>>    can we leave that enabled?
>
> Answering my own question here, dc4fbba11e46 ("powerpc: Create
> disable_kernel_{fp,altivec,vsx,spe}()") adds the disable_ function, and
> it's a no-op except under debug conditions. So it should stay.

Yeah enabling altivec for use in the kernel requires saving the
userspace altivec state first (so we don't clobber it).

But once we've enabled it in the kernel, we can just leave it enabled
until we return to userspace and save the cost of disabling it. There's
a small risk that leaving altivec enabled allows some other kernel code
to use altivec when it shouldn't, hence the debug option to make
disable_kernel_altivec() actually disable it.

cheers

From: Anshuman Aggarwal <anshuman.aggarwal@gmail.com>
Subject: Re: raid array not auto restarting
Date: Sun, 23 Aug 2009 21:02:09 +0530
Message-ID: <5c45fce80908230832h3728daf5x7c2636c3cb892deb@mail.gmail.com>
References: <5c45fce80908230649y4acc48acxefc8a4bef698e860@mail.gmail.com>
	 <20090823135530.GA9860@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090823135530.GA9860@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I ran update-initramfs -u to update (which should work for ubuntu
jaunty)...should it be needed, since my root partition is not on raid?
I didn't need to do it so far with any other cluster change?

2009/8/23 Robin Hill <robin@robinhill.me.uk>:
> On Sun Aug 23, 2009 at 07:19:44PM +0530, Anshuman Aggarwal wrote:
>
>> Although its not a show stopper, would really appreciate some help o=
n this.
>>
>> My raid arrays don't start up automatically like they used to after =
I
>> grew them to include the 4th disk (yes, I DID modify the mdadm.conf =
so
>> I'm not sure what's not working here)
>> Kernel: 2.6.30.4; mdadm 3.0 (are there any other libraries whose
>> version I should be checking also, since I manually upgraded Ubuntu
>> Jaunty to mdadm 3.0)
>>
> <-snip->
>>
>> This array starts fine when I do the following:
>>
>> mdadm -S /dev/md_d1*
>> mdadm -A -s
>>
>> So, if the scan works without any changes in the mdadm, then why
>> doesn't it work at boot time?
>>
> Have you updated the initrd so the new mdadm.conf is available at boo=
t?
>
> Cheers,
> =A0 =A0Robin
> --
> =A0 =A0 ___
> =A0 =A0( ' } =A0 =A0 | =A0 =A0 =A0 Robin Hill =A0 =A0 =A0 =A0<robin@r=
obinhill.me.uk> |
> =A0 / / ) =A0 =A0 =A0| Little Jim says .... =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0|
> =A0// !! =A0 =A0 =A0 | =A0 =A0 =A0"He fallen in de water !!" =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 |
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

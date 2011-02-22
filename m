From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: Two questions about stripe_cache_size
Date: Tue, 22 Feb 2011 19:26:48 -0300
Message-ID: <AANLkTimN47c6pKU0fM0==E54mozYhtWg3jGy5ALib+HM@mail.gmail.com>
References: <AANLkTi=bvRBoyUCH+9_9ZTjrWKdqjkfzpnNtdhmvgYCk@mail.gmail.com>
	<20110223090105.4be62a1e@notabene.brown>
	<AANLkTin-Ub0PAvdWDQwzqUyvzVDKia5FGGpyK4ip_=Lo@mail.gmail.com>
	<20110223092422.230875fa@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110223092422.230875fa@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "Patrick J. LoPresti" <lopresti@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

could we select it with sysfs?

2011/2/22 NeilBrown <neilb@suse.de>:
> On Tue, 22 Feb 2011 14:13:14 -0800 "Patrick J. LoPresti" <lopresti@gm=
ail.com>
> wrote:
>
>> Thanks, Neil. =A0Actually, I think I have one more question... =A0(W=
ell,
>> one question with many faces.)
>>
>> Is the stripe cache write-back, or write-through? =A0If the latter, =
when
>> does it get flushed to disk, exactly?
>>
>
> Write-through.
>
> However I am tempted to make it write-back as filesystems now submit =
'flush'
> requests which can be used to flush the cache. =A0I wonder if you wou=
ld be able
> to notice any performance difference...
>
> NeilBrown
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

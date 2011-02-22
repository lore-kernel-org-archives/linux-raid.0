From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: Two questions about stripe_cache_size
Date: Tue, 22 Feb 2011 19:10:13 -0300
Message-ID: <AANLkTimUCLb6RCDAF1+ppXVV87QdK25_fgoa_1-V31jJ@mail.gmail.com>
References: <AANLkTi=bvRBoyUCH+9_9ZTjrWKdqjkfzpnNtdhmvgYCk@mail.gmail.com>
	<20110223090105.4be62a1e@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110223090105.4be62a1e@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "Patrick J. LoPresti" <lopresti@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

could add ' pages' or ' kB' after number? just to know what=B4s unit

2011/2/22 NeilBrown <neilb@suse.de>:
> On Tue, 22 Feb 2011 13:46:57 -0800 "Patrick J. LoPresti" <lopresti@gm=
ail.com>
> wrote:
>
>> (Thanks to Piergiorgio Sartor for pointing out this setting to me.)
>>
>> I am looking for documentation on /sys/block/mdX/md/stripe_cache_siz=
e.
>> =A0Specifically:
>>
>> 1) What are the units of this attribute?
>
> Pages per device (1 page is 4K normally)
>
>>
>> 2) I see it is supported for RAID 5. =A0Is it supported for RAID 6?
>
> Yes.
>
> NeilBrown
>
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

From: CoolCold <coolthecold@gmail.com>
Subject: Re: md metadata nightmare
Date: Wed, 23 Nov 2011 19:35:45 +0400
Message-ID: <CAGqmV7oOMKQ1Tj+6dcHN2GQujbpWUavJxT9rqyM-7W_2a-Ci4A@mail.gmail.com>
References: <CADzwnhXWvkVC13ZEJj8L0O6PLXLS6uhoBXqoLp67YwmeU60sQQ@mail.gmail.com>
	<20111123114743.1085889e@notabene.brown>
	<4ECC6D9C.8050009@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4ECC6D9C.8050009@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: NeilBrown <neilb@suse.de>, Kenneth Emerson <kenneth.emerson@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Nov 23, 2011 at 7:50 AM, Phil Turmel <philip@turmel.org> wrote:
> Hi Ken,
>
> On 11/22/2011 07:47 PM, NeilBrown wrote:
>> On Tue, 22 Nov 2011 18:05:21 -0600 Kenneth Emerson
> [...]
>> Assuming nothing has changed since the "--detail" output you provide=
d, you
>> should:
>>
>> =A0mdadm -S /dev/md3
>> =A0mdadm -C /dev/md3 --metadata=3D1.0 --chunk=3D64k --level=3D6 --ra=
id-devices=3D5 \
>> =A0 =A0 =A0 missing /dev/sdb4 /dev/sdc4 /dev/sda4 /dev/sdd4 \
>> =A0 =A0 =A0 --assume-clean
>>
>> The order of the disks is import. =A0You should compare it with the =
output
>> of "mdadm --detail" before you start to ensure that it is correct an=
d I have
>> made any typos. =A0You should of course check the rest as well.
>> After doing this (and possibly before) you should 'fsck' to ensure t=
he
>> transition was successful. =A0If anything goes wrong, ask before ris=
king
>> further breakage.
>

> A word of warning... =A0the shell notation /dev/sd[bcad]4, which you =
might be
> tempted to type in the above command line, *will* *not* *work*. =A0Ba=
sh reorders
> the [bcad] to [abcd], dropping nonexistent names. =A0You might know t=
his, and
> not be burned, but others on the list have been. =A0Use {b,c,a,d} to =
stay safe.
Thanks, may be you saved my data in future uses ;)
>
> HTH,
>
> Phil
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Best regards,
[COOLCOLD-RIPN]
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

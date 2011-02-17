From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: md road-map: 2011
Date: Wed, 16 Feb 2011 23:30:43 -0200
Message-ID: <AANLkTinDMbZ7oTwPYTxuhw3VTOWq14POoiuaeTF4acku@mail.gmail.com>
References: <20110216212751.51a294aa@notabene.brown>
	<4D5BB4EA.8030907@texsoft.it>
	<AANLkTikiP+PTJzpQomr++4d0chRww3gOq0R-J2-vaQ1-@mail.gmail.com>
	<20110216140024.GA18707@cthulhu.home.robinhill.me.uk>
	<AANLkTikeGuar5eBb7fv3+bLt=Z=bM9Zt7LfKeshxxJ9U@mail.gmail.com>
	<AANLkTi=DpeH0Ba2T_wJHuSYXzORpfW5W42SP6bUkBf-f@mail.gmail.com>
	<20110217085505.1deec298@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110217085505.1deec298@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Giovanni Tessore <giotex@texsoft.it>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

=3D] i agree with you on all cases :) the idea of a generic raid10 for
raid1,0,10 isn't good for low cpu/ram (in other words increase
performace)
know i understand why raid10 raid1 raid0 are diferent files and raid456=
 only one

let=B4s try the option2:
could we implement layout/offset to raid1?
it=B4s a read performace improvement (maybe write problem)
for example, odd sectors on start of disk1 and end of disk2, even
sectors on end of disk1 and start of disk2 or another layouts like
raid10

2011/2/16 NeilBrown <neilb@suse.de>:
> On Wed, 16 Feb 2011 11:21:50 -0300 Roberto Spadim <roberto@spadim.com=
=2Ebr>
> wrote:
>
>> since we have the option1 done, why continue with raid1 code? could =
we
>> port write-behind to raid10 code?
>
> No. =A0write-behind depends on write-mostly, and write-mostly only re=
ally makes
> sense for RAID1. =A0I much prefer to keep these two code bases separa=
te.
>
>> another thing, could raid10 work without replica? like a raid0?
>
> Why don't you try it? =A0Choose a layout that asks for only 1 copy of=
 the data.
> It should work.
>
>>
>> why? just to remove many files with the same function (raid1and raid=
0,
>> if raid10 do the same work, many some mdadm changes allow us to
>> --level=3D1 to understand that's raid10 without stripe, --level=3D0 =
is
>> raid10 without mirrors)
>
> Again, RAID0 has some features that RAID10 doesn'tand cannot. =A0I su=
ggest you
> read man pages (e.g. 'man md') to find out the details.
>
> Also the RAID0 code is much simpler and hence possibly faster.
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

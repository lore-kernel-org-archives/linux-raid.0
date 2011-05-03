From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: Mirrored volume peformance questions
Date: Tue, 3 May 2011 18:40:41 -0300
Message-ID: <BANLkTinKcGj81BNFhp=zQv4o+dW4nT=zMw@mail.gmail.com>
References: <96B30EF4F3E17749BCFF7F1816090EDA02DCE41A87@EX-SEA31-B.ant.amazon.com>
	<BANLkTikcVPQwFEancNbOkKvdHTwdHDb=XA@mail.gmail.com>
	<20110503213430.GC24265@www2.open-std.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110503213430.GC24265@www2.open-std.org>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@keldix.com>
Cc: "Morad, Steve" <morad@amazon.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

near/offset i think it=B4s the same (near) speed
i=B4m checking this:
https://raid.wiki.kernel.org/index.php/Performance

and some tests i did

2011/5/3 Keld J=F8rn Simonsen <keld@keldix.com>:
> On Tue, May 03, 2011 at 04:52:07PM -0300, Roberto Spadim wrote:
>> 2011/5/3 Morad, Steve <morad@amazon.com>:
>> > I have a few questions about volume mirroring performance implicat=
ions.
>> >
>>
>> > 2. Similarly, would a RAID10 configuration give me the same (or be=
tter) read behavior across these same disks, while providing twice the =
storage capacity of the above configuration?
>
> RAID10 and RAID1 gives the same storage capacity with the same disks.
>
> Linux MD RAID10 is actually just another way of doing raid1-like
> layouts.
>
>
>> in md world
>> raid1+ raid0 !=3D raid10
>>
>> raid10 can use layouts
>> raid1 can?t
>>
>> raid10 have diferent read_balance algorithms than raid1
>> raid10 with far layout is better optimized for sequencial read (it?s
>> like raid0 stripe)
>> raid10 with near/offset layoute are better optimized for multthread
>
> Hmm, raid10 near, offset and far are about the same for multithread,
> according to several benchmarks. Actually the far layout has signific=
ant
> better random read performance than the near layout in some thests,
> about 25 % better speed, and about 100 % bettter speed than raid1.
>
> best regards
> keld
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

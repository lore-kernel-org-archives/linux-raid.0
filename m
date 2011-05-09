From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: wish for Linux MD mirrored raid types
Date: Mon, 9 May 2011 11:48:33 -0300
Message-ID: <BANLkTi=nKOE5_nVoaLgnYf7uRb_cBqFLcg@mail.gmail.com>
References: <20110506071752.GA22063@www2.open-std.org>
	<BANLkTikrayzREAhX5XrHda8iWeGLZFpUFg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTikrayzREAhX5XrHda8iWeGLZFpUFg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Emmanuel Noobadmin <centos.admin@gmail.com>
Cc: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@keldix.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

:) yes, i didn't like the idea, and raid1 at linux can have many
mirrors not only 3...
the point here is:

raid1 isn't a industrial internacional name at linux eheh
raid1 is a module at linux kernel
raid10 is another module at linux kernel
raid10 and raid1 are part of md, so... don't check internacional
industry documentation to understand what raid1 and raid10 linux
modules are... check linux documentation

raid1 have write-behind and write-mostly, raid10 don't
there's different codes for raid10 and raid1, you must check
raid1 is an easy code, very simple
raid10 is more complex, with many layouts

i think the point here is a feature request to allow raid1 some
layouts, but... i think that's badblocks and others todo are more
important, users can use raid10 if they want different layouts, and...
they can code too... a patch is very welcome



2011/5/9 Emmanuel Noobadmin <centos.admin@gmail.com>:
> On 5/6/11, Keld J=F8rn Simonsen <keld@keldix.com> wrote:
>> Hi List
>>
>> based on the recent discussion, that showed lacking knowledge
>> on Linux MD RAID10 features, I have some thoughts:
>>
>> It is really hard to disseminate information on "new" features
>> in MD RAID. RAID10 has been in the kernel since 2.6.9 - from 2004.
>> I have tried to give info on RAID10 at a number of web pages,
>> and still many people, even on our linux-raid list are not aware
>> of it.
>>
>> Also many people are confused about Linux MD raid10 and RAID1+0.
>>
>> So I think we shopuld rather name things in another way.
>>
>> I would like linux MD raid10 functionality to be part of the Linux M=
D
>> RAID1 module, and be called raid1. This is in accordance with the
>> use of the RAID1 term as standadized by SNIA. In fact the RAID10-off=
set
>> layout is an implementation of a SNIA RAID specification. The RAID10=
-near
>> layout is an implementation of a simple RAID layout. And the RAID10-=
far
>> layout is just another layout far a mirrored RAID. =A0So all these t=
ypes
>> could just be defined as different RAID1 layouts.
>
> Giving my noob's 2 cents worth although I haven't followed the
> original discussion. As a noob, =A0I think doing this will just confu=
se
> us more.
>
> There are plenty of existing materials around for those of us who try
> to figure things out by googling. As it is, our (or maybe just me)
> understanding is Linux RAID 1 is just like every other raid 1: simple
> and straightforward, 2 drives mirroring each other.
>
> This is is also usually the level that most of us start with. If the
> instructions are short, easy to understand and simple to implement, w=
e
> usually gain confidence in using it and exploring mdraid further.
>
> Most of us noobs are also aware that RAID 10 is more complicated and
> there are two versions, i.e. 1+0 and 0+1. So psychologically, I had n=
o
> problems accepting that once I looked into it, there were much more
> complex stuff and all these possible layouts: mdraid is cool!
>
> Now, if RAID 10 was renamed to RAID 1, with the corresponding change
> in documentation, what's going to happen for us noobs is this: "Omg,
> why are there so many different versions and options just for raid 1?=
"
> and importantly "Why is this manual/wiki different from the tons of
> other pages about using mdraid 1?" For some, this would mean mdraid i=
s
> too difficult even for raid 1, mdraid is not cool! :)
>
> So newbies will get more confused/frustrated as a result.
>
> Personally, I had to spend some time figuring out (I'm noob and I'm
> not very smart) the different layouts from the examples on wiki. This
> is because there wasn't enough examples, at least to me, to clearly
> show what's the difference if more/less disks were used. So for me,
> and other noobs, it would probably help if the wiki had more examples
> of each layout, maybe graphics to show the difference since it's
> probably easier to see things if they were colour coded blocks rather
> than stuff like A1 a1 A2 a2.
>
> This and perhaps more elaboration on the difference between mdraid 10
> and normal raid 10 =A0would probably be better to clear up confusion
> than renaming something we might have some familiarity with, into
> something we also already have familiarity, resulting in something
> that contradicts existing familiarity.
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

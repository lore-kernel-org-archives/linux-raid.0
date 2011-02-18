From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: mdadm / force parity checking of blocks on all reads?
Date: Fri, 18 Feb 2011 02:34:32 -0200
Message-ID: <AANLkTim+WX1tWFmqAqt9C6U84ootdVmHtK4YSHEjtCJ1@mail.gmail.com>
References: <4D5DD3C0.3020804@chaven.com>
	<20110218142536.04d35fe5@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110218142536.04d35fe5@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Steve Costaras <stevecs@chaven.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

put a lot of raid1 devices eheheh, but i don=B4t know if it=B4s a good
idea... maybe... change your hardware and try another more mature
filesystem
maybe a solution of raid+lvm+filesystem is a better solution, with lvm
you can online backup

2011/2/18 NeilBrown <neilb@suse.de>:
> On Thu, 17 Feb 2011 20:04:48 -0600 Steve Costaras <stevecs@chaven.com=
> wrote:
>
>>
>>
>> I'm looking at alternatives to ZFS since it still has some time to g=
o
>> for large scale deployment as a kernel-level file system (and brtfs =
has
>> years to go). =A0 I am running into problems with silent data corrup=
tion
>> with large deployments of disks. =A0 =A0Currently no hardware raid v=
endor
>> supports T10 DIF (which even if supported would only work w/ SAS/FC
>> drives anyway) nor does read parity checking.
>
> Maybe I'm just naive, =A0but find it impossible to believe that "sile=
nt data
> corruption" is ever acceptable. =A0 You should fix or replace your ha=
rdware.
>
> Yes, I know silent data corruption is theoretically possible at a ver=
y low
> probability and that as you add more and more storage, that probabili=
ty gets
> higher and higher.
>
> But my point is that the probability of unfixable but detectable corr=
uption
> will ALWAYS be much (much much) higher than the probability of silent=
 data
> corruption (on a correctly working system).
>
> So if you are getting unfixable errors reported on some component, re=
place
> that component. =A0And if you aren't then ask your vender to replace =
the
> system, because it is broken.
>
>
>>
>> I am hoping that either there is a way that I don't know of to enabl=
e
>> mdadm to read the data plus p+q parity blocks for every request and
>> compare them for accuracy (simlar to what you need to do for a scrub=
 but
>> /ALWAYS/) or have the functionality added as an option.
>
> No, it is not currently possible to do this, nor have I plan to imple=
ment
> it. =A0I guess it would be possible in theory though.
>
> NeilBrown
>
>
>>
>> With the current large capacity drives we have today getting bit err=
ors
>> is quite common (I have some scripts that I do complete file checks
>> every two weeks across 50TB arrays and come up with errros every
>> month). =A0 I'm looking at expanding to 200-300TB volumes shortly so=
 the
>> problem will only get that much more frequent. =A0 =A0 Being able to=
 check
>> the data against parity will be able to find/notify and correct erro=
rs
>> at read time before they get to user space. =A0 This fixes bit rot a=
s well
>> as torn/wild reads/writes and mitigates transmission issues.
>>
>> I searched the list but couldn't find this benig discussed before, i=
s
>> this possible?
>>
>> Steve Costaras
>> stevecs@chaven.com
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
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

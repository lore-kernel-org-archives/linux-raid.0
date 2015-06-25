From: tlknv <tlknv@yandex.ru>
Subject: Re: mismatch_cnt constantly goes up on ssd+hdd raid1
Date: Thu, 25 Jun 2015 18:33:16 +0300
Message-ID: <2762371435246396@web9o.yandex.ru>
References: <3700381434301996@web21o.yandex.ru>
	<20150625113335.7bf72b0b@noble>
	<20150625101959.23981c72@natsu> <20150625172530.5c5338b6@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150625172530.5c5338b6@noble>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, Roman Mamedov <rm@romanrm.net>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil,
Thanks a lot for all the info and steps to identify the problem.

I have just discovered that I had 'discard' mount option even though I =
though it wasn't there :-(
After removing 'discard' and forcing 'repair' mismatch_cnt stays 0 even=
 after a bunch of writes and deletes (the most importantly) to the part=
ition. BTW, what are the units in mismatch_cnt? Is it 512 sectors or so=
mething else?
AFAIU md could potentially collect info on trimmed sectors/blocks and e=
xclude them from mismatch checking. Could not it?

I'll look at the range of the sectors which are different even when mis=
match_cnt is 0.

Thanks again,
Boris

25.06.2015, 10:25, "NeilBrown" <neilb@suse.com>:
> =9AOn Thu, 25 Jun 2015 10:19:59 +0500 Roman Mamedov <rm@romanrm.net> =
wrote:
>
>> =9A=9AOn Thu, 25 Jun 2015 11:33:35 +1000
>> =9A=9ANeilBrown <neilb@suse.com> wrote:
>>
>> =9A=9A> On Sun, 14 Jun 2015 20:13:16 +0300 tlknv <tlknv@yandex.ru> w=
rote:
>> =9A=9A>
>> =9A=9A> > Hello,
>> =9A=9A>
>> =9A=9A> > I have raid 1 which mirrors a root/boot partition on 1SSD =
and 2HDD
>> =9A=9A> > (write-mostly). mismatch_cnt goes up even when there are v=
ery few
>> =9A=9A> > writes to the partition as /var is mounted separatly. Afte=
r I update
>> =9A=9A> > several packages I typically see mismatch_cnt somewhere be=
tween
>> =9A=9A> > 500,000 and 2,000,000. I have read a number of threads in =
this DL
>> =9A=9A> > but could not find an explanation of what could cause mism=
atch_cnt
>> =9A=9A> > to grow that much. I checked md5 sums using
>> =9A=9A> > /var/lib/dpkg/info/*.md5sums, and didn't see many errors, =
even
>> =9A=9A> > though there are few, mostly in text files which look ok t=
o me. I
>> =9A=9A> > guess when I check, all reads go to SSD (as both HDDs in t=
his raid
>> =9A=9A> > are write-mostly), and thus md5sum only shows no problem o=
n
>> =9A=9A> > SSD. Note, this partition is used as both boot and root an=
d just in
>> =9A=9A> > case here is some more info about my system:
>> =9A=9A>
>> =9A=9A> This does surprise me.
>> =9A=9A>
>> =9A=9A> I had another look at the code and there could be a bug that=
 would let
>> =9A=9A> 'check' see the difference between when the first write comp=
letes and
>> =9A=9A> when the write-behind writes complete, but you would need to=
 run the
>> =9A=9A> check while the install was happening for that to be noticed=
, and even
>> =9A=9A> then you would need to be unlucky.
>>
>> =9A=9ACouldn't this be simply the normal observed effect of using TR=
IM on SSD?
>
> =9AYes, of course it could. I try not to think about TRIM to much - m=
akes me ill :-)
>
> =9AThanks,
> =9ANeilBrown
>
>> =9A=9AAfter deleting some files, the filesystem issues a discard req=
uest, it
>> =9A=9Adoes nothing to the HDDs, but the content of the discared area=
s on SSD is no
>> =9A=9Alonger deterministic (or mostly zeroed, as mentioned in the or=
iginal report).
>> =9A=9ASo there is now a mismatch between the content of HDDs and SSD=
, but since it
>> =9A=9Ais in the area of deleted files, it doesn't affect the system =
in any way.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

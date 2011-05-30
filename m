From: "fibreraid@gmail.com" <fibreraid@gmail.com>
Subject: Re: Optimizing small IO with md RAID
Date: Mon, 30 May 2011 08:24:04 -0700
Message-ID: <BANLkTikw9cqfhHAVaxZ2T2EErroCMT5Zow@mail.gmail.com>
References: <BANLkTi=236kncpunzodSci-1K33u_FBkPA@mail.gmail.com>
	<irvuj1$rc3$1@dough.gmane.org>
	<4DE38628.1050201@anonymous.org.uk>
	<is04s2$2rn$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <is04s2$2rn$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david@westcontrol.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi All,

I appreciate the feedback but most of it seems around File System
recommendations or to change to parity-less RAID, like RAID 10. In my
tests, there is no file system; I am testing the raw block device as I
want to establish best-numbers there before layering on the file
system.

-Tommy


On Mon, May 30, 2011 at 6:08 AM, David Brown <david@westcontrol.com> wr=
ote:
> On 30/05/2011 13:57, John Robinson wrote:
>>
>> On 30/05/2011 12:20, David Brown wrote:
>>>
>>> (This is in addition to what Stan said about filesystems, etc.)
>>
>> [...]
>>>
>>> Try your measurements with a raid10,far setup. It costs more on dat=
a
>>> space, but should, I think, be quite a bit faster.
>>
>> I'd also be interested in what performance is like with RAID60, e.g.=
 4
>> 6-drive RAID6 sets, combined into one RAID0. I suggest this arrangem=
ent
>> because it gives slightly better data space (33% better than the RAI=
D10
>> arrangement), better redundancy (if that's a consideration[1]), and
>> would keep all your stripe widths in powers of two, e.g. 64K chunk o=
n
>> the RAID6s would give a 256K stripe width and end up with an overall
>> stripe width of 1M at the RAID0.
>>
>
> Power-of-two stripe widths may be better for xfs than non-power-of-tw=
o
> widths - perhaps Stan can answer that (he seems to know lots about xf=
s on
> raid). =A0But you have to be careful when testing and benchmarking - =
with
> power-of-two stripe widths, it's easy to get great 4 MB performance b=
ut
> terrible 5 MB performance.
>
>
> As for the redundancy of raid6 (or 60) vs. raid10, the redundancy is
> different but not necessarily better, depending on your failure types=
 and
> requirements. =A0raid6 will tolerate any two drives failing, while ra=
id10 will
> tolerate up to half the drives failing as long as you don't lose both=
 halves
> of a pair. =A0Depending on the chances of a random disk failing, if y=
ou have
> enough disks then the chances of two disks in a pair failing are less=
 than
> the chances of three disks in a raid6 setup failing. =A0And raid10 su=
ffers
> much less from running in degraded mode than raid6, and recovery is f=
aster
> and less stressful. =A0So which is "better" depends on the user.
>
> Of course, there is no question about the differences in space effici=
ency -
> that's easy to calculate.
>
> For greater paranoia, you can always go for raid15 or even raid16...
>
>> You will probably always have relatively poor small write performanc=
e
>> with any parity RAID for reasons both David and Stan already pointed
>> out, though the above might be the least worst, if you see what I me=
an.
>>
>> You could also try 3 8-drive RAID6s or 2 12-drive RAID6s but you'd
>> definitely have to be careful - as Stan says - with your filesystem
>> configuration because of the stripe widths, and the bigger your pari=
ty
>> RAIDs the worse your small write and degraded performance becomes.
>>
>> Cheers,
>>
>> John.
>>
>> [1] RAID6 lets you get away with sector errors while rebuilding afte=
r a
>> disc failure. In addition, as it happens, setting up this arrangemen=
t
>> with two drives on each controller for each of the RAID6s would mean=
 you
>> could tolerate a controller failure, albeit with horrible performanc=
e
>> and you would have no redundancy left. You could configure smaller
>> RAID6s or RAID10 to tolerate a controller failure too.
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

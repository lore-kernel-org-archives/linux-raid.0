From: Marcus Sorensen <shadowsor@gmail.com>
Subject: Re: md RAID with enterprise-class SATA or SAS drives
Date: Thu, 10 May 2012 09:26:19 -0600
Message-ID: <CALFpzo6BECrv2eTbSRKwUzpTopx_0EmD+UipqUf-XE=vzz2OnQ@mail.gmail.com>
References: <4FAAE8F1.8000600@pocock.com.au>
	<CALFpzo5ObdwFATdT4e20znnxzU5hX9SVSfqJcdqOXM1FEYJQuw@mail.gmail.com>
	<4FABC7C6.4030107@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FABC7C6.4030107@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Daniel Pocock <daniel@pocock.com.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, May 10, 2012 at 7:51 AM, Phil Turmel <philip@turmel.org> wrote:
> I'm afraid I have to disagree with Marcus ...
>
> And other observations ...
>
> On 05/09/2012 06:33 PM, Marcus Sorensen wrote:
>> I can't speak to all of these, but...
>>
>> On Wed, May 9, 2012 at 4:00 PM, Daniel Pocock <daniel@pocock.com.au>=
 wrote:
>>>
>>>
>>> There is various information about
>>> - enterprise-class drives (either SAS or just enterprise SATA)
>>> - the SCSI/SAS protocols themselves vs SATA
>>> having more advanced features (e.g. for dealing with error conditio=
ns)
>>> than the average block device
>>>
>>> For example, Adaptec recommends that such drives will work better w=
ith
>>> their hardware RAID cards:
>>>
>>> http://ask.adaptec.com/cgi-bin/adaptec_tic.cfg/php/enduser/std_adp.=
php?p_faqid=3D14596
>>> "Desktop class disk drives have an error recovery feature that will
>>> result in a continuous retry of the drive (read or write) when an e=
rror
>>> is encountered, such as a bad sector. In a RAID array this can caus=
e the
>>> RAID controller to time-out while waiting for the drive to respond.=
"
>
> Linux direct drivers will also time out in this case, although the
> driver timeout is adjustable. =A0Default is 30 seconds, while desktop
> drives usually keep trying to recover errors for minutes at a time.
>
>>> and this blog:
>>> http://www.adaptec.com/blog/?p=3D901
>>> "major advantages to enterprise drives (TLER for one) ... opt for t=
he
>>> enterprise drives in a RAID environment no matter what the cost of =
the
>>> drive over the desktop drive"
>
> Unless you find drives that support SCTERC, which allows you to tell
> the drives to use a more reasonable timeout (typically 7 seconds).
>
> Unfortunately, SCTERC is not a persistent parameter, so it needs to b=
e
> set on every powerup (udev rule is the best).

See smartctl for more info on how to do this. I think 5.40 has this,
although as far as I'm aware, the only desktop drives that allow you
to set a timeout are the Hitachi deskstar. Trunk also has an APM patch
(provided by me :-) that allows you to adjust head parking/drive sleep
times, if supported, for those who care.

>
>>> My question..
>>>
>>> - does Linux md RAID actively use the more advanced features of the=
se
>>> drives, e.g. to work around errors?
>>
>> TLER and its ilk simply give up quickly on errors. This may be good
>> for a RAID card that otherwise would reset itself if it doesn't get =
a
>> timely response from a drive, but it can be bad for md RAID. It
>> essentially increases the chance that you won't be able to rebuild,
>> you lose drive A of a 2 x 3TB RAID 1, and then during rebuild drive =
B
>> has an error and the disk gives up after 7 seconds, rather than doin=
g
>> all of its fancy off-sector reads and whatever else it would normall=
y
>> do to save your last good copy.
>
> Here is where Marcus and I part ways. =A0A very common report I see o=
n
> this mailing list is people who have lost arrays where the drives all
> appear to be healthy. =A0Given the large size of today's hard drives,
> even healthy drives will occasionally have an unrecoverable read erro=
r.
>
> When this happens in a raid array with a desktop drive without SCTERC=
,
> the driver times out and reports an error to MD. =A0MD proceeds to
> reconstruct the missing data and tries to write it back to the bad
> sector. =A0However, that drive is still trying to read the bad sector=
 and
> ignores the controller. =A0The write is immediately rejected. =A0BOOM=
! =A0The
> *write* error ejects that member from the array. =A0And you are now
> degraded.
>
> If you don't notice the degraded array right away, you probably won't
> notice until a URE on another drive pops up. =A0Once that happens, yo=
u
> can't complete a resync to revive the array.
>
> Running a "check" or "repair" on an array without TLER will have the
> opposite of the intended effect: any URE will kick a drive out instea=
d
> of fixing it.
>
> In the same scenario with an enterprise drive, or a drive with SCTERC
> turned on, the drive read times out before the controller driver, the
> controller never resets the link to the drive, and the followup write
> succeeds. =A0(The sector is either successfully corrected in place, o=
r
> it is relocated by the drive.) =A0No BOOM.
>

Agreed. In the past there has been some debate about this. I think it
comes down to your use case, the data involved and what you expect.
TLER/ERC can generally make your array more durable to minor hiccups,
and is likely preferred if you can stomach the cost, at the potential
risk that I described.  If the failure is a simple one-off read
failure, then Phil's scenario is very likely. If the drive is really
going bad (say hitting max_read_errors), then the disk won't try very
hard to recover your data, at which point you have to hope the other
drive doesn't have even a minor read error when rebuilding, because it
also will not try very hard. In the end it's up to you what behavior
you want.

Here are a few odd things to consider, if you're worried about this top=
ic:

* Using smartctl to increase the ERC timeout on enterprise SATA
drives, say to 25 seconds, for use with md. I have no idea if this
will cause the drive to actually try different methods of recovery,
but it could be a good middle ground.

* increasing max_read_errors in an attempt to keep a TLER/ERC disk in
the loop longer. The only reason to do this would be if you were
proactive in monitoring said errors and could add in more redundancy
before pulling the failing drive, thus increasing your chances that
the rebuild succeeds, having more *mostly* good copies.

* Increasing the SCSI timeout on your desktop drives to 60 seconds or
more, giving the drive a chance to succeed in deep recovery. This may
cause IO to block for awhile, so again it depends on your usage
scenario.

* frequent array checks - perhaps in combination with the above, can
increase the likelihood that you find errors in a timely manner and
increase the chances that the rebuild will succeed if you've only got
one good copy left.

I'm sure there's more, but you get the point. In the end it's simply
another testament to how flexible and configurable software RAID is.

>>> - if a non-RAID SAS card is used, does it matter which card is chos=
en?
>>> Does md work equally well with all of them?
>>
>> Yes, I believe md raid would work equally well on all SAS HBAs,
>> however the cards themselves vary in performance. Some cards that ha=
ve
>> simple RAID built-in can be flashed to a dumb card in order to recla=
im
>> more card memory (LSI "IR mode" cards), but the performance gain is
>> generally minimal
>
> Hardware RAID cards usually offer battery-backed write cache, which i=
s
> very valuable in some applications. =A0I don't have a need for that k=
ind
> of performance, so I can't speak to the details. =A0(Is Stan H.
> listening?)

I'm not aware of non-RAID SAS cards that provide writeback cache.  At
least none that are battery backed. However, many RAID cards will
allow you to create 1 disk RAID arrays that can be battery backed.
Even better, newer hardware RAID cards offer capacitor backup. They
include a flash module, with a capacitor that has enough juice to
write the contents from RAM to flash. This allows them to not require
the maintenance of batteries and to have a far longer retention time.

>
>>> - ignoring the better MTBF and seek times of these drives, do any o=
f the
>>> other features passively contribute to a better RAID experience whe=
n
>>> using md?
>>
>> Not that I know of, but I'd be interested in hearing what others thi=
nk.
>
> They power up with TLER enabled, where the desktop drives don't. =A0Y=
ou've
> excluded the MTBF and seek performance as criteria, which I believe a=
re
> the only remaining advantages, and not that important to light-duty
> users.
>
> The drive manufacturers have noticed this, by the way. =A0Most of the=
m
> no longer offer SCTERC in their desktop products, as they want RAID
> users to buy their more expensive (and profitable) drives. =A0I was b=
urned
> by this when I replaced some Seagate Barracuda 7200.11 1T drives (whi=
ch
> support SCTERC) with Seagate Barracude Green 2T drives (which don't).
>
> Neither Seagate nor Western Digital offer any desktop drive with any
> form of time-limited error recovery. =A0Seagate and WD were my "go to=
"
> brands for RAID. =A0I am now buying Hitachi, as they haven't (yet)
> followed their peers. =A0The "I" in RAID stands for "inexpensive",
> after all.

I keep hearing that, and I was always under the impression that the
"I" stood for "Independent", as you can do RAID with any independent
disk, cheap or expensive. Seems it was changed mid-90's. I suppose
both are accepted, but perhaps the one we use says something about our
level of seniority :-)

>
>>> - for someone using SAS or enterprise SATA drives with Linux, is th=
ere
>>> any particular benefit to using md RAID, dmraid or filesystem (e.g.
>>> btrfs) RAID (apart from the btrfs having checksums)?
>>
>> As opposed to hardware RAID? The main thing I think of is freedom fr=
om
>> vendor lock-in. If you lose your card you don't have to run around
>> finding another that is compatible with the hardware RAID's on-disk
>> metadata format that was deprecated last year. Last I checked,
>> performance was pretty great with md, and you can get fancy and spre=
ad
>> your array across multiple controllers and things like that. Finally=
,
>> md RAID tends to have a better feature set than the hardware, for
>> example N-disk mirrors. I like running a 3 way mirror over 2 way +
>> hotspare.
>
> Concur. =A0Software RAID's feature set is impressive, with great
> performance.
>
> FWIW, I *always* use LVM on top of my arrays, simply for the flexibil=
ity
> to re-arrange layouts on-the-fly. =A0Any performance impact that has =
has
> never bothered my small systems.
>
> HTH,
>
> Phil
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

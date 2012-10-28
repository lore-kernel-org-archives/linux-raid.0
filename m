From: Chris Murphy <lists@colorremedies.com>
Subject: Re: 3TB drives failure rate
Date: Sun, 28 Oct 2012 14:59:53 -0600
Message-ID: <A27BF034-F5B6-45A4-9381-3C0958457C57@colorremedies.com>
References: <11510711257.20121028131527@oudeis.org> <DB91871A-731F-44B4-9381-8FBF7D9CC3BF@colorremedies.com> <20121029015910.018efb17@natsu> <F548750F-8D0E-4D05-813B-58D85D652226@colorremedies.com> <20121029021643.1c9e3195@natsu> <46B8932A-58A5-4C1A-9C8C-DCCD5D3A1CD9@colorremedies.com> <20121029024956.30edb309@natsu>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121029024956.30edb309@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Oct 28, 2012, at 2:49 PM, Roman Mamedov <rm@romanrm.ru> wrote:

> On Sun, 28 Oct 2012 14:34:49 -0600
> Chris Murphy <lists@colorremedies.com> wrote:
>=20
>> A drive that can sit there like a bump on the log for 2 minutes befo=
re it issues an actual read failure on sector(s) means mdadm is likewis=
e waiting, and everything above it is waiting. That's a long hang. I'd =
not be surprised to see users go for hard reset with such a system hang=
 after 45 seconds let alone 2 minutes.
>=20
> Which is not different from what you would get (the same hang) in a n=
on-RAID
> environment on the same drive, so I don't see how this would be speci=
fically a
> RAID-related problem.

The difference is what you depend on running on that RAID. If it's some=
one playing movies or games, who cares. If you're a small business runn=
ing a database or web site off this hardware and everything crawls for =
two minutes, or implodes because of that delay, now it's just bad desig=
n.


>=20
>> Anyway, the idea mdadm users can't benefit from shorter ERC is untru=
e. They certainly can. But the open question is why would they be getti=
ng such long error recovery times in the first place? 7 seconds is a lo=
ng time.
>=20
> One thing is "benefit", i.e. just a comfort issue, to prevent pauses =
when a
> drive starts failing (but really=85 does that happen very often?

Yes. And obviously with a drive that delays this by 2 minutes it's goin=
g to be an increasing problem. Any wonder why "crazy" home users with t=
hese drives refer to determinalistic contraptions as "wow the computer =
is really slow lately" and then some geek blames it on fragmentation. I=
t would not surprise me if these drives are in deep recovery for critic=
al sectors.

If this were untrue, there'd be no need for short recovery times. As it=
 turns out it's a problem for any remotely serious RAID usage.


> and during
> those times do you really care so that there are no pauses for error =
recovery,
> or maybe you just want to replace the drive and still have your data =
safe?),
> and another thing is a complete RAID failure that you'd get with a
> hardware RAID controller simply because something is not within 7 sec=
onds,
> which is the whole source of that vendor-supported myth of "non-RAID =
drives".

Yeah a controller that totally fails a drive for a delayed recovery of =
one to a few sectors? Bad sysadmin. He picked the wrong drive or he pic=
ked the wrong drive timeout in the controller. Either way, it's a misma=
tch and he's a bad sysadmin if it's important data and not stolen movie=
s off the internet.

Chris Murphy

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

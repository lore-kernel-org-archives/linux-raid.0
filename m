From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: HBA Adaptor advice
Date: Sun, 22 May 2011 04:04:39 -0500
Message-ID: <4DD8D1A7.1090803@hardwarefreak.com>
References: <4DD50C89.8060006@wildgooses.com> <20110520020853.GC4759@bitfolk.com> <4DD61948.8050302@wildgooses.com> <4DD6409F.9070904@hardwarefreak.com> <4DD79F4E.7000509@wildgooses.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DD79F4E.7000509@wildgooses.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ed W <lists@wildgooses.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 5/21/2011 6:17 AM, Ed W wrote:
> Hi Stan
>=20
> Thanks for the time in composing your reply

Heh, I'm TheHardwareFreak, whaddya expect? ;)  Note the domain in my
email addy.

>> I'm curious why you are convinced that you need BBWC, or even simply=
 WC,
>> on an HBA used for md RAID.
>=20
> In the past I have used battery backed cards and where the write spee=
d
> is "fsync constrained" the writeback cache makes the app performance =
fly
> at perhaps 10-100x the speed

Ok, now that makes more sense.  This is usually the case with a hardwar=
e
RAID card or SAN controller, though depends on the
vendor/implementation.  I've never run one in 'JBOD' mode but with writ=
e
cache enabled, so I can't say if fsync behavior will be the same using
md RAID or not.  Maybe someone else has tested this.

> Only for a single reason: Its a small office server and I want the
> flexibility to move the drives to a different card (eg failed server,
> failed card or something else).  Buying a spare card changes the
> dynamics quite a bit when the whole server (sans raid card) only cost=
s
> =A31,000 ish?

If adding a real hardware RAID card and enterprise drives to a 'base'
server, the storage will nearly always cost more than the server,
especially with HP Proliant 1U quad core rack servers going for well
less than $1000 USD.  This has been reality for a few years now.

>   You may be
>> interested to know:
>>
>> 1.  When BBWC is enabled, all internal drive caches must be disabled=
=2E
>>     Otherwise you eliminate the design benefit of the BBU, and may a=
s
>>     well not have one.
>=20
> Yes, I hadn't thought of that.  Good point!
>=20
>> 2.  w/md RAID on an HBA, if you have a good UPS and don't suffer
>>     kernel panics, crashes, etc, you can disable barrier support in
>>     your FS and you can use the drive caches.
>=20
> I don't buy this...

Well, take into consideration that the vast majority of people running
md RAID arrays, including most, if not all, on this list, aren't using
hardware writeback cache.  They using plain Jane SAS/SATA HBAs.  Some
are using hybrid hardware arrays stitched together with md RAID stripin=
g
or concatenation.  But in those cases we're talking multiple tens of
thousands of dollars per system.

> In my limited experience hardware is pretty reliable and goes bad
> rarely.  However, my estimate is that powercables fall out, PSUs fail
> and UPSs go bad at least as often as the power fails?

*Quality* hardware today is very reliable.
Power cords *never* come lose in my experience, I don't allow it.
PSUs and UPSes fail at about the same rate as RAID cards, IME--*rarely*
Apparently Britain has a far better power grid than the States.

> Obviously it's application dependent, some may tolerate small datalos=
s
> in the event of powerdown, but I should think most people want a
> guarantee that the system is "recoverable" in the event of sudden
> powerdown.

There is always a tradeoff here between performance, resilience,
flexibility, and cost.  You currently have conflicting criteria in this
regard.  If you can afford all that you want, pick that which is most
important to eliminate the conflicts.  Then implement it.

> I think disabling barriers might not be the best way to avoid fsync
> delays, compared with the incremental cost of adding BBU writeback
> cache? (basically the same thing, but smaller chance of failure)

On the type of small office server you described, it's difficult to
grasp how performance is so critical.  You sound like a candidate for a
mixed SSD + SAS/SATA RAID setup.  Put things that require low latency,
such as the Postfix spool, Dovecot indexes, and MySQL tables on SSD, an=
d
put user data, such as IMAP mail directories, home directory files, etc=
,
on spinning RAID.  This way you get high performance and low cost.

> It depends on the application, but I claim that there is a fairly
> significant chance of hard unexpected powerdown even with a good UPS.
> You still are at risk from cables getting pulled, UPSs failing, etc

If cables getting yanked is a concern, you have human issues that must
be solved long before the technical aspects of system resiliency.  I've
not built/installed/used/serviced a pedestal server in over a decade.

> I think in a properly setup datacenter (racked) environment then it's
> easier to control these accidents. =20

We don't have "accidents" in our datacenters, not the homo sapien
initiated type you refer to.

> Cables can be tied in, layers of
> power backup can be managed, it becomes efficient to add quality
> surge/lightning protection, etc.  However, there is a large proportio=
n
> of the market that have a few machines in an office and now it's much
> harder to stop the cleaner tripping over the UPS, or hiding it under
> boxes of paper until it melts due to overheating...

Again, these types of problems can't be solved with technological means=
=2E

> I want BB writeback cache purely to get the performance of effectivel=
y
> disabling fsync, but without the loss of protection which occurs if y=
ou
> do so.

You can have it with some cards.  But, you will lose your ability to
swap the drives to a different make/model of HBA in the future.

> Everything is about optimisation of cost vs performance vs reliabilit=
y.

Yep.

>  Like everything else, my question is really about the tradeoff of a
> small incremental spend, which in turn might generate a substantial
> performance increase for certain classes of application.  Largely I'm
> thinking about performance tradeoffs for small office servers priced =
in
> the =A3500-3,000 kind of range (not "proper" high end storage devices=
)

'Proper' need not be 'high end' nor expensive.

> I think at that kind of level it makes sense to look for bargains,
> especially if you are adding servers in small quantities, eg singles =
or
> pairs.

Again, that's exactly what the parts I posted gives you.

>> Buy 12:
>> http://www.seagate.com/ww/v/index.jsp?name=3Dst91000640ss-constellat=
ion2-6gbs-sas-1-tb-hd&vgnextoid=3Dff13c5b2933d9210VgnVCM1000001a48090aR=
CRD&vgnextchannel=3Df424072516d8c010VgnVCM100000dd04090aRCRD&locale=3De=
n-US&reqPage=3DSupport#tTabContentSpecifications
>=20
> Out of curiosity I check the power consumption and reliability number=
s
> of the 3.5" "Green" drives and it's not so clear cut that the 2.5"
> drives outperform?

WD's Green drives have a 5400 rpm 'variable' spindle speed.  The Seagat=
e
2.5" SAS drive has a 7.2k spindle speed.

It's difficult to align partitions properly on the Green drives due to
native 4K sectors translated by drive firmware to 512B sectors.  The
Seagate SAS drive has native 512B sectors.

The Green drives have aggressive power saving firmware not suitable for
business use as the heads are auto parked every 8 seconds or so.  IIRC
the drive goes into sleep mode after a short period of inactivity on th=
e
host interface.  In short, these drives are designed optimally for the
"is not running" case rather than the "running" case.  Hence the name
"Green".  How do you save power?  Turn off the drive.  And that's
exactly what these drives are designed to do.

The Seagate 2.5" SAS drive has TLER support, the Green doesn't.  If you
go hardware RAID, you need TLER.  It's good to have for md RAID as well
but not a requirement.

Check the warranty difference between the Seagate SAS drive and the WD
Green.  Also note WD's 'RAID use' policy.

> Thanks for your thoughts - I think this thread has been very
> constructive - still very interested to hear good/bad reports of
> specific cards - perhaps someone might archive it into some kind of l=
ist?

I see RAID card shootouts now and then.  Google should find you
something.  Thought you won't see anyone testing Linux md RAID on a
hardware RAID card in JBOD mode.

--=20
Stan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

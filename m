From: Ian Dall <ian@beware.dropbear.id.au>
Subject: Re: Device kicked from raid too easilly
Date: Tue, 08 Jun 2010 14:45:54 +0930
Message-ID: <1275974154.4313.72.camel@sibyl.beware.dropbear.id.au>
References: <1275702714.3740.55.camel@sibyl.beware.dropbear.id.au>
	 <4C09FB3E.1090302@stud.tu-ilmenau.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C09FB3E.1090302@stud.tu-ilmenau.de>
Sender: linux-raid-owner@vger.kernel.org
To: st0ff@npl.de
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, 2010-06-05 at 09:22 +0200, Stefan /*St0fF*/ H=FCbner wrote:
> Hi Ian,
>=20
> I do not think this is md-related, nor related to the other dropout
> problem.  Here we have a write-error, which correctly makes the disk
> drop.  So if you say the error is kind of a soft error, then actually
> either the disks firmware or the scsi layer should be handling this.
>=20
> But as always on write errors: mostly there are more than one write
> request in the queue, so it's probably hard to find out which data
> couldn't be written, or the data has already been discarded.  Well,
> write errors are those that should be handled in Firmware...

Hmm. Well that is fair enough. I have struggled a bit in trying and
follow the path up and down all the various layers. I tried modifying
the scsi io completion to retry these errors but it wasn't a huge
success! It sometimes took a lot of retries (with the system seeming to
freeze for a few seconds), so it looks like it is a "firm" error!

Puzzlingly, swapping the disks around in the backplane works so long as
it is brand "A" in the first slot and not brand "B"! My current theory
is that there are transmission line effects (or maybe RFI) which make
some slots fall outside the range of the brand "B" disks to compensate!

One might think that sata would be better, but I am simultaneously
looking for a problem in another raid array which gives me sata CRC
errors which I assume to be cable related. Interestingly the sata
transport layer treats these CRC errors as soft (at least, there is no
corresponding action from md).

> P.S.: maybe you should check for firmware updates of the disks?

No such luck. These (brand "B") are "Worldisk" (which I believe to be
re-manufactured Fujitsu). The less troublesome disks (brand "A") are
Hitachi.

Thanks for your thoughts.

Regards,
Ian


> Am 05.06.2010 03:51, schrieb Ian Dall:
> > I think this is different to the similarly titled long thread on SA=
TA
> > timeouts.
> >=20
> > I have an array of U320 scsi disks with similar characteristics fro=
m two
> > different manufacturers.
> >=20
> > On two disks I see occasional scsi parity errors. I don't think thi=
s is
> > a cabling or termination issue since I never see the parity errors =
on
> > the other brand disks. smartctl shows a number of "non-medium error=
s"
> > which I take to be the paroty errors.
> >=20
> > Now, when I have a raid 10 of these disks, the scsi parity error ca=
uses
> > the first disk to be failed. The array then continues degraded with=
 no
> > apparent problems. If I read-add the failed disk, it always fails b=
efore
> > the re-sync is complete. Eg:
> >=20
> > Jun  3 23:35:02 fs kernel: md: recovery of RAID array md5
> > Jun  3 23:35:02 fs kernel: md: minimum _guaranteed_  speed: 1000 KB=
/sec/disk.
> > Jun  3 23:35:02 fs kernel: md: using maximum available idle IO band=
width (but not more than 200000 KB/sec) for recovery.
> > Jun  3 23:35:02 fs kernel: md: using 128k window, over a total of 2=
9291904 blocks.
> > Jun  3 23:35:07 fs kernel: sd 6:0:0:0: [sde] Result: hostbyte=3DDID=
_OK driverbyte=3DDRIVER_SENSE
> > Jun  3 23:35:07 fs kernel: sd 6:0:0:0: [sde] Sense Key : Aborted Co=
mmand [current]=20
> > Jun  3 23:35:07 fs kernel: sd 6:0:0:0: [sde] Add. Sense: Scsi parit=
y error
> > Jun  3 23:35:07 fs kernel: sd 6:0:0:0: [sde] CDB: Write(10): 2a 00 =
00 05 9e 00 00 01 00 00
> > Jun  3 23:35:07 fs kernel: end_request: I/O error, dev sde, sector =
368128
> > Jun  3 23:35:07 fs kernel: raid10: Disk failure on sde, disabling d=
evice.
> > Jun  3 23:35:07 fs kernel: raid10: Operation continuing on 3 device=
s.
> > Jun  3 23:35:07 fs kernel: md: md5: recovery done.
> >=20
> > Now I can test this disk in isolation (using iozone)  pretty heavil=
y and
> > never see a problem. I can also use it in a raid0 and never see a
> > problem.
> >=20
> > I think some of the strangeness is explained by the comment in the
> > raid10 error handler:  "else if it is the last working disks, ignor=
e the
> > error".
> >=20
> > Parity errors seem to me like they should be treated as transient
> > errors. Maybe if there are multiple consecutive parity errors it co=
uld
> > be assumed there is a hard fault in the transport layer. U320 uses
> > "information units" with (stronger than parity) CRC checking. Altho=
ugh
> > these errors are not reported as CRC errors that could just be a
> > reporting issue (the lack of an "additional sense code qualifier").
> > Given the complexity of the clock recovery de-skewing etc which goe=
s on
> > for U320, it is not surprising some disks would do it better than
> > others, but a non zero error rate probably shouldn't be considered
> > fatal.
> >=20
> > I don't really know where this should be fixed. Maybe the scsi laye=
r
> > should be retrying the scsi command, since it knows most about what=
 sort
> > of error it is. But equally it could be the responsibility of upper
> > layers to do any retrying (which gives upper layers the option to n=
ot
> > retry if they don't want to). But if the scsi layer is not responsi=
ble
> > for retrying these sorts of errors, then the md layer is over-react=
ing
> > by throwing disks out too easily.=20
> >=20
> >=20
> > Regards,
> > Ian
> >=20
> >=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Ian Dall <ian@beware.dropbear.id.au>

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Gavin Flower <gavinflower@yahoo.com>
Subject: Re: RAID6 data-check took almost 2 hours, clicking sounds, system unresponsive
Date: Fri, 8 Apr 2011 02:59:52 -0700 (PDT)
Message-ID: <1215.67697.qm@web65110.mail.ac2.yahoo.com>
References: <20110408193426.028b0f00@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110408193426.028b0f00@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--- On Fri, 8/4/11, NeilBrown <neilb@suse.de> wrote:

> From: NeilBrown <neilb@suse.de>
> Subject: Re: RAID6 data-check took almost 2 hours, clicking sounds, s=
ystem unresponsive
> To: "Gavin Flower" <gavinflower@yahoo.com>
> Cc: linux-raid@vger.kernel.org
> Date: Friday, 8 April, 2011, 21:34
> On Thu, 7 Apr 2011 18:32:04 -0700
> (PDT) Gavin Flower <gavinflower@yahoo.com>
> wrote:
>=20
> > Hi Neil,
> >=20
> > My original email may have been eaten: as it did not
> appear on the list, nor did I get an error message
> back.=A0 So perhaps there was a problem with the attached
> files.
> >=20
> > I will resend the attachments one at a time in
> separate emails.
> >=20
> >=20
> > Cheers,
> > Gavin
> >=20
> > [begin original]
> > Hi Neil,
> >=20
> > Your help (or anybody else's) would be greatly
> appreciated, yet again
>=20
> Hi Gavin,
>  it isn't clear to me what help you want.
>=20
> Obviously there is some sort of hardware issue - possible a
> drive, possibly a
> bus problem - I really don't know.
>=20
> Apart from that things look normal.
>=20
> What exactly did you want explained?
>=20
> NeilBrown

I guess I was surprised that the RAID system appeared normal and that i=
t did not register any errors.  I was hoping to get an idea as to which=
 drive was problematic.

I get the feeling, from your reply, that this is not specifically a RAI=
D problem, that it just happens to affect a RAID array.

I had thought that the RAID system should have been able to give me bet=
ter diagnostics, but possibly I am being (inadvertently) unreasonable!

Not sure what the significance of this mismatch is, and what I should d=
o about it.
# cat /sys/block/md2/md/mismatch_cnt=20
28904=20
#=20


Thanks,
Gavin

> >=20
> > This morning, I noticed my system was extremely
> unresponsive, and that there were clicking sounds coming
> from one of my 5 hard drives.=A0 Also that there was
> excessive disk I/O even for trivial things like bring up a
> directory window, and lots of ata3 errors being reported to
> the system log.=A0 These symptoms were mostly during a
> raid check process.
> >=20
> > Somewhere along the way, I seemed to have lost my swap
> partition!
> >=20
> > So I did some extensive investigations, which took
> most of the day.=A0 My notes were created in OpenDocument
> format using LibreOffice, but I have converted them to txt
> format for the include - but I can supply the ,odt file if
> requested.
> >=20
> > I Have included 2 files:
> >=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0
> my notes: raid-notes-20110407a.txt
> >=A0 =A0 selected log entries:
> messages-gcf-20110407-ATA
> >=20
> > If there are some additional diagnostics that might
> prove useful, please let me know.
> >=20
> >=20
> > Cheers,
> > Gavin
> > [end original]
> > --
> > All Adults share the Responsibility
> > to help Raise Today's Children,
> > for they are Tomorrow's Society!
> > --
> > To unsubscribe from this list: send the line
> "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at=A0 http://vger.kernel.org/majordomo-info.htm=
l
>=20
>=20
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

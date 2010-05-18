From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm: failed devices become spares!
Date: Tue, 18 May 2010 12:06:37 +1000
Message-ID: <20100518120637.24d875c9@notabene.brown>
References: <9D.D3.23029.CDD40FB4@cdptpa-omtalb.mail.rr.com>
	<201005172010.36157.pierre@vigneras.name>
	<20100518113016.1981a08c@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100518113016.1981a08c@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Pierre =?UTF-8?B?VmlnbsOpcmFz?= <pierre@vigneras.name>, Leslie Rhorer <lrhorer@satx.rr.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 18 May 2010 11:30:16 +1000
Neil Brown <neilb@suse.de> wrote:

> On Mon, 17 May 2010 20:10:36 +0200
> Pierre Vign=C3=A9ras <pierre@vigneras.name> wrote:
>=20
> > Did I miss something, or is there something really strange happenin=
g there?
>=20
> Something strange...
> I cannot explain the 'SpareActive' messages.

Actually I can explain that I think.

When a device fails it gets marked as faulty, then as soon as there is =
no
more pending IO it gets moved out of the array.  "mdadm -D" will show i=
t with
a larger 'Number' and a 'RaidDevice' of '-'.
Normally these happen almost as a single operation, though a lot of pen=
ding
IO can slow it down.

"mdadm --monitor" identified devices based on 'Number', so it would nor=
mally
see a working device disappear - which is reported a a failure, and a
'faulty/spare' device appear, which it ignores.

However if --monitor gets to check the array between the above to event=
s, it
will first see that the working drive is now faulty, so it reports a fa=
ilure,
and then see that the faulty device isn't faulty any more and in fact i=
sn't
even there.  The "isn't event there" bit doesn't register and it treats=
 it as
'SpareActive'.

I should fix that.

So I'm quite sure now that your devices didn't really become spares unt=
il you
removed and added them, which is exactly they way to turn failed device=
s
into spares.

NeilBrown

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

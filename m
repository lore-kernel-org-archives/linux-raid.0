From: Dave Fisher <davef@davefisher.co.uk>
Subject: Re: Diagnosis of assembly failure and attempted recovery - help
	needed
Date: Mon, 31 May 2010 21:21:40 +0100
Message-ID: <AANLkTikd4E9KUK2ZwSAL60x1MCO913jeEFtlZSvbRaxU@mail.gmail.com>
References: <AANLkTinWIekb9QHZB3sMrrvZE8CEFIcbHmMHE4eGzDIY@mail.gmail.com>
	<20100531135514.10de5901@notabene.brown>
Reply-To: davef@davefisher.co.uk
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100531135514.10de5901@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de
List-Id: linux-raid.ids

Thank you Neil. I don't want to follow your suggestions, until I'm
sure that I've properly understood them.

See my responses and questions interleaved below.

On 31 May 2010 04:55, Neil Brown <neilb@suse.de> wrote:
> Everything in -pre looks good to me. =C2=A0The big question is, of co=
urse, "Can you
> see you data?".

Not, not at present.

Did I mention in my original post that the data is organised in three
LVM2 logical volumes?

I can't currently mount any of the LVM volumes.

> sdj hasn't been a hot spare since October last year. =C2=A0It must ha=
s dropped out
> for some reason and you never noticed. =C2=A0For this reason it is go=
od to put
> e.g. "spare=3D1" in =C2=A0mdadm.conf and have "mdadm --monitor" runni=
ng to warn you
> about these things.

Sorry to be such a dummy, but could you give an example of where and
how to put these in mdadm.conf?

The current mdadm.conf file (minus comments):

DEVICE partitions
CREATE owner=3Droot group=3Ddisk mode=3D0660 auto=3Dyes
HOMEHOST <system>
MAILADDR root
ARRAY /dev/md1 level=3Draid10 num-devices=3D4
UUID=3Df4ddbd55:206c7f81:b855f41b:37d33d37


> Some odd has happened by "post-recovery-raid-diagnostics.txt". =C2=A0=
sdh4 and sdg4
> are no longer in sync. =C2=A0Did you have another crash on Sunday mor=
ning?

No. I don't think so.

> I suspect your first priority is to make sure these crashes stop happ=
ening.

There have been none since /dev/md1 failed to mount ... suggesting
that mdadm, the RAID array itself, or the LVM stuff on top of it
is/are the source of the crashes.

> Then try the "-Af" command again. =C2=A0That is (almost) never the wr=
ong thing to
> do. =C2=A0It only put things together in a way that looks like it was=
 right
> recently.
>
> So I suggest:
> =C2=A01/ make sure that whatever caused the machine to crash has stop=
ped. =C2=A0Replace
> =C2=A0the machine if necessary.
> =C2=A02/ use "-Af" to force-assemble the array again.
> =C2=A03/ look in the array to see if your data is there.
> =C2=A04/ report the results.

Just tbe 100% sure. Should I include sdj4 in the assembly or merely
sd{f,g,h,i}4?

Dave
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

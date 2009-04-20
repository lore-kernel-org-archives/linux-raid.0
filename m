From: Christopher Chen <muffaleta@gmail.com>
Subject: Re: RAID without superblock
Date: Mon, 20 Apr 2009 11:17:09 -0700
Message-ID: <7bc80d500904201117r60353fa1ped1d64a50da87bc0@mail.gmail.com>
References: <20090419114743.GA29195@lazy.lzy>
	 <e96b335a0ba8595e2921d164f9b15ff7.squirrel@neil.brown.name>
	 <20090419210200.GA6942@lazy.lzy>
	 <1240178252.31728.12.camel@cichlid.com>
	 <20090420181045.GA4236@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090420181045.GA4236@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I don't think it's a problem anymore, but on Centos 5.2, use of
superblocks other than 0.90 and sparegroups with md monitor are not
compatible. I found this out the hard way after creating a few arrays
with 1.2 and putting them in the same sparegroup--when one array went
degraded, mdadm removed the spare from one, but failed when trying to
add it to the other, leaving me one spare less and with a degraded
array still.

=46un!

Cheers

cc

On Mon, Apr 20, 2009 at 11:10 AM, Piergiorgio Sartor
<piergiorgio.sartor@nexgo.de> wrote:
> Hi,
>
> first of all thanks a lot for all the suggestions,
> it is really nice to have this support!
>
> While reading the answers, I realized that I did
> not make the "requirements" really clear. My bad.
>
> The "primary" disk is an external one, which 90%
> of the time is connected to the same Linux PC.
> But, it could happen it is removed and connected
> somewhere else, where no "md" is available.
>
> My idea was, in order to have some protection, to
> use it in RAID-1 "superblockless" configuration
> on the "default" PC, and use it as a normal disk
> whenever (or wherever) necessary.
> Of course, the bitmap resync will not work, when
> updating the disk directly, without "md" layer.
>
> On the other hand, if the full-resync is always
> done from this disk to the local mirror, there
> would be no problem, except time.
>
> The reason to do this kind of backup is that this
> disk is encrypted, so a "block device copy" will
> keep the data encrypted, while a backup of the
> mounted disk will not. Unless done to another
> encrypted disk/partition, of course.
>
> Clearly, any suggestion is still really appreciated!
>
> Thanks again,
>
> bye,
>
> --
>
> piergiorgio
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Chris Chen <muffaleta@gmail.com>
"I want the kind of six pack you can't drink."
-- Micah
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

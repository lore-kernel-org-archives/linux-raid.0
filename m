From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Subject: Re: Known-good LSI PCIe SAS HBAs?
Date: Wed, 11 Nov 2009 04:47:12 -0700
Message-ID: <200911110447.12647.tfjellstrom@shaw.ca>
References: <73e903670911100854o1b48380apb5b0a86c44ae9dcb@mail.gmail.com> <200911110001.49910.tfjellstrom@shaw.ca> <73e903670911110309p6fc1cbe6x2481b61db3f7dd6d@mail.gmail.com>
Reply-To: tfjellstrom@shaw.ca
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <73e903670911110309p6fc1cbe6x2481b61db3f7dd6d@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Kristleifur =?iso-8859-1?q?Da=F0ason?= <kristleifur@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed November 11 2009, Kristleifur Da=F0ason wrote:
> On Wed, Nov 11, 2009 at 7:01 AM, Thomas Fjellstrom <tfjellstrom@shaw.=
ca>=20
wrote:
> > On Tue November 10 2009, you wrote:
> >> Hi,
> >>
> >> I'm looking to replace a problematic Marvell PCIe SAS JBOD control=
ler
> >> from Supermicro, type AOC-SASLP-MV8. (mdadm freaks out on it and t=
he
> >> controller drops the drives - there has been discussion of the pro=
blem
> >> on the list. Seems to be a mvsas driver problem but seems to surfa=
ce
> >> only under mdadm use.)
> >>
> >>...
> >
> > Not really an answer to your question, I got a snapshot of the in
> > development driver that seems to work just fine. I haven't run smar=
tctl
> > on the controller much mind you, as it seems to freak out my onboar=
d
> > controller too (AMD SB750). I could attempt it, but I've recently j=
ust
> > switched over to that hardware for my main server, and I'm reluctan=
t to
> > try running smartctl on the array, as it'd probably require a reboo=
t to
> > get which ever disk back that might get dropped.
>=20
> That's quite interesting.
> Did you discuss this on a mailing list somewhere and have a link to
> that discussion? Or would you be willing to forward a message to
> honorable mr. driver guy? I'd love to try the patch before buying a
> new controller.

There seems to be something seriously wrong with the kernel.org mailing=
=20
lists. They seem to miss a bunch of messages that get sent out. Its hap=
pened=20
on several occasions now with not only my messages, but others as well,=
 on=20
several different mailing lists, including lkml, linux-raid, linux-ide,=
 and=20
linux-scsi.

The best I can do is a link to my reply to Andy Yan's message, since An=
dy=20
Yan's message is mysteriously not in any of the archives. And I'm prett=
y=20
sure I didn't get two copies so the one sent to the list's just disappe=
ared.

http://lkml.org/lkml/2009/10/14/76

> Thanks!
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--=20
Thomas Fjellstrom
tfjellstrom@shaw.ca
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Pierre Wieser <pwieser@trychlos.org>
Subject: Re: Migrating a RAID 5 from 4x2TB to 3x6TB ?
Date: Tue, 9 Jun 2015 20:26:09 +0200 (CEST)
Message-ID: <1962275776.984.1433874369880.JavaMail.zimbra@wieser.fr>
References: <1419435054.589.1433790714774.JavaMail.zimbra@wieser.fr> <167089395.613.1433791723592.JavaMail.zimbra@wieser.fr> <CAOS+5GHzBgx2DuDe0+RLgZj9Q1BZ944i-9q4NEERq66Sk78b2g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAOS+5GHzBgx2DuDe0+RLgZj9Q1BZ944i-9q4NEERq66Sk78b2g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Another Sillyname <anothersname@googlemail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

----- Original Message -----
> I assume the motherboard you're using only has 4 sata ports?

Yes, the motherboard has 4 sata ports, and there is already a small external
sata controller. So my actual raid device has 5 disks (4+S). For the discussion,
I just omitted the spare device ;)

> On 8 June 2015 at 20:28, Pierre Wieser <pwieser@trychlos.org> wrote:
> > Hi all,
> >
> > I currently have an almost full RAID 5 built with 4 x 2 TB disks.
> > I wonder if it would be possible to migrate it to a bigger RAID 5
> > with 3 x 6TB new disks.

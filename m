From: Chris Murphy <lists@colorremedies.com>
Subject: Re: RAID6 reshape, 2 disk failures
Date: Tue, 16 Oct 2012 21:06:19 -0600
Message-ID: <C0A56E30-4D1A-44D3-8480-AC70706897B3@colorremedies.com>
References: <CADNH=7FunKmUSREJJz2Lonqjb42gB_WHMQJ7-jmip-X8-1yZnw@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADNH=7FunKmUSREJJz2Lonqjb42gB_WHMQJ7-jmip-X8-1yZnw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Oct 16, 2012, at 4:57 PM, Mathias Bur=E9n wrote:

> I started a reshape from 64K chunk size to 512K

I agree with Stan, not a good idea, and also a waste of time. Do you ha=
ve check scrubs and extended offline smart tests scheduled for these dr=
ives periodically?

>=20
> I guess my question is if it's possible for me to remove the drive, o=
r
> would I mess the array up? I am not going to anything until the
> reshape finishes though.

I think you should put in a replacement drive for sda (#6) and get it r=
ebuilding, as sde seems rather tenuous, before you decide to remove sde=
=2E

You should find out why it's slow 'smartctl -A /dev/sde' might reveal t=
his now, which you can issue even while the reshape is occurring - the =
command just polls for existing smart attribute values for the drive. I=
f it's the same model disk, connected the same way, as all the other dr=
ives, I'd get rid of it.


Chris Murphy--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

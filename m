From: Maik Zumstrull <maik@zumstrull.net>
Subject: Re: RAID barely usable on my home machine
Date: Fri, 5 Apr 2013 10:06:58 +0200
Message-ID: <CAO=zWD+5GHjJCD0Z64ZQFR=98ysRyd0o2U=t4ER8mJaSpwQDuQ@mail.gmail.com>
References: <CAO=zWDLfnBJBFgm4H67XEqsKPP=+Ayk3Jd4OUdEfmLXsvNGdog@mail.gmail.com>
	<CAAMCDeeY1S+TMyiFpVjEFX3K66JaxcwBFV+zDRD6eyRfM2Qxsw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAMCDeeY1S+TMyiFpVjEFX3K66JaxcwBFV+zDRD6eyRfM2Qxsw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roger Heflin <rogerheflin@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>, 700975 <700975@bugs.debian.org>
List-Id: linux-raid.ids

On Fri, Apr 5, 2013 at 2:16 AM, Roger Heflin <rogerheflin@gmail.com> wrote:

> lspci look like this for the controller:
> SATA controller: Marvell Technology Group Ltd. Device 9230 (rev 10)
>
> 4pt sata3.0 6gbit or is yours a different one?

Mine looks slightly different (included somewhere in my mail), but
should be a device in the same family.

> I have the issue also, I have eliminated all smart hits against the
> disks and no incidents since then.

Not a great workaround as such, first of all, running SMART against
your storage is kind of recommended, and secondly, as I said, udisks2
will also SMART your disks occasionally, which you have to uninstall
parts of GNOME to get rid of.

> I have seagate 1.5tb drives on mine that had had the issues.

Suggests it's not something about my drives, as I have WD Red disks.

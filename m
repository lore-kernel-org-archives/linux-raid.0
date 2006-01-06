From: Andre Majorel <aym-xunil@teaser.fr>
Subject: Re: Fwd: Linux MD raid5 and reiser4... Any experience ?
Date: Fri, 6 Jan 2006 11:49:31 +0100
Message-ID: <20060106104931.GB20546@atc5.vermine.org>
References: <fd8d0180601050104x15079396h@mail.gmail.com> <fd8d0180601050106s5f5b4306o@mail.gmail.com> <17341.8541.33899.167524@smtp.charter.net> <fd8d0180601050603t6f62ff91o@mail.gmail.com> <17341.27534.41206.232976@smtp.charter.net> <fd8d0180601060108rbe9d663p@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <fd8d0180601060108rbe9d663p@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2006-01-06 10:08 +0100, Francois Barre wrote:
> > No, backups do not mean snapshots.
> > Snapshots are merely a way to take backups of a consistent view of =
the
> filesystem...
> [...]
> > Don't mix them up, you'll be really really unhappy.
> Wll, I may not be fully awoken yet, but what is the interrest of
> having non-consistent backups ? For sure, backuping implies one of :
> 1. Forbidding write access to data for users
> 2. Having the capability to have snapshots.

With LVM, you can create a snapshot of the block device at any
time, mount the snapshot read-only (looks like another block
device) and backup that. Ensuring consistency at application level
is still up to you but at least, if that involves stopping
services, the unavailability window is greatly reduced.

--=20
Andr=E9 Majorel <URL:http://www.teaser.fr/~amajorel/>
Do not use this account for regular correspondence.
See the URL above for contact information.
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

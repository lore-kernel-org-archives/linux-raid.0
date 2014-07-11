From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Partitioning on top of raid mirror device questions.
Date: Fri, 11 Jul 2014 10:29:37 -0600
Message-ID: <9FC642F9-82DA-41CF-BEDB-F79E2A47462F@colorremedies.com>
References: <BLU436-SMTP80DC26546309D9E205B561E10E0@phx.gbl>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BLU436-SMTP80DC26546309D9E205B561E10E0@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: Wilson Jonathan <i400s@hotmail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Jul 10, 2014, at 5:24 AM, Wilson Jonathan <i400s@hotmail.com> wrote:
>=20
> If we assume that raid/base disk is all hunky dory alignment wise, th=
is
> then brings me on to partitions on top of the raid=85

Since you're going to use LVM anyway, why not use LVM raid? Make each w=
hole disk (or partition) a PV. Then at the time you create an LV, choos=
e the raid level. This consolidates the additional partitioning, mdadm,=
 and lvm steps all into a single lvm step.


> I may just stick with raw files but as I am in the process of upgradi=
ng
> it piqued my interest and might be worth converting to partitions, or
> possibly LVM which seems the preferred or most documented option (bit
> I'm not sure I want to add a whole new set of skills and learning cur=
ve
> at the moment).=20

I found qcow2 files had the best performance. And if your use case even=
 remotely benefits from snapshotting, qcow2 performs much better than (=
conventional) LVM snapshotting. The new LVM thin provisioning snapshott=
ing makes snapshots perform the same as the original LV, but the libvir=
t integration work to use thin pools isn't done yet, I think.


Chris Murphy

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: =?iso-8859-1?q?M=E5ns_Rullg=E5rd?= <mru@inprovide.com>
Subject: Re: RAID5 - 2nd drive died whilst waiting for RMA
Date: Sat, 13 Nov 2004 21:01:45 +0100
Message-ID: <yw1xwtwpjz6e.fsf@ford.inprovide.com>
References: <200411121847.iACIlNN01272@www.watkins-home.com> <41966514.8000301@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

David Greaves <david@dgreaves.com> writes:

> Now, Guy, your next step:
> # mdadm --assemble --force /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/hdb1
> mdadm: /dev/sda1 does not appear to be an md device

Sorry to butt in, but that command should, assuming the components are
correct, read as

mdadm --assemble <raiddevice> --force /dev/sda1 /dev/sdb1 /dev/sdc1 /de=
v/hdb1

with <raiddevice> replaced by something like /dev/md0.

--=20
M=E5ns Rullg=E5rd
mru@inprovide.com

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

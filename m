From: NeilBrown <neilb@suse.de>
Subject: Re: BUG?: RAID6 reshape hung in reshape_request
Date: Mon, 27 Apr 2015 11:20:56 +1000
Message-ID: <20150427112056.7195d226@notabene.brown>
References: <CAGivzjGyifS3r0rypqM7n2P-fcA7NvPjJWa6kV_wfGx2biDrDg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/n+b4Jhf+2ZOE3IEVQR/d.Lf"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGivzjGyifS3r0rypqM7n2P-fcA7NvPjJWa6kV_wfGx2biDrDg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Wahler <dwahler@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/n+b4Jhf+2ZOE3IEVQR/d.Lf
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 25 Apr 2015 16:35:24 -0500 David Wahler <dwahler@gmail.com> wrote:

> Hi,
>=20
> I'm trying to reshape a 4-disk RAID6 array by adding a fifth "missing"
> drive. Maybe that's a weird thing to do, so for context: I'm
> converting from a 3-disk RAID10, by creating a new RAID6 with the
> three new disks and then moving disks one at a time between the
> arrays. I did it this way so that I could test for problems with the
> reshape procedure before irrevocably modifying more than one of the
> original disks.
>=20
> (I do also have an offsite backup of the most important data, but it's
> inconvenient to access and I'm hoping not to need it.)
>=20
> Anyway, the reshape was going fine until about 70% completion, and
> then it got stuck. I've tried rebooting a few times: the array can be
> assembled in read-only mode, but as soon as it goes read-write and the
> reshape process continues, it gets through a few megabytes and hangs.
> At that point, any other process that tries to access the array also
> hangs uninterruptibly.
>=20
> Here's what shows up in dmesg:
>=20
> [  721.183225] INFO: task md127_resync:1730 blocked for more than 120 sec=
onds.
> [  721.183978]       Not tainted 4.0.0 #1
> [  721.184751] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [  721.185514] md127_resync    D ffff88042ea94440     0  1730      2 0x00=
000000
> [  721.185516]  ffff88041a24ed20 0000000000000400 ffff88041ca82a20
> 0000000000000246
> [  721.185518]  ffff8800b8b5ffd8 ffff8800b8b5fbf0 ffff880419035a30
> 0000000000000004
> [  721.185519]  ffff8800b8b5fd1c ffff88040e91d000 ffffffff8155c73f
> ffff880419035800
> [  721.185520] Call Trace:
> [  721.185526]  [<ffffffff8155c73f>] ? schedule+0x2f/0x80
> [  721.185530]  [<ffffffffa0888390>] ? reshape_request+0x1e0/0x8f0 [raid4=
56]
> [  721.185533]  [<ffffffff810a86f0>] ? wait_woken+0x90/0x90
> [  721.185535]  [<ffffffffa0888dae>] ? sync_request+0x30e/0x390 [raid456]
> [  721.185547]  [<ffffffffa02cbf89>] ? is_mddev_idle+0xc9/0x130 [md_mod]
> [  721.185550]  [<ffffffffa02cf432>] ? md_do_sync+0x802/0xd30 [md_mod]
> [  721.185555]  [<ffffffff8101c356>] ? native_sched_clock+0x26/0x90
> [  721.185558]  [<ffffffffa02cbb30>] ? md_safemode_timeout+0x50/0x50 [md_=
mod]
> [  721.185561]  [<ffffffffa02cbc56>] ? md_thread+0x126/0x130 [md_mod]
> [  721.185563]  [<ffffffff8155c0c0>] ? __schedule+0x2a0/0x8f0
> [  721.185565]  [<ffffffffa02cbb30>] ? md_safemode_timeout+0x50/0x50 [md_=
mod]
> [  721.185568]  [<ffffffff81089403>] ? kthread+0xd3/0xf0
> [  721.185570]  [<ffffffff81089330>] ? kthread_create_on_node+0x180/0x180
> [  721.185572]  [<ffffffff81560598>] ? ret_from_fork+0x58/0x90
> [  721.185574]  [<ffffffff81089330>] ? kthread_create_on_node+0x180/0x180
>=20
> And the output of mdadm --detail/-E:
> https://gist.github.com/anonymous/0b090668b56ef54bb2f0

What is wrong with simply including this directly in the email???

Anyway:

  Bad Block Log : 512 entries available at offset 72 sectors - bad blocks p=
resent.

that is the only thing that looks at all interesting.  Particularly the last
3 words.
What does
   mdadm --examine-badblocks /dev/sd[cde]1
show?

NeilBrown


>=20
> I was originally running a Debian 3.16.0 kernel, and then upgraded to
> 4.0 to see if it would help, but no such luck.
>=20
> Does anyone have any suggestions? Since the data on the array seems to
> be fine, hopefully there's a solution that doesn't involve re-creating
> it from scratch and restoring from backups.
>=20
> Thanks,
> -- David
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/n+b4Jhf+2ZOE3IEVQR/d.Lf
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVT2O+Dnsnt1WYoG5AQKPbBAAmXjelMWIx37dH0Wa0eMGH9bktvOolksb
JSb4b0gEPL95l0IqmuYBR4wNkjnALQsJ1+3THgFdB8/nhKSKOz43aepeZCsPYa9C
WXwhS4D6znE9VDWhbtBqn6h3oKr/+8YW3eEe12+7CxDdio8UcBjRiIThENfLb0eu
Vvl/mvvwAHqX6wxb20f4mAO7QRh/Ec39lHYZPSlGMqrNgbxPDhvoY61X00YECpDO
UF0ZBSLQgI1DibydGGkBA9SnbWle+IYO2/cI1q+VleebFG05cPatSdXd3lOLwge5
rxHwW7IUHFYdPkauzyhO8A9xovYDGqqC+XsFCHBZnzXw6HDj8nTT+T+ciDnJCCcL
LIo6aABVSeJrPEikLXw8Gpo3lPE1N+aGDGBcTpdTJn6wwP9x2rfH/D/PvUVrv0BH
cpbymNvHj7wTDe+2muNhkoXCazFJR9WvjpAg2cncOWCw3BZNgh6RDLThFrZkzs+4
cD3gVUGpQyJOlcrw1hS5BAVp3Kx7es49KpcTU2TeehQhwAqdhWae13NtQRRQ8PnS
joR4tRSjf3oa0omHhgvidjS2vmsBuCPlRx8nrdHwCh4ahh/ZTGLi+T8KaO2YyKXt
o08RuKEKRMIlWW5OUSy6ChmFLreWOwpHbtkhowJ/tvGNwroqPOg33JTVyTqVScXR
kdOJPfEgfBM=
=R/zE
-----END PGP SIGNATURE-----

--Sig_/n+b4Jhf+2ZOE3IEVQR/d.Lf--

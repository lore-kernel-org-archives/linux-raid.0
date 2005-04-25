From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: Does mdadm work on active/passive arrays
Date: Mon, 25 Apr 2005 23:22:29 +0200
Message-ID: <20050425212229.GY32085@marowsky-bree.de>
References: <426D5333.4080502@bms.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <426D5333.4080502@bms.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2005-04-25T16:29:39, Anu Matthew <anu.matthew@bms.com> wrote:

> Just a small question about creating multipath devices using mdadm:
>=20
> Does it support Active/Passive Arrays like the Clariion?

This is not a function of mdadm, but of the md multipath code in the
kernel. The short answer is: "No".=20

md multipath is not being actively developed and extended in 2.6 any
longer.

However, there is hope. The Device Mapper multipath module _does_
support the EMC CLARiiON CX-family of arrays quite well (in fact, I'm
developing with one). At least in the latest udm patchsets by Alasdair,
and in combination with the multipath-tools userspace package.

The multipath support in SLES9 SP2 will be based on this, and to my
knowledge also that in RHEL4 U1, but I can only guess about that ;-)

The latest tools are basically zero config on those arrays: Just start
it and it'll do the right things. For SLES9, we'll publish a Support
Database Article in time with the release. (Because obviously the actua=
l
integration into the distribution differs slightly.)

You can find more information about DM MPIO at
http://sources.redhat.com/dm/.

That said:

> I am using mdadm  v1.11.0, and the devices return no UUID when querie=
d=20
> using mdadm -D --scan.

No wonder; mdadm tries to read the md superblock of the disk, which is
not possible for a passive path on an EMC CX. You first need to send th=
e
SCSI trespass command to re-bind the Logical Unit to that Service
Processor. (Which at the same time makes it inaccessible on the other
SP...) mdadm and md multipath don't know about that and can't handle it=
=2E

> BTW, I am using qla2300 modules with options scsi_mod max_scsi_luns=3D=
255=20
> scsi_allow_ghost_devices=3D1.

=46WIW, I also recommend
options qla2xxx qlport_down_retry=3D1 ql2xfailover=3D0 ql2xretrycount=3D=
5
to faciliate fast switch-over in case a path fails.

At least it seems to work fine during my testing so far ;-)


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

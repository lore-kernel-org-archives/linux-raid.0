From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: Trouble assembling multipath md devices between two nodes who see the same LUNs.
Date: Tue, 19 Apr 2005 00:34:08 +0200
Message-ID: <20050418223408.GC29071@marowsky-bree.de>
References: <4264234D.7030703@bms.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4264234D.7030703@bms.com>
Sender: linux-raid-owner@vger.kernel.org
To: Anu Matthew <anu.matthew@bms.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2005-04-18T17:14:53, Anu Matthew <anu.matthew@bms.com> wrote:

> Hello,
>=20
> I have two nodes, hostA and hostB, both of them see the same 4 multip=
ath=20
> LUNs.
>=20
> md0 to md4 are thus visible to both the hosts, (yeah, they both do no=
t=20
> write to thoe md devices at the same time, hostB mounts them only whe=
n=20
> hostA is down or has crashed, and viceversa.)
>=20
> It works for a while.

md multipath has on-disk metadata and modifies it. md is NOT
cluster-safe for concurrent activation.


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

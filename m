From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: raid on shared storage
Date: Fri, 18 Mar 2005 14:56:37 +0100
Message-ID: <20050318135637.GT18819@marowsky-bree.de>
References: <423ADD02.4020008@netuse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-Disposition: inline
In-Reply-To: <423ADD02.4020008@netuse.de>
Sender: linux-raid-owner@vger.kernel.org
To: Nils-Henner Krueger <nhk@netuse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2005-03-18T14:52:02, Nils-Henner Krueger <nhk@netuse.de> wrote:

> I'm going to run some kind of cluster using shared
> fiber channel disks with linux sw raid on top.
>=20
> Is it possible to start a raid device on more than one
> machine?

Not yet.

Activating the same md raid on more than one node will destroy your
data, is the gist of it.

RHAT is working on dm-raid1.c to support this, I think. Daniel Philipps
should know more.


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

From: Lars Marowsky-Bree <lmb@suse.de>
Subject: md multipath corruption in 2.4.x
Date: Wed, 13 Apr 2005 11:26:05 +0200
Message-ID: <20050413092605.GM32354@marowsky-bree.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

I'm currently having to hunt down a source of corruption in md multipat=
h
in 2.4.21 (but the respective code paths haven't changed until 2.4.30
either, so it's likely present in all 2.4.x kernels).

The corruption is triggered by a path failure; then some writes go
wrong. (It's a bit difficult to figure out what exactly is happening as
it takes a fairly substantial write load too it seems.)

I saw that raid1 has received locking fixes for the access to its
internal structs in 2.4.28 and I've already ported these over to
multipath too, but it doesn't seem to be causing this.

I'll have to dig deeper into the code base now and try to figure out
what is going wrong; the problem is that the code _looks_ correct ;-)

So, if anybody has experienced similar issues with md multipath in 2.4,
or has some data points to share (or "what you always thought smelled
fishy about md multipath"), I'd appreciate this.


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

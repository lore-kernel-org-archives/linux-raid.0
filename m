From: Lars Marowsky-Bree <lmb@suse.de>
Subject: [PATCH] Re: md multipath corruption in 2.4.x
Date: Wed, 13 Apr 2005 22:13:01 +0200
Message-ID: <20050413201301.GY32354@marowsky-bree.de>
References: <20050413092605.GM32354@marowsky-bree.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20050413092605.GM32354@marowsky-bree.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2005-04-13T11:26:05, Lars Marowsky-Bree <lmb@suse.de> wrote:

Ok, so the subject is a bit of a lie, because I haven't yet brought ove=
r
all changes from our 2.4.21 vendor kernel to 2.4.30 (as I'd need to
disentangle some feature additions first which Neil doesn't like).

However, I've found the root cause of the data corruption issue with md
multipath, after having been side tracked by the abhorrent locking
issues ;-)

It's this innocent "bh->b_rsector =3D bh->b_blocknr;" in
multipath.c:multipathd(), an obvious artifact from having forked this
from raid1.c - where however this has a clearly different meaning.

=46or md multipath, this basically implies that _EVERY_ IO which was
in-flight when the error happened and was requeued will be written to a
wrong block on disk.

A minimal fix would be to remove at least this one line, if one didn't
want to fix the locking raid1.c-style (was introduced with 2.4.28).


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

From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: [PATCH 1/2] md bitmap bug fixes
Date: Fri, 18 Mar 2005 14:42:55 +0100
Message-ID: <20050318134255.GS18819@marowsky-bree.de>
References: <422F7621.8090602@steeleye.com> <16949.5768.392061.95882@cse.unsw.edu.au> <20050314094454.GK3858@marowsky-bree.de> <16949.26113.68948.938529@cse.unsw.edu.au> <20050314112403.GT3858@marowsky-bree.de> <16950.5692.594941.130741@cse.unsw.edu.au> <20050318103326.GA18819@marowsky-bree.de> <6ivqg2-qsn.ln1@news.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-Disposition: inline
In-Reply-To: <6ivqg2-qsn.ln1@news.it.uc3m.es>
Sender: linux-raid-owner@vger.kernel.org
To: "Peter T. Breuer" <ptb@lab.it.uc3m.es>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2005-03-18T13:52:54, "Peter T. Breuer" <ptb@lab.it.uc3m.es> wrote:

> (proviso - I didn't read the post where you set out the error
> situations, but surely, on theoretical grounds, all that can happen i=
s
> that the bitmap causes more to be synced than need be synced).

You missed the point.

The problem is for multi-nodes, both sides have their own bitmap. When =
a
split scenario occurs, and both sides begin modifying the data, that
bitmap needs to be merged before resync, or else we risk 'forgetting'
that one side dirtied a block.

This scenario _could_ occur for single nodes, but less likely so.

That can either happen outside md (if one is careful in the wrappers
around setting up network replication), or it could happen inside
generic md (if each mirror had its own local bitmap).

Which also has the advantage of providing inherent redundancy for the
bitmap itself, BTW.


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

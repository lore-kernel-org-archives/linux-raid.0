From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: [PATCH 1/2] md bitmap bug fixes
Date: Mon, 14 Mar 2005 10:44:54 +0100
Message-ID: <20050314094454.GK3858@marowsky-bree.de>
References: <422F7621.8090602@steeleye.com> <16949.5768.392061.95882@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-Disposition: inline
In-Reply-To: <16949.5768.392061.95882@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>, Paul Clements <paul.clements@steeleye.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2005-03-14T15:43:52, Neil Brown <neilb@cse.unsw.edu.au> wrote:

Hi there, just a question about how the bitmap stuff works with
1++-redundancy, say RAID1 with 2 mirrors, or RAID6.

One disk fails and is replaced/reattached, and resync begins. Now
another disk fails and is replaced. Is the bitmap local to each disk?

And in case of RAID1, with 4 disks (and two of them resyncing), could
disk3 be rebuild from disk1 and disk4 from disk2 (as to optimize disk
bandwidth)?


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

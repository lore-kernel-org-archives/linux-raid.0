From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: [PATCH 1/2] md bitmap bug fixes
Date: Fri, 18 Mar 2005 11:33:26 +0100
Message-ID: <20050318103326.GA18819@marowsky-bree.de>
References: <422F7621.8090602@steeleye.com> <16949.5768.392061.95882@cse.unsw.edu.au> <20050314094454.GK3858@marowsky-bree.de> <16949.26113.68948.938529@cse.unsw.edu.au> <20050314112403.GT3858@marowsky-bree.de> <16950.5692.594941.130741@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-Disposition: inline
In-Reply-To: <16950.5692.594941.130741@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: Paul Clements <paul.clements@steeleye.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2005-03-15T09:54:52, Neil Brown <neilb@cse.unsw.edu.au> wrote:

> It arbitrarily chooses one.  It doesn't matter which.  The code
> currently happens to choose the first, but this is not a significant =
choice.

True enough. I had a typical case of tomatoes. Thanks.

> > I think each disk needs to have it's own bitmap in the long run. On
> > start, we need to merge them.
>=20
> I think any scheme that involved multiple bitmaps would be introducin=
g
> too much complexity.  Certainly your examples sound very far fetched
> (as I think you admitted yourself).  But I always try to be open to
> new ideas.

=46or single node operations, yes. But disks appearing and reappearing =
is
_mostly_ a cluster issue, and there it makes sense, because of the
potentially diverging data in case both sides activate the mirrors.


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

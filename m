From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: [PATCH 1/2] md bitmap bug fixes
Date: Fri, 18 Mar 2005 18:57:13 +0100
Message-ID: <20050318175713.GY18819@marowsky-bree.de>
References: <422F7621.8090602@steeleye.com> <16949.5768.392061.95882@cse.unsw.edu.au> <20050314094454.GK3858@marowsky-bree.de> <16949.26113.68948.938529@cse.unsw.edu.au> <20050314112403.GT3858@marowsky-bree.de> <16950.5692.594941.130741@cse.unsw.edu.au> <20050318103326.GA18819@marowsky-bree.de> <6ivqg2-qsn.ln1@news.it.uc3m.es> <20050318134255.GS18819@marowsky-bree.de> <20050318171608.GA28494@percy.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-Disposition: inline
In-Reply-To: <20050318171608.GA28494@percy.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2005-03-18T18:16:08, Luca Berra <bluca@comedia.it> wrote:

> >The problem is for multi-nodes, both sides have their own bitmap. Wh=
en a
> >split scenario occurs, and both sides begin modifying the data, that
> >bitmap needs to be merged before resync, or else we risk 'forgetting=
'
> >that one side dirtied a block.
> on a side note i am wondering what would the difference be on using t=
his
> approach within the md driver versus DRBD?

=46unctionally equivalent, I think.

drbd's main advantage right now is that it comes in a neat single
package and is, compared to getting the pieces combined right, much
easier to setup.

Having the speed-up resync in itself doesn't yet solve all issues: If
you look at drbd's generation counter handling, the included merging of
the bitmaps on connect, tight integration with the network stack et
cetera. One might also argue that drbd's activity log (plus the bitmap)
is slightly more sophisticated, but Philipp is the man to speak for
that.

Now, certainly one can build such a solution on top of the md fast
resync (with maybe some features lifted from drbd if there are any nice
ones you'd care for) + a network block device / iSCSI too, and wrap it
all up so that it'd look just like drbd. And that wouldn't be too bad.


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

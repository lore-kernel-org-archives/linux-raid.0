From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: [PATCH 1/2] md bitmap bug fixes
Date: Sat, 19 Mar 2005 15:07:54 +0100
Message-ID: <20050319140754.GP18819@marowsky-bree.de>
References: <20050318134255.GS18819@marowsky-bree.de> <7e6rg2-pj1.ln1@news.it.uc3m.es> <423B09EF.8070708@steeleye.com> <23krg2-4rr.ln1@news.it.uc3m.es> <d1f8fr$k8f$1@sea.gmane.org> <e1nrg2-os1.ln1@news.it.uc3m.es> <d1fd9v$7h6$1@sea.gmane.org> <dsftg2-8cr.ln1@news.it.uc3m.es> <20050319125821.GO18819@marowsky-bree.de> <hvltg2-ss8.ln1@news.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-Disposition: inline
In-Reply-To: <hvltg2-ss8.ln1@news.it.uc3m.es>
Sender: linux-raid-owner@vger.kernel.org
To: "Peter T. Breuer" <ptb@lab.it.uc3m.es>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2005-03-19T14:27:45, "Peter T. Breuer" <ptb@lab.it.uc3m.es> wrote:

> > Which one of the datasets you choose you could either arbitate via =
some
> > automatic mechanisms (drbd-0.8 has a couple) or let a human decide.
> But how on earth can you get into this situation? It still is not cle=
ar
> to me, and it seems to me that there is a horrible flaw in the managi=
ng
> algorithm for the failover if it can happen, and one should fix it.

You mean, like an admin screwup which should never happen? ;-)

Remember what RAID is about: About errors which _should not_ occur (if
the world was perfect and software and hardware never failed); but whic=
h
with a given probability they _do_ occur anyway, because the real world
doesn't always do the right thing.

It's futile to argue about that it should never occur; morale arguments
don't change reality.=20

Split-brain is a well studied subject, and while many prevention
strategies exist, errors occur even in these algorithms; and there's
always a trade-off: For some scenarios, they might choose a very low
probability of split-brain occuring in exchange for a higher guarantee
that service will 'always' be provided. It all depends on the kind of
data and service, the requirements and the cost associated with it.

> > The default with drbd-0.7 is that they will detect this situation h=
as
> > occured and refuse to start replication unless the admin intervenes=
 and
> > decides which side wins.
> Hmm. I don't believe it can detect it reliably. It is always possible
> for both sides to have written different data in the ame places, etc.

drbd can detect this reliably by its generation counters; the one
element which matters here is the one which tracks if the device has
been promoted to primary while being disconnected.

(Each side keeps its own generation counters and it's own bitmap &
journal, and during regular operation, they are all sync'ed. So they ca=
n
be used to figure out what diverged 'easily' enough.)

If you don't believe something, why don't you go read up ;-)

This also is a reasonably well studied subject; there's bits in "Fault
Tolerance in Distributed Systems" by Jalote, and Philipp Reisner also
has a paper on it online; I think parts of it are also covered by his
thesis.


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

From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: [PATCH 1/2] md bitmap bug fixes
Date: Sat, 19 Mar 2005 18:36:57 +0100
Message-ID: <20050319173657.GT18819@marowsky-bree.de>
References: <d1f8fr$k8f$1@sea.gmane.org> <e1nrg2-os1.ln1@news.it.uc3m.es> <d1fd9v$7h6$1@sea.gmane.org> <dsftg2-8cr.ln1@news.it.uc3m.es> <20050319125821.GO18819@marowsky-bree.de> <hvltg2-ss8.ln1@news.it.uc3m.es> <20050319140754.GP18819@marowsky-bree.de> <lortg2-9th.ln1@news.it.uc3m.es> <20050319162443.GR18819@marowsky-bree.de> <gi3ug2-oub.ln1@news.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <gi3ug2-oub.ln1@news.it.uc3m.es>
Sender: linux-raid-owner@vger.kernel.org
To: "Peter T. Breuer" <ptb@lab.it.uc3m.es>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2005-03-19T18:19:44, "Peter T. Breuer" <ptb@lab.it.uc3m.es> wrote:

> > That part is really simple in theory.
> 
> Knowing which blocks are/may be different does not help them decide who is
> _right_. 
> 
> Lars, I am trying to move you "upwards" from the detail of the
> algorithms to a level at which you can see that there is no algorithm
> that can decide reliably which of two diverged traces is the more
> "valid" in some sense.

As I've said, there's a variety of decision algorithms; that already
implied there's no one answer, but always a trade-off. And sometimes,
the admin might have to make the choice and manually add the changes
made to one set to the other.

> > Wrong model. They know that at one point in time they've been in sync,
> > and that they have since diverged, and so they can figure out where
> > those differences occur.
> They can't. That's the point. See above rough hack at a proof. 

You're mixing this up.

The mail I replied to said they can't figure out what happened; that
they can.

Is there a perfect conflict resolution algorithm which preserved all
changed and merged them perfectly? Probably not; not at the block layer,
in any case. I never claimed that; see above.

Please, keep your argument straight.



-- 
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business


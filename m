From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: [PATCH 1/2] md bitmap bug fixes
Date: Mon, 21 Mar 2005 21:45:14 +0100
Message-ID: <qbo3h2-kjo.ln1@news.it.uc3m.es>
References: <16950.5692.594941.130741@cse.unsw.edu.au> <20050318103326.GA18819@marowsky-bree.de> <6ivqg2-qsn.ln1@news.it.uc3m.es> <20050318134255.GS18819@marowsky-bree.de> <7e6rg2-pj1.ln1@news.it.uc3m.es> <423B09EF.8070708@steeleye.com> <23krg2-4rr.ln1@news.it.uc3m.es> <423B2F7C.3030907@steeleye.com> <qehtg2-6c1.ln1@news.it.uc3m.es> <423EF12A.4030207@steeleye.com> <20050321185606.GA27541@percy.comedia.it> <423F2780.5000601@steeleye.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Paul Clements <paul.clements@steeleye.com> wrote:
> At any rate, this is all irrelevant given the second part of that email 
> reply that I gave. You still have to do the bitmap combining, regardless 
> of whether two systems were active at the same time or not.

As I understand it, you want both bitmaps in order to make sure that on
resync you wipe over whatever may have been accidentally dirtied on the
other side by a clumsy admin or vicious gremlin (various guises -
software bug, journal effects, design incompetency, etc.).

Writing everything across (and ignoring the bitmap) would do the trick,
but given that we are being efficient and using bitmaps to lower the
write totals at resync time, we need to use both bitmaps so as not to
miss out on overwriting anything we should be overwriting.

But why don't we already know from the _single_ bitmap on the array
node ("the node with the array") what to rewrite in total? All writes
must go through the array. We know how many didn't go to both
components. Thus we know how many to rewrite from the survivor to the
component that we lost contact with.

Might some of the writes we don't think made it to the faulty component
actually have made it?  Sure.  But so what?  On resync we will rewrite
them because we don't think they made it.

Puzzling!

Peter


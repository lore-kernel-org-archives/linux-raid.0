From: Gil <gil@fooplanet.com>
Subject: Re: [PATCH 1/2] md bitmap bug fixes
Date: Mon, 21 Mar 2005 13:09:26 -0800
Message-ID: <423F3806.9050903@fooplanet.com>
References: <16950.5692.594941.130741@cse.unsw.edu.au> <20050318103326.GA18819@marowsky-bree.de> <6ivqg2-qsn.ln1@news.it.uc3m.es> <20050318134255.GS18819@marowsky-bree.de> <7e6rg2-pj1.ln1@news.it.uc3m.es> <423B09EF.8070708@steeleye.com> <23krg2-4rr.ln1@news.it.uc3m.es> <423B2F7C.3030907@steeleye.com> <qehtg2-6c1.ln1@news.it.uc3m.es> <423EF12A.4030207@steeleye.com> <20050321185606.GA27541@percy.comedia.it> <423F2780.5000601@steeleye.com> <qbo3h2-kjo.ln1@news.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
In-Reply-To: <qbo3h2-kjo.ln1@news.it.uc3m.es>
Sender: linux-raid-owner@vger.kernel.org
To: "Peter T. Breuer" <ptb@lab.it.uc3m.es>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Peter T. Breuer wrote:
> Paul Clements <paul.clements@steeleye.com> wrote:
> 
>> At any rate, this is all irrelevant given the second part of 
>> that email reply that I gave. You still have to do the bitmap 
>> combining, regardless of whether two systems were active at the
>> same time or not.
> 
> 
> As I understand it, you want both bitmaps in order to make sure 
> that on resync you wipe over whatever may have been accidentally 
> dirtied on the other side by a clumsy admin or vicious gremlin 
> (various guises - software bug, journal effects, design 
> incompetency, etc.).
> 
> Writing everything across (and ignoring the bitmap) would do the 
> trick, but given that we are being efficient and using bitmaps to
> lower the write totals at resync time, we need to use both 
> bitmaps so as not to miss out on overwriting anything we should 
> be overwriting.
> 
> But why don't we already know from the _single_ bitmap on the 
> array node ("the node with the array") what to rewrite in total? 
> All writes must go through the array. We know how many didn't go 
> to both components. Thus we know how many to rewrite from the 
> survivor to the component that we lost contact with.

Hi, I've been lurking on the list for a bit and am not as familiar
with md internals as most but here goes:

As I understand it, the scenario is that both systems can see
themselves as the "node with the array" after a split.  Both can go
on and modify different parts of the array.  To recover from the
split, an administrator might decide which of the nodes is correct
and then blow away the other node's data.

We need the bitwise or of both bitmaps' dirty bits in order to know
which blocks could possibly have changed while the array was split
since both sides were changing independently.  As you note, this
mechanism just a more efficient way to do things than copying every
block.

--Gil

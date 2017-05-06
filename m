From: Trevor Cordes <trevor@tecnopolis.ca>
Subject: Re: [RndTbl] Big-endian RAID5 recovery problem
Date: Sat, 6 May 2017 01:41:17 -0500
Message-ID: <20170506014117.4d3f1689@pog.tecnopolis.ca>
References: <5c6e6e5d93d4056839e4f370e00a8e08@mail.athompso.net>
        <87fugio7cy.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87fugio7cy.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Continuation of Round Table discussion <roundtable@muug.ca>, Adam Thompson <athompso@athompso.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2017-05-06 NeilBrown wrote:
> On Mon, May 01 2017, Adam Thompson wrote:
> 
> > The problem is that the disks use the v0.90 metadata format, and
> > they came from a big-endian system, not a little-endian system.  MD 
> > superblocks *since* v0.90 are endian-agnostic, but back in v0.90,
> > the superblock was byte-order specific.
> 
> Look for "--update=byteorder" in the mdadm man page.

Doh!  Make that double-doh!  So easy, yet so hidden.  I'll request one
little tweak/feature: can the man page be updated so that that option
has the word "endian" somewhere in its description?  I think most of us
did as the first attempt at helping: man mdadm, search endian.  When
that failed, no one thought to search byteorder!  Even google didn't
fix that one, at least not for my web searches.

Thanks linux-RAID guys (especially Neil), once again you make the
difficult easy.

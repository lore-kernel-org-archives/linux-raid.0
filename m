From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: RAID1 and data safety?
Date: Tue, 29 Mar 2005 14:13:57 +0200
Message-ID: <20050329121357.GK9998@marowsky-bree.de>
References: <76592C4D3DA1AC4FB8424084D10D31A80611527B@mchh2c4e.mchh.siemens.de> <6kjnh2-qn4.ln1@news.it.uc3m.es> <16969.10587.679662.55065@cse.unsw.edu.au> <8kqnh2-o1n.ln1@news.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <8kqnh2-o1n.ln1@news.it.uc3m.es>
Sender: linux-raid-owner@vger.kernel.org
To: "Peter T. Breuer" <ptb@lab.it.uc3m.es>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2005-03-29T13:26:32, "Peter T. Breuer" <ptb@lab.it.uc3m.es> wrote:

> > Not good advice.  DO put the journal on a raid device.  It is much
> > safer there.
> Two journals means two possible sources of unequal information - plus the
> two datasets.  We have been through this before. You get the journal
> you deserve.

The RAID never exposes this potential inconsistency to the higher levels
though.

Indeed, you get what you deserve.


-- 
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business


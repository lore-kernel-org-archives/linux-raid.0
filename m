From: Francois Barre <francois.barre@gmail.com>
Subject: Re: paralellism of device use in md
Date: Wed, 18 Jan 2006 18:55:04 +0100
Message-ID: <fd8d0180601180955j691f5d2bn@mail.gmail.com>
References: <20060117120927.GU7017@strugglers.net> <43CD8A73.90703@nsr500.net>
	 <dqkrfm$9k9$1@sea.gmane.org> <dqktgu$fea$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <dqktgu$fea$1@sea.gmane.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2006/1/18, Mario 'BitKoenig' Holbe <Mario.Holbe@tu-ilmenau.de>:
> Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE> wrote:
> > scheduled read-requests. Would it probably make sense to split one
> > single read over all mirrors that are currently idle?
>
> A I got it from the other thread - seek times :)
> Perhaps using some big (virtual) chunk size could do the trick? What
> about using chunks that big that seeking is faster than data-transfer...
> assuming a data rate of 50MB/s and 9ms average seek time would result in
> at least 500kB chunks, 14ms average seek time would result in at least
> 750kB chunks.
> However, since the blocks being read are most likely somewhat close
> together, it's not a typical average seek, so probably smaller chunks
> would also be possible.
>
>
> regards
>   Mario

Stop me if I'm wrong, but this is called... huge readahead. Instead of
reading 32k on drive0 then 32k on drive1, you read continuous 512k
from drive0 (16*32k) and 512k from drive1, resulting in a 1M read.
Maybe for a single 4k page...

So my additionnal question to this would be : how well does md fit
with linux's/fs readahead policies ?

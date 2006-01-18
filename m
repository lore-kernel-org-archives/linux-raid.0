From: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: paralellism of device use in md
Date: Wed, 18 Jan 2006 09:16:30 +0100
Message-ID: <dqktgu$fea$1@sea.gmane.org>
References: <20060117120927.GU7017@strugglers.net> <43CD8A73.90703@nsr500.net> <dqkrfm$9k9$1@sea.gmane.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE> wrote:
> scheduled read-requests. Would it probably make sense to split one
> single read over all mirrors that are currently idle?

A I got it from the other thread - seek times :)
Perhaps using some big (virtual) chunk size could do the trick? What
about using chunks that big that seeking is faster than data-transfer...
assuming a data rate of 50MB/s and 9ms average seek time would result in
at least 500kB chunks, 14ms average seek time would result in at least
750kB chunks.
However, since the blocks being read are most likely somewhat close
together, it's not a typical average seek, so probably smaller chunks
would also be possible.


regards
   Mario
-- 
<Sique> Huch? 802.1q? Was sucht das denn hier? Wie kommt das ans TAGgeslicht?


From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [RFC PATCH 1/3] md/isrt: base infrastructure and metadata loading
Date: Thu, 24 Apr 2014 16:55:19 -0700
Message-ID: <CAPcyv4jvjUqVvk0ZOOnxL+QNhDbhSVxLPAk60voS4WQjUrZ=ag@mail.gmail.com>
References: <20140424061756.3187.2633.stgit@viggo.jf.intel.com>
	<20140424061849.3187.48229.stgit@viggo.jf.intel.com>
	<20140424172450.7ec9452b@notabene.brown>
	<CAA9_cmcfGvBVTbxbBKBsgsnkyAux_VyKcM3V6v+tY5quQTotkQ@mail.gmail.com>
	<20140424180252.490434c6@notabene.brown>
	<CAA9_cmfLyiDQp7naxJPxRsUe-KGwRYOZF9cLNuztmLhYno11qg@mail.gmail.com>
	<20140425094454.2004b0e6@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140425094454.2004b0e6@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>, Jes Sorensen <jes.sorensen@redhat.com>, Artur Paszkiewicz <artur.paszkiewicz@intel.com>, Dave Jiang <dave.jiang@intel.com>
List-Id: linux-raid.ids

On Thu, Apr 24, 2014 at 4:44 PM, NeilBrown <neilb@suse.de> wrote:
> On Thu, 24 Apr 2014 10:33:31 -0700 Dan Williams <dan.j.williams@intel.com>
[..]
> It isn't really a big improvement, so maybe it isn't worth it.
> But it does make it obvious that we are only waiting for the reads that we
> just submitted.  With the current code I see conf->count and wonder what else
> we could be waiting for.
>
> Up to you - maybe just leave it as it is.
> (But please use 'READ', not '0' as the first arg to submit_bio).
>

Will do, and for the other point I do like the removal of
unnecessarily global state.

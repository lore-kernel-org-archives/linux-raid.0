From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH v3 5/9] raid5-ppl: Partial Parity Log write logging
 implementation
Date: Thu, 9 Feb 2017 09:13:14 -0800
Message-ID: <20170209171314.qrmdltnk2tzaooex@kernel.org>
References: <20170130185953.30428-1-artur.paszkiewicz@intel.com>
 <20170130185953.30428-6-artur.paszkiewicz@intel.com>
 <20170207214225.3jenvleiz3tldzlx@kernel.org>
 <43b52cb7-b9d6-f615-d7c0-d78fdbb9a0cd@intel.com>
 <20170208053444.b4yfmahmlrjgvv7x@kernel.org>
 <589C9368.1020602@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <589C9368.1020602@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: Artur Paszkiewicz <artur.paszkiewicz@intel.com>, linux-raid@vger.kernel.org, shli@fb.com, neilb@suse.com, jes.sorensen@gmail.com
List-Id: linux-raid.ids

On Thu, Feb 09, 2017 at 04:06:00PM +0000, Wols Lists wrote:
> On 08/02/17 05:34, Shaohua Li wrote:
> > so it's the implementation which doesn't flush disk cache before writting new
> > data to disks, right? That makes sense then. I think we should fix this soon.
> > Don't think people will (or remember to) disable write-back cache before using
> > ppl.
> 
> Dunno whether I'm making a fool of myself :-) but might a quick-n-dirty
> workaround be to make enabling PPL also disable write-back cache? With
> maybe a warning not to switch it back on?

We don't have API for this in kernel side. This doesn't mean we can't add it
but since the limitation is in the implementation, we'd better fix the
implementation.

Thanks,
Shaohua

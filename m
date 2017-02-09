From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: [PATCH v3 5/9] raid5-ppl: Partial Parity Log write logging
 implementation
Date: Thu, 9 Feb 2017 16:06:00 +0000
Message-ID: <589C9368.1020602@youngman.org.uk>
References: <20170130185953.30428-1-artur.paszkiewicz@intel.com>
 <20170130185953.30428-6-artur.paszkiewicz@intel.com>
 <20170207214225.3jenvleiz3tldzlx@kernel.org>
 <43b52cb7-b9d6-f615-d7c0-d78fdbb9a0cd@intel.com>
 <20170208053444.b4yfmahmlrjgvv7x@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170208053444.b4yfmahmlrjgvv7x@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Cc: linux-raid@vger.kernel.org, shli@fb.com, neilb@suse.com, jes.sorensen@gmail.com
List-Id: linux-raid.ids

On 08/02/17 05:34, Shaohua Li wrote:
> so it's the implementation which doesn't flush disk cache before writting new
> data to disks, right? That makes sense then. I think we should fix this soon.
> Don't think people will (or remember to) disable write-back cache before using
> ppl.

Dunno whether I'm making a fool of myself :-) but might a quick-n-dirty
workaround be to make enabling PPL also disable write-back cache? With
maybe a warning not to switch it back on?

Cheers,
Wol

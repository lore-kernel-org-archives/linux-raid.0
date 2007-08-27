From: "saeed bishara" <saeed.bishara@gmail.com>
Subject: Re: [md-accel PATCH 16/19] dmaengine: driver for the iop32x, iop33x, and iop13xx raid engines
Date: Mon, 27 Aug 2007 16:14:13 +0300
Message-ID: <c70ff3ad0708270614t6f17b38nfbdf84ace69b8d78@mail.gmail.com>
References: <20070627014823.18962.96398.stgit@dwillia2-linux.ch.intel.com>
	 <20070627015155.18962.88413.stgit@dwillia2-linux.ch.intel.com>
	 <c70ff3ad0708270611x5598fa9dlc3afa5f6fabd6563@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <c70ff3ad0708270611x5598fa9dlc3afa5f6fabd6563@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.de, akpm@linux-foundation.org, davem@davemloft.net, christopher.leech@intel.com, shannon.nelson@intel.com, herbert@gondor.apana.org.au, jeff@garzik.org
List-Id: linux-raid.ids

Hi Dan,
I think you have a bug in this function, the list_splice_init adds the
new slots in the head of the chain_node, but you get the
old_chain_tail (latest descriptor) from the tail of the chain!!

 > +static dma_cookie_t
 > +iop_adma_tx_submit(struct dma_async_tx_descriptor *tx)
 > +{
 > +
 > +       old_chain_tail = list_entry(iop_chan->chain.prev,
 > +               struct iop_adma_desc_slot, chain_node);
 > +       list_splice_init(&sw_desc->group_list, &old_chain_tail->chain_node);
 > +
 > +       /* fix up the hardware chain */
 > +       iop_desc_set_next_desc(old_chain_tail, grp_start->phys);
 > +

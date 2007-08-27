From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: RE: [md-accel PATCH 16/19] dmaengine: driver for the iop32x, iop33x, and iop13xx raid engines
Date: Mon, 27 Aug 2007 12:31:10 -0700
Message-ID: <0C7297FA1D2D244A9C7F6959C0BF1E52025B10E4@azsmsx413.amr.corp.intel.com>
References: <20070627014823.18962.96398.stgit@dwillia2-linux.ch.intel.com> <20070627015155.18962.88413.stgit@dwillia2-linux.ch.intel.com> <c70ff3ad0708270611x5598fa9dlc3afa5f6fabd6563@mail.gmail.com> <c70ff3ad0708270614t6f17b38nfbdf84ace69b8d78@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <c70ff3ad0708270614t6f17b38nfbdf84ace69b8d78@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: saeed bishara <saeed.bishara@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.de, "Nelson, Shannon" <shannon.nelson@intel.com>
List-Id: linux-raid.ids

> From: saeed bishara [mailto:saeed.bishara@gmail.com]
> Hi Dan,
> I think you have a bug in this function, the list_splice_init adds the
> new slots in the head of the chain_node, but you get the
> old_chain_tail (latest descriptor) from the tail of the chain!!
> 
>  > +static dma_cookie_t
>  > +iop_adma_tx_submit(struct dma_async_tx_descriptor *tx)
>  > +{
>  > +
>  > +       old_chain_tail = list_entry(iop_chan->chain.prev,
>  > +               struct iop_adma_desc_slot, chain_node);
>  > +       list_splice_init(&sw_desc->group_list, &old_chain_tail-
> >chain_node);
>  > +
>  > +       /* fix up the hardware chain */
>  > +       iop_desc_set_next_desc(old_chain_tail, grp_start->phys);
>  > +
[ dropped akpm, davem, jeff, and chris from the cc ]

This looks ok to me.  &sw_desc->group_list is the head of a new list of
descriptors to be added to the chain.  old_chain_tail is youngest
descriptor at the end of the current channel chain.

Before list_splice_init:
old_chain_tail->next = channel_chain_head
channel_chain_head->prev = old_chain_tail
new_chain_start->prev = sw_desc->group_list;
new_chain_end->next = sw_desc->group_list;

After list_splice_init:
new_chain_start->prev = old_chain_tail
old_chain_tail->next = new_chain_start
new_chain_end->next = channel_chain_head
channel_chain_head->prev = new_chain_end

sw_desc->group_list is empty

--
Dan

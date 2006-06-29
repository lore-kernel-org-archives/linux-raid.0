From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 000 of 006] raid5: Offload RAID operations to a
	workqueue
Date: Thu, 29 Jun 2006 10:37:29 +0200
Message-ID: <1151570249.3122.11.camel@laptopd505.fenrus.org>
References: <1151519032.2232.62.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1151519032.2232.62.camel@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: NeilBrown <neilb@suse.de>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 2006-06-28 at 11:23 -0700, Dan Williams wrote:
> This patch set is a step towards enabling hardware offload in the
> md-raid5 driver.  These patches are considered experimental and are not
> yet suitable for production environments.
> 
> As mentioned, this patch set is the first step in that it moves work
> from handle_stripe5 to a work queue.  

Hi,

since using work queues involve more context switches than doing things
inline... have you measured the performance impact of your changes? If
so... was there any impact that you could measure, and how big was that?

Greetings,
    Arjan van de Ven


From: Christoph Hellwig <hch@infradead.org>
Subject: Re: examining the layout of an existing raid device?
Date: Mon, 26 Sep 2011 06:45:59 -0400
Message-ID: <20110926104559.GA20448@infradead.org>
References: <20110926101824.GA30509@infradead.org>
 <20110926203248.7ff8303f@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110926203248.7ff8303f@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Sep 26, 2011 at 08:32:48PM +1000, NeilBrown wrote:
> On Mon, 26 Sep 2011 06:18:24 -0400 Christoph Hellwig <hch@infradead.org>
> wrote:
> 
> > Maybe I'm just stupid, but is there a way to figure out the exact
> > geometry (e.g. pretty print of the superblock) for an existing array
> > somehow?  I couldn't find anything in the mdadm man page for it.
> 
> mdadm -E /dev/sda
> 
> will print the metadata on device /dev/sda which describes the array that it
> is a member of.

Ok, that includes the information I was looking for, including the
chunk size, and layout.


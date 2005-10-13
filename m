From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH md 003 of 5] Add kobject/sysfs support to raid5
Date: Thu, 13 Oct 2005 15:24:07 +1000
Message-ID: <17229.61303.336584.706469@cse.unsw.edu.au>
References: <20051004151922.28715.patches@notabene>
	<1051004052339.28815@suse.de>
	<20051011165437.7d09468c.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andrew Morton on Tuesday October 11
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday October 11, akpm@osdl.org wrote:
> NeilBrown <neilb@suse.de> wrote:
> >
> > +static ssize_t
> > +raid5_store_stripe_cache_size(raid5_conf_t *conf, const char *page, ssize_t len)
> > +{
> > +	char *end;
> > +	int new;
> > +	if (len >= PAGE_SIZE)
> > +		return -EINVAL;
> 
> Can `len' be negative?

No, because sysfs_write_file only calls flush_write_buffer
with a 'len' that is >0, and this is the only path that leads to
raid5_store_stripe_cache_size.
Do you think I should be defensive and double-check in
raid5_attr_store?

NeilBrown

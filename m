From: Shaohua Li <shli@kernel.org>
Subject: Re: Write to the degraded raid5 will trigger the call trace dump
 when skip_copy is enabled
Date: Fri, 29 Apr 2016 14:17:19 -0700
Message-ID: <20160429211719.GA104659@kernel.org>
References: <CAHvN=inPP5ubYK1YkNW_B1b9ouhqBo8qMMfVcGSjddMYekDEng@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHvN=inPP5ubYK1YkNW_B1b9ouhqBo8qMMfVcGSjddMYekDEng@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Joey Liao <joeyliao@qnap.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Apr 29, 2016 at 06:54:10PM +0800, Joey Liao wrote:
> Hi all,
> 
> For improving the I/O performance, we try to enable the raid 5
> skip_copy feature by default. It indeed has some benefit, however, it
> will always (not a random issue) dump the following call trace
> repeatedly when we try to write the raid 5 block device. It is related
> to the following codes in handle_stripe_clean_event() in raid5.c.
> 
> WARN_ON(test_bit(R5_SkipCopy, &dev->flags));
> WARN_ON(dev->page != dev->orig_page);
> 
> Is it a known bug for skip_copy feature?
> Does it do harm to the data integrity?
> If we would like to prevent this call trace, for your suggestion how
> should we do to modify the source code?

Looks the two WARN_ON should be deleted. if the dev has R5_LOCKED, it's legit
the dev has SkipCopy set and page != orig_page. I'll delete the code. This will
not harm to data integrity.

Thanks,
Shaohua

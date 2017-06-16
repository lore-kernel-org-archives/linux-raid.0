From: "Peter Sangas" <pete@wnsdev.com>
Subject: RE: mismatch_cnt > 0 during initial sync?
Date: Fri, 16 Jun 2017 10:28:50 -0700
Message-ID: <003a01d2e6c6$054e8230$0feb8690$@wnsdev.com>
References: <9A8A3C34-EED0-42FF-B631-7AD1D6EAF9A2@stanford.edu> <D974501A-3A8C-438B-A043-8E44DE6D18C7@stanford.edu>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <D974501A-3A8C-438B-A043-8E44DE6D18C7@stanford.edu>
Content-Language: en-us
Sender: linux-raid-owner@vger.kernel.org
To: 'Stephane Thiell' <sthiell@stanford.edu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> -----Original Message-----
> From: Stephane Thiell [mailto:sthiell@stanford.edu]
> Subject: Re: mismatch_cnt > 0 during initial sync?
> 
> I just did some tests and this seems normal if one of the raid disk
previously has
> some non-zero data.  Perhaps there should be a note about that in md(4) or
> elsewhere? (sorry if I missed it)

Hi Stephane,

I also thought mismatch_cnt should = 0 after a sync.  I am wondering if you
ran the repair command?

echo repair >> /sys/block/mdX/md/sync_action

Thanks,
Pete





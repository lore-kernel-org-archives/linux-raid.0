From: "majianpeng" <majianpeng@gmail.com>
Subject: Re: Re: md/raid5:Fix recover/replace stop if handle stipe failed
Date: Wed, 28 Mar 2012 09:45:40 +0800
Message-ID: <201203280945342813684@gmail.com>
References: <201203141507458909278@gmail.com>,
 <201203141727412189832@gmail.com>,
 <20120327142642.3e40547d@notabene.brown>,
 <201203271533149067900@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>However I don't agree that we need to set 'abort = 1' in the non-RECOVERY
>>case.
But the origial code is:
md_done_sync(conf->mddev, STRIPE_SECTORS, 0)
This mean you will interrunt the resync.

------------------				 
majianpeng
2012-03-28



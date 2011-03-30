From: Iordan Iordanov <iordan@cdf.toronto.edu>
Subject: Re: raid6 + caviar black + mpt2sas horrific performance
Date: Wed, 30 Mar 2011 15:26:44 -0400
Message-ID: <4D9383F4.6090600@cdf.toronto.edu>
References: <20110330080823.GA9167@apartia.fr> <4D933435.3010709@gmail.com> <20110330152011.GA6863@apartia.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110330152011.GA6863@apartia.fr>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

In case this helps focus minds, we had horrendous performance of a 30 
1TB disk RAID10 with LVM on top of it (1MB chunks), so we ended up doing 
RAID1 mirrors with LVM striping on top in order to alleviate it.

We were not in a position to try to debug why RAID10 would not play nice 
with LVM, since deadlines were looming...

Cheers,
Iordan

From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: mdadm raid1 read performance
Date: Wed, 04 May 2011 14:31:18 +0800
Message-ID: <4DC0F2B6.9050708@fnarfbargle.com>
References: <BANLkTim8Ehn0fANtibg7X1cMVvOgt7CNMA@mail.gmail.com> <20110504105822.21e23bc3@notabene.brown> <BANLkTimzqu1C+_Z2t5m1bjduXFeRwbgssQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTimzqu1C+_Z2t5m1bjduXFeRwbgssQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Drew <drew.kay@gmail.com>
Cc: NeilBrown <neilb@suse.de>, Liam Kurmos <quantum.leaf@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/05/11 13:30, Drew wrote:

> It seemed logical to me that if two disks had the same data and we
> were reading an arbitrary amount of data, why couldn't we split the
> read across both disks? That way we get the benefits of pulling from
> multiple disks in the read case while accepting the penalty of a write
> being as slow as the slowest disk..
>
>

I would have thought as you'd be skipping alternate "stripes" on each 
disk you minimise the benefit of a readahead buffer and get subjected to 
seek and rotational latency on both disks. Overall you're benefit would 
be slim to immeasurable. Now on SSD's I could see it providing some 
extra oomph as you suffer none of the mechanical latency penalties.


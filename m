From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Alignment of RAID on specific boundary
Date: Tue, 05 Jan 2010 15:35:10 +0000
Message-ID: <4B435C2E.4000201@anonymous.org.uk>
References: <7b3edae11001041130n42d053fcpc4923b22278c5671@mail.gmail.com>	 <4877c76c1001042257h49103054t977de11410eb65c6@mail.gmail.com> <7b3edae11001050544p4f99d7dbq83b72e385151c27@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7b3edae11001050544p4f99d7dbq83b72e385151c27@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Khelben Blackstaff <eye.of.the.8eholder@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 05/01/2010 13:44, Khelben Blackstaff wrote:
[...]
> Then my understanding of "data offset" is correct. I need to move
> this offset from 136 sectors to 512 sectors.

Or move your partition start back by 136 sectors, or use version 0.90 or 
1.0 superblocks which have the superblock at the end.

Cheers,

John.

From: Neil Brown <neilb@suse.de>
Subject: Re: blog entry on RAID limitation
Date: Mon, 23 Jan 2006 10:08:48 +1100
Message-ID: <17364.4224.511674.30104@cse.unsw.edu.au>
References: <20060122115231.9294.qmail@web52910.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Rik Herrin on Sunday January 22
Sender: linux-raid-owner@vger.kernel.org
To: Rik Herrin <rikherrin@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday January 22, rikherrin@yahoo.com wrote:
> Wouldn't connecting a UPS + using a stable kernel
> version remove 90% or so of the "RAID-5 write hole"
> problem?  Are there any other means to know when this
> has occurred?

A UPS would help, as would a well-tested stable kernel.
However sometimes power supplies die, so make sure you have two of
them...

Yes, there are several ways to mitigate the risk.  However they cost
money and the risk is actually already very small in the first place.  
Coming up with a by-design approach that removes the risk completely
is still a good goal, providing the performance costs are reasonable
(i.e. almost zero).

NeilBrown

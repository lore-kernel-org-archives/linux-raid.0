From: Neil Brown <neilb@suse.de>
Subject: Re: Linux md and iscsi problems
Date: Sun, 3 Feb 2008 08:44:31 +1100
Message-ID: <18340.58431.163856.338970@notabene.brown>
References: <20080201115919.5qx4ih3zeogswc4w@webmail.ualberta.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from aristizb@ualberta.ca on Friday February 1
Sender: linux-raid-owner@vger.kernel.org
To: aristizb@ualberta.ca
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday February 1, aristizb@ualberta.ca wrote:
> 
> 
> Summarizing, I have two questions about the behavior of Linux md with  
> slow devices:
> 
> 1. Is it possible to modify some kind of time-out parameter on the  
> mdadm tool so the slow device wouldn't be marked as faulty because of  
> its slow performance.

No.  md doesn't do timeouts at all.  The underlying device does.
So if you are getting time out errors from the iscsi initiator, then
you need to change the timeout value used by the iscsi initiator.  md
has no part to play in this.  It just sends a request and eventually
gets either 'success' or 'fail'.

> 
> 2. Is it possible to control the "buffer" size of the RAID?, in other  
> words, can I control the amount of data I can write to the local disc  
> before I receive an acknowledgment from the slow device when I am  
> using the write-behind option.

No.  md/raid1 simply calls 'kmalloc' to get space to buffer each write
as the write arrives.  If the allocation succeeds, it is used to
perform the write lazily.  If the allocation fails, the write is
performs synchronously.

What did you hope to achieve by such tuning?  It can probably be
added if it is generally useful.

NeilBrown

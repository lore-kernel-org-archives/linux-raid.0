From: Neil Brown <neilb@suse.de>
Subject: Re: Multipath behavior
Date: Thu, 8 May 2008 15:12:40 +1000
Message-ID: <18466.35784.682339.288410@notabene.brown>
References: <135ea5430804221048g2e0ba8ci3d96a23ed9afdea5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Billy Crook on Tuesday April 22
Sender: linux-raid-owner@vger.kernel.org
To: Billy Crook <bcrook@advancedclustering.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday April 22, bcrook@advancedclustering.com wrote:
> I am considering implementing multipath for iSCSI.  Documentation is
> scant though, so I thought I'd ask my questions here.
> 
> Does mdadm multipath loadbalance IO, or just allow for failover, or both?
> Is there any advantage to notifying mdadm pre-emptively if possible
> before a path goes down?
> I assume bringing a path online has to be done manually like adding a
> disk.  Can spare paths be used?
> 
> The kernel involved is 2.6.18-53.1.14.el5.
> 
> Thank you for your time.

I recommend against using md based multipath.  It is not being
seriously maintained.
dm (aka device mapper) based multipath is where the action is.

NeilBrown

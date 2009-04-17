From: Neil Brown <neilb@suse.de>
Subject: Re: prefered way to update mdadm/mdadm.conf
Date: Sat, 18 Apr 2009 08:41:49 +1000
Message-ID: <18921.1453.388655.210353@notabene.brown>
References: <001b01c9bfa1$c5bd30c0$0a00a8c0@vorg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Timothy D. Lenz on Friday April 17
Sender: linux-raid-owner@vger.kernel.org
To: "Timothy D. Lenz" <tlenz@vorgon.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday April 17, tlenz@vorgon.com wrote:
> There seems to be 2 ways to update mdadm.conf. One puts a little more info in and both create duplicate info that msut be removed.
> Which is the better way:
> 
> mdadm --examine --scan >> /etc/mdadm/mdadm.conf
> mdadm --detail --scan >> /etc/mdadm/mdadm.conf

The best way to create mdadm.conf is with an editor.
Understand the syntax of the file, understand what you want mdadm to
do to assemble/monitor arrays.  And create a file that suits.
The two commands are useful for pre-populating the file but should not
be considered a 'final' answer.
They are useful in different contexts.

> 
> Also, is there a way to check if mdadm "damenised" at boot for
> sending email alerts? mdstat only list the arrays, not any kind of 
> monitoring level.

"ps axgu  | grep mdadm"

is a good way.

NeilBrown

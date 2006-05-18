From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm: bitmap size
Date: Fri, 19 May 2006 09:51:43 +1000
Message-ID: <17517.2191.803890.424144@cse.unsw.edu.au>
References: <446D0119.1010508@phx6a.ath.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Ste on Friday May 19
Sender: linux-raid-owner@vger.kernel.org
To: Ste <ste@phx6a.ath.cx>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday May 19, ste@phx6a.ath.cx wrote:
> Hi all, i have this problem:
> 
> I am going to do raid 1 over two virtual devices. These virtual devices 
> are two hard disks situated on other two servers.
> 
> The problem is:
> A network failure could happen often, and if it happen, i don't want to 
> recover all the disks. I want to recover just last changed things.
> 
> As i can see the bitmap do exactly this, but the default bitmap is too 
> small!

Why do you say that?
Are you using an internal bitmap, or a bitmap in a separate file?

> There is no problem to have a bitmap file of 1 Gb, but i can't find the 
> way to tell to mdadm the size to use for the bitmap file.

The only way to control the size of the bitmap is the change the
bitmap chunk size.
Warning: if you have more than 1 million bits in the bitmap, the
kernel may fail in memory allocation and may not be able to assemble
your array.

NeilBrown

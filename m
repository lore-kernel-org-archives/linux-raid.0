From: Joe Pruett <joey@clean.q7.com>
Subject: Re: ANNOUNCE: mdadm 1.6.0 - A tool for managing Soft RAID under   
   Linux
Date: Mon, 7 Jun 2004 08:54:49 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0406070853140.25203-100000@q7.q7.com>
References: <ca16n8$k3p$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ca16n8$k3p$1@sea.gmane.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> You don't need LVM and thus you have one less layer
> with potential failures and errors.

using lvm for just partitioning would be silly.  but lvm gives you much
more than that.  the ability to span partitions over multiple raid arrays.  
and the main reason i use it is to be able to grow/shrink storage if
something changes in the future.


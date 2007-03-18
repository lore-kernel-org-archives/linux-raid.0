From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Linux-usb-users] Failed reads from RAID-0 array (from newbie
     who has read the FAQ)
Date: Sat, 17 Mar 2007 22:06:46 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0703172204450.15801-100000@netrider.rowland.org>
References: <2885.72.21.237.163.1174167308.squirrel@www.multitool.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2885.72.21.237.163.1174167308.squirrel@www.multitool.net>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Schwarz <mschwarz@multitool.net>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, linux-usb-users@lists.sourceforge.net
List-Id: linux-raid.ids

On Sat, 17 Mar 2007, Michael Schwarz wrote:

> Comments/questions below...
> 
> -- 
> Michael Schwarz
>
> > This isn't much help.  The important processes here are khubd,
> > usb-storage, and scsi_eh_*.  Possibly some raid-related processes too, but
> > I don't know which they would be.
> 
> I have no copy khubd running.

That in itself is a very bad sign.  You need to look at the dmesg log.

Alan Stern


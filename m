From: Holger Kiehl <Holger.Kiehl@dwd.de>
Subject: Re: possible to use 1 drive as hot failover for 2 raid1's?
Date: Tue, 7 Oct 2003 12:40:26 +0000 (GMT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0310071235060.12097-100000@praktifix.dwd.de>
References: <20031007105437.GF28158@marowsky-bree.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20031007105437.GF28158@marowsky-bree.de>
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, 7 Oct 2003, Lars Marowsky-Bree wrote:

> On 2003-10-06T16:27:59,
>    Dan Hollis <goemon@anime.net> said:
> 
> > is it possible to use the single drive as hot-failover for both md0 and 
> > md1?
> 
> In theory yes, in practice not.
> 
> One could imagine (rather easily) a global hot-spare pool for all mds,
> but it's not implemented right now.
> 
Not sure about this but I thought this would be possible by using mdadm
in monitor mode? In the manpage of mdadm it says:

   As  well  as  reporting  events,  mdadm may move a spare drive from one
   array to another if they are in the same spare-group and if the  desti-
   nation array has a failed drive but not spares.

But I don't know how to create a spare-groupi or what is meant by it?

Regards,
Holger


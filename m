From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: possible to use 1 drive as hot failover for 2 raid1's?
Date: Thu, 16 Oct 2003 13:42:48 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16270.5048.970101.522470@notabene.cse.unsw.edu.au>
References: <20031007105437.GF28158@marowsky-bree.de>
	<Pine.LNX.4.44.0310071235060.12097-100000@praktifix.dwd.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Holger Kiehl on Tuesday October 7
To: Holger Kiehl <Holger.Kiehl@dwd.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tuesday October 7, Holger.Kiehl@dwd.de wrote:
> On Tue, 7 Oct 2003, Lars Marowsky-Bree wrote:
> 
> > On 2003-10-06T16:27:59,
> >    Dan Hollis <goemon@anime.net> said:
> > 
> > > is it possible to use the single drive as hot-failover for both md0 and 
> > > md1?
> > 
> > In theory yes, in practice not.
> > 
> > One could imagine (rather easily) a global hot-spare pool for all mds,
> > but it's not implemented right now.
> > 
> Not sure about this but I thought this would be possible by using mdadm
> in monitor mode? In the manpage of mdadm it says:
> 
>    As  well  as  reporting  events,  mdadm may move a spare drive from one
>    array to another if they are in the same spare-group and if the  desti-
>    nation array has a failed drive but not spares.
> 
> But I don't know how to create a spare-groupi or what is meant by it?

 From  "man mdadm"

       For  mdadm  to  move  spares  from  one array to another, the different
       arrays need to be labelled with the same spare-group in the  configura-
       tion  file.   The spare-group name can be any string. It is only neces-
       sary that different spare groups use different names.

 from "man mdadm.conf"

           spare-group=
                  The  value  is  a  textual  name for a group of arrays.  All
                  arrays with the same spare-group name are considered  to  be
                  part  of  the  same  group.   The significance of a group of
                  arrays is that mdadm will, when monitoring the arrays,  move
                  a  spare drive from one array in a group to another array in
                  that group if the first array had a failed or missing  drive
                  but no spare.


does that help?

NeilBrown

> 
> Regards,
> Holger
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

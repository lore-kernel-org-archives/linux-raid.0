From: Ming Zhang <mingz@ele.uri.edu>
Subject: Re: consistency detect
Date: Mon, 11 Oct 2004 20:43:20 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1097541799.3103.106.camel@localhost.localdomain>
References: <1097465522.3111.24.camel@localhost.localdomain>
	 <16747.5613.417433.425637@cse.unsw.edu.au>
	 <1097539511.3103.78.camel@localhost.localdomain>
	 <16747.8619.449429.397300@cse.unsw.edu.au>
Reply-To: mingz@ele.uri.edu
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16747.8619.449429.397300@cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 2004-10-11 at 20:13, Neil Brown wrote:
> On Monday October 11, mingz@ele.uri.edu wrote:
> > :) thanks a lot. so now i know what policy raid1 use. so raid1 will
> > randomly choose first drive and sync among all drives. so here comes to
> > another question. after a power loss and reboot, raid1 knows that there
> > are something wrong and potentially out of sync between two drives. will
> > it try to check and make sure two drives are in sync or it just leave
> > two drives there with potential unmatched blocks.
> > 
> > for example, before reboot, a write to location A happen in progress.
> > then after reboot. raid1 has no idea on previous write information. it
> > just knows something might happened and two drives are possible to be
> > out of sync. will it check whole drive to do a resync?
> > 
> 
> Yes.  It copies all of these first drive onto all of the other drives.
a full copy? then if u have 100GB on first disk and you have to copy
that much? with background reconstruction, this can take a long time. i
never realized the overhead is this high. so i guess if system provide u
a piece of nvram, u can do much better. :P


> 
> NeilBrown
-- 
 --------------------------------------------------
| Ming Zhang, PhD. Student
| Dept. of Electrical & Computer Engineering
| College of Engineering
| University of Rhode Island
| Kingston RI. 02881
| e-mail: mingz at ele.uri.edu
| Tel. (401) 874-2293 
| Fax. (401) 782-6422
| http://www.ele.uri.edu/~mingz/
| http://crab.ele.uri.edu/gallery/albums.php
 --------------------------------------------------



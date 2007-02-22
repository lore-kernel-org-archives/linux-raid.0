From: dean gaudet <dean@arctic.org>
Subject: Re: Reshaping raid0/10
Date: Wed, 21 Feb 2007 22:09:36 -0800 (PST)
Message-ID: <Pine.LNX.4.64.0702212110120.23743@twinlark.arctic.org>
References: <Pine.LNX.4.61.0702211726500.12039@yvahk01.tjqt.qr>
 <17884.42154.248251.261955@notabene.brown>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17884.42154.248251.261955@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 22 Feb 2007, Neil Brown wrote:

> On Wednesday February 21, jengelh@linux01.gwdg.de wrote:
> > Hello,
> > 
> > 
> > 
> > are there any plans to support reshaping
> > on raid0 and raid10?
> > 
> 
> No concrete plans.  It largely depends on time and motivation.
> I expect that the various flavours of raid5/raid6 reshape will come
> first.
> Then probably converting raid0->raid5.
> 
> I really haven't given any thought to how you might reshape a
> raid10...

i've got a 4x250 near2 i want to turn into a 4x750 near2.  i was 
considering doing straight dd from each of the 250 to the respective 750 
then doing an mdadm --create on the 750s (in the same ordering as the 
original array)... so i'd end up with a new array with more stripes.  it 
seems like this should work.

the same thing should work for all nearN with a multiple of N disks... and 
offsetN should work as well right?  but farN sounds like a nightmare.

if we had a generic "proactive disk replacement" method it could handle 
the 4x250->4x750 step.  (i haven't decided yet if i want to try my hacky 
bitmap method of doing proactive replacement... i'm not sure what'll 
happen if i add a 750GB disk back into an array with 250s... i suppose 
it'll work... i'll have to experiment.)

-dean

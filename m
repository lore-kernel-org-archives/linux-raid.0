From: "James R Bamford" <jim@jimtreats.com>
Subject: RE: Software Raid 1 data corruptions..
Date: Sun, 16 Nov 2003 19:02:58 -0000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <PPEOJEIEFLAONFNHJPOOOEFGGOAA.jim@jimtreats.com>
References: <Pine.LNX.4.44.0311161201430.12102-100000@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0311161201430.12102-100000@coffee.psychology.mcmaster.ca>
To: Mark Hahn <hahn@physics.mcmaster.ca>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



> -----Original Message-----
> From: Mark Hahn [mailto:hahn@physics.mcmaster.ca]
> Sent: 16 November 2003 17:03
> To: James R Bamford
> Subject: RE: Software Raid 1 data corruptions..
>
>
> > > > [jim@backup test]$ md5sum image.nrg
> > > >  a14990ebfd5c502a68c29e2f789a34dd  image.nrg
> > >
> > > this isn't a via motherboard, is it?  have you run memtest86
> overnight?
> >
> > Ok an update.. I've been running memtest over night, and all day, up to
> > nearly 22 hours now, its a slow computer (p3 450 with nearly
> 512meg memory)
>
> but is it via based?  unfortunately, it's basically impossible
> to make a real server (trusted under load) from anything except
> a non-via, non-sis, non-ali, non-nvidia chipset (ie, intel, amd, sw).
>
> this is failure mode independent of ram problems.
>

ok sorry... i read that as a controller via the motherboard (as in onboard)
..

Its quite an old machine as i said p3 450 .. as such i am not sure on the
motherboard.. been a good few years since i brought it... TI6NB+ is written
on the MB, i think this is by TMC.. google throws up this manual for it

http://www.mycomp.com.tw/manual/ti6nbp11.pdf

It says

Chipset
Intel 82440BX or VIA Apollo Pro Plus (82C693)

I can see an intel chip on the motherboard.. PCI chip i think its called or
ACI.. its not easily readable...

i just sat watching memtest and i'm pretty sure it reported 440BX or
something similar in its list i can test that again but currently the
computer is offline after leaving it on all the time..

I appreciate your cander in saying that it could basically be unsolvable
with this hardware.. but its kind of frustrating.. what exactly is wrong
with via, sis, ali sets... (and what is the acronymn sw for?).. in the other
reply to my posts someone else said there are loads and loads of ide raid
setups out there... those types you talk about must surely cater for a huge
share of the market..

Anyways ok.. so its unsolvable at the moment... linux in general is just not
going to work on this hardware? not in this way anyways... not sure what to
do now..

Thanks

James


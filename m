From: dean gaudet <dean@arctic.org>
Subject: Re: 2.6.24-rc6 reproducible raid5 hang
Date: Thu, 10 Jan 2008 18:14:48 -0800 (PST)
Message-ID: <alpine.DEB.0.999999.0801101813420.681@twinlark.arctic.org>
References: <alpine.DEB.0.999999.0712270845150.5207@twinlark.arctic.org> <alpine.DEB.0.999999.0712270938160.5207@twinlark.arctic.org> <Pine.LNX.4.64.0712290842530.21114@twinlark.arctic.org> <e9c3a7c20712291247u7d5f6b76gf44a1770f5cdc2cf@mail.gmail.com>
 <alpine.DEB.0.999999.0712291248490.5207@twinlark.arctic.org> <e9c3a7c20712291406ve91e0d5h72979a8dbc4c6844@mail.gmail.com> <alpine.DEB.0.999999.0712300922520.20553@twinlark.arctic.org> <1199903330.18882.7.camel@dwillia2-linux.ch.intel.com>
 <18309.25170.258730.225322@notabene.brown> <alpine.DEB.0.999999.0801092309150.27277@twinlark.arctic.org> <e9c3a7c20801101049r435548e9t5fb552750ca20310@mail.gmail.com> <18310.51834.334017.700075@notabene.brown>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18310.51834.334017.700075@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Dan Williams <dan.j.williams@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 11 Jan 2008, Neil Brown wrote:

> Thanks.
> But I suspect you didn't test it with a bitmap :-)
> I ran the mdadm test suite and it hit a problem - easy enough to fix.

damn -- i "lost" my bitmap 'cause it was external and i didn't have things 
set up properly to pick it up after a reboot :)

if you send an updated patch i'll give it another spin...

-dean

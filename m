From: "Peter Kovari" <peter@kovari.priv.hu>
Subject: RE: A few questions regarding RAID5/RAID6 recovery
Date: Tue, 26 Apr 2011 18:13:49 +0200
Message-ID: <000301cc042c$edcfc330$c96f4990$@priv.hu>
References: <002001cc0370$cd40ac90$67c205b0$@priv.hu> <ip5rnd$g96$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ip5rnd$g96$1@dough.gmane.org>
Content-Language: hu
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----Original Message-----
From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-owner@vger.kernel.org] On Behalf Of David Brown
Sent: Tuesday, April 26, 2011 9:22 AM
To: linux-raid@vger.kernel.org
Subject: Re: A few questions regarding RAID5/RAID6 recovery

> You are not alone in these concerns.  A couple of months ago there was a 
> long thread here about a roadmap for md raid.  The first two entries are 
> a "bad block log" to allow reading of good blocks from a failing disk, 
> and "hot replace" to sync a replacement disk before removing the failing 
> one.  Being on a roadmap doesn't mean that these features will make it 
> to md raid in the near future - but it does mean that there are already 
> rough plans to solve these problems.

> <http://neil.brown.name/blog/20110216044002>

Thank you David, this explains a lot. I hope we'll see this some day implemented.

Can you comment on my first question too please? Basically i'm just curious to know if there is a way to stop and restart the rebuilding process (and change/re-create the array in between them).

Btw, i read somewhere, that "--stop", then "--create --assume-clean" on an array works only on v0.9 superblocks, because v1.x overwrites existing data during create. It doesn't make sense for me - but i'm not sure -, so is this true? If not, then is it enough to use the same suberblock version for "--create" to make this work without data loss?

Thanks,
Peter



From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: high throughput storage server?
Date: Wed, 23 Feb 2011 15:11:00 -0600
Message-ID: <4D6577E4.2080305@hardwarefreak.com>
References: <AANLkTik5_Zx98rSbmpgUtG82qtFObANtCcbnn-a7MXcp@mail.gmail.com> <Pine.GSO.4.64.1102181429201.7398@montezuma.acc.umu.se> <4D5EFDD6.1020504@hardwarefreak.com> <Pine.GSO.4.64.1102211116030.7398@montezuma.acc.umu.se> <4D62DE55.8040705@hardwarefreak.com> <ijvtqg$pke$1@dough.gmane.org> <4D63BC6D.8010209@hardwarefreak.com> <ik0gkm$nn$1@dough.gmane.org> <4D64A082.9000601@hardwarefreak.com> <ik33nt$fd8$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ik33nt$fd8$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david@westcontrol.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

David Brown put forth on 2/23/2011 7:56 AM:

> However, as disks get bigger, the chance of errors on any given disk is
> increasing.  And the fact remains that if you have a failure on a RAID10
> system, you then have a single point of failure during the rebuild
> period - while with RAID6 you still have redundancy (obviously RAID5 is
> far worse here).

The problem isn't a 2nd whole drive failure during the rebuild, but a
URE during rebuild:

http://www.zdnet.com/blog/storage/why-raid-5-stops-working-in-2009/162

> I don't know if you've followed the recent "md road-map: 2011" thread (I
> can't see any replies from you in the thread), but that is my reference
> point here.

Actually I haven't.  Is Neil's motivation with this RAID5/6 "mirror
rebuild" to avoid the URE problem?

> Incidentally, what's your opinion on a RAID1+5 or RAID1+6 setup, where
> you have a RAID5 or RAID6 build from RAID1 pairs?  You get all the
> rebuild benefits of RAID1 or RAID10, such as simple and fast direct
> copies for rebuilds, and little performance degradation.  But you also
> get multiple failure redundancy from the RAID5 or RAID6.  It could be
> that it is excessive - that the extra redundancy is not worth the
> performance cost (you still have poor small write performance).

I don't care for and don't use parity RAID levels.  Simple mirroring and
RAID10 have served me well for a very long time.  They have many
advantages over parity RAID and few, if any, disadvantages.  I've
mentioned all of these in previous posts.

-- 
Stan


-- 
Stan

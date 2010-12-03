From: Michele Bonera <mbonera@gmail.com>
Subject: Re: Problems after reshaping of Raid5 array
Date: Fri, 03 Dec 2010 08:03:21 +0100
Message-ID: <1291359801.3326.161.camel@bellatrix.morrisoft.local>
References: <AANLkTinUU6Mh-cYbyCF_vL2PzGzFKMcqSZmPULxctquh@mail.gmail.com>
	 <20101130084501.702e7486@notabene.brown>
	 <1291101780.15141.4.camel@bellatrix.morrisoft.local>
	 <4CF55465.5070804@computer.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4CF55465.5070804@computer.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jan Ceuleers <jan.ceuleers@computer.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Il giorno mar, 30/11/2010 alle 20.45 +0100, Jan Ceuleers ha scritto:

> On 30/11/10 08:23, Michele Bonera wrote:
> >> It appears that the partition you created on the new device started at a
> >> multiple of 64K.  When this happen, the superblock at the end of the
> >> partition also looks valid when seen at the end of the whole device.
> >> Somehow mdadm got confused and choose the whole device (sdc) instead of the
> >> partition (sdc1).
> >
> > I did it and it worked! Thanks a lot Neil!!!
> Michele,
> Does it survive a reboot?
> Jan

Yes. Now it's working perfectly...

Bye
--
Michele Bonera
linux user group brescia


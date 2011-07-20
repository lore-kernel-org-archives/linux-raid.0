From: <brian.foster@emc.com>
Subject: RE: RAID 1 using SSD and 2 HDD
Date: Wed, 20 Jul 2011 08:59:04 -0400
Message-ID: <24EACA6AC4B506428C92FE7C172FEF4E02084CF0@MX16A.corp.emc.com>
References: <4E25C9BA.1060401@dodtsair.com> <20110720003235.51b3a657@natsu>
 <4E25D775.1080406@dodtsair.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E25D775.1080406@dodtsair.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: mpower@dodtsair.com, rm@romanrm.ru
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Mike Power
> Sent: Tuesday, July 19, 2011 3:14 PM
> To: Roman Mamedov
> Cc: linux-raid@vger.kernel.org
> Subject: Re: RAID 1 using SSD and 2 HDD
> 
> Thanks for the link.  That is the kind of thing I am looking for.
> 
> On 07/19/2011 11:32 AM, Roman Mamedov wrote:
> > On Tue, 19 Jul 2011 11:15:22 -0700
> > Mike Power<mpower@dodtsair.com>  wrote:
> >
> >> Is it possible to implement a RAID 1 array using two equal size HDD
> >> and one smaller and faster SSD.  The idea being that the resulting
> >> RAID would have the same size of the HDD while picking up the speed
> >> benefits of the SSD.
> > See http://bcache.evilpiepirate.org/
> >

Also, Roberto referred to the facebook flashcache implementation. It is based on device-mapper and last I tried bcache, probably a bit more production-worthy at the moment (though bcache looks intriguing long term, so I'd suggest to try both and draw your own conclusion):

https://github.com/facebook/flashcache

Brian


From: Yann Ormanns <yann-ormanns@web.de>
Subject: Re: Do I understand my RAID6 correctly?
Date: Tue, 12 Apr 2011 19:17:15 +0200
Message-ID: <4DA4891B.6050505@web.de>
References: <4DA40FA4.80605@xunil.at> <4DA41A18.9030602@web.de> <4DA42C92.8010704@xunil.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DA42C92.8010704@xunil.at>
Sender: linux-raid-owner@vger.kernel.org
To: lists@xunil.at
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Subject: Re: Do I understand my RAID6 correctly?
From: Stefan G. Weichinger <lists@xunil.at>
To: Yann Ormanns <yann-ormanns@web.de>
Date: 2011-04-12 19:03 (+0200)
>
> I already exported the controller-logs and will look through for SMART
> info. Unfortunately the controller does not allow the use of
> smartmontools, I can only use the specific ICP Storage Manager.
> 

I recommend to compare the active hours and the serial numbers of the
disks. So you can _perhaps_ predict the next disk with problems.
Unfortunately, SMART-data is no credible basis for any hard disk failure
predictions.
For further information, you may want to take a look at this german
link:
http://www.heise.de/newsticker/meldung/Google-Studie-zur-Ausfallursache-von-Festplatten-147178.html
and / or at this document http://labs.google.com/papers/disk_failures.pdf

> 
> Scary. Yes, the server uses the same model for all 9 devices.

Yeah, that's really scary - it shows, that even with a RAID6 your data
is not absolutely safe. But I have to admit that this is "only" the
worst case scenario - the chance that this situation occurs, is really
small (but not impossible).
I suppose, that your customer keeps his backups up to date although he
uses a RAID6?

> From your domain I see that you seem to be located in germany, so you
> might know the manufacturer of the server: transtec.
> 

No, I do not know this manucaturer - but I'm just a private user, so I
don't really have any experiences with "real" servers :)

Best regards,
Yann

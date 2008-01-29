From: Moshe Yudkowsky <moshe@pobox.com>
Subject: Re: In this partition scheme, grub does not find md information?
Date: Tue, 29 Jan 2008 05:29:27 -0600
Message-ID: <479F0E17.30409@pobox.com>
References: <479EAF42.6010604@pobox.com> <18334.46306.611615.493031@notabene.brown> <479F07E1.7060408@pobox.com> <479F0AAB.3090702@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <479F0AAB.3090702@rabbit.us>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Rabbitson <rabbit+list@rabbit.us>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Peter Rabbitson wrote:

> It is exactly what the names implies - a new kind of RAID :) The setup 
> you describe is not RAID10 it is RAID1+0. As far as how linux RAID10 
> works - here is an excellent article: 
> http://en.wikipedia.org/wiki/Non-standard_RAID_levels#Linux_MD_RAID_10

Thanks. Let's just say that the md(4) man page was finally penetrating 
my brain, but the Wikipedia article helped a great deal. I had thought 
md's RAID10 was more "standard."

-- 
Moshe Yudkowsky * moshe@pobox.com * www.pobox.com/~moshe
"Rumor is information distilled so finely that it can filter through 
anything."
          --  Terry Pratchet, _Feet of Clay_

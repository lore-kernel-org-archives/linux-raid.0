From: Moshe Yudkowsky <moshe@pobox.com>
Subject: Re: In this partition scheme, grub does not find md information?
Date: Tue, 29 Jan 2008 18:32:54 -0600
Message-ID: <479FC5B6.10308@pobox.com>
References: <18334.46306.611615.493031@notabene.brown> <479F07E1.7060408@pobox.com> <479F0AAB.3090702@rabbit.us> <479F331F.7080902@msgid.tls.msk.ru> <479F3C74.1050605@rabbit.us> <479F42A5.8040007@msgid.tls.msk.ru> <479F5177.6060206@pobox.com> <479F557D.20502@rabbit.us> <479F7FCD.7030106@pobox.com> <479FBA54.6010009@tmr.com> <20080130002237.GC7975@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080130002237.GC7975@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> Hmm, why would you put swap on a raid10? I would in a production
> environment always put it on separate swap partitions, possibly a number,
> given that a number of drives are available.

I put swap onto non-RAID, separate partitions on all 4 disks.

In a production server, however, I'd use swap on RAID in order to 
prevent server downtime if a disk fails -- a suddenly bad swap can 
easily (will absolutely?) cause the server to crash (even though you can 
boot the server up again afterwards on the surviving swap partitions).

-- 
Moshe Yudkowsky * moshe@pobox.com * www.pobox.com/~moshe
  "She will have fun who knows when to work
   and when not to work."
    			-- Segami

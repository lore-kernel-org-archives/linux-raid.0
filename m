From: Tim Southerwood <ts@dionic.net>
Subject: Re: Loop devices to RAID? (was Re: In this partition scheme, grub
 does not find md information?)
Date: Wed, 30 Jan 2008 15:56:11 +0000
Message-ID: <47A09E1B.5070705@dionic.net>
References: <479F07E1.7060408@pobox.com> <479F0AAB.3090702@rabbit.us> <479F331F.7080902@msgid.tls.msk.ru> <479F3C74.1050605@rabbit.us> <479F42A5.8040007@msgid.tls.msk.ru> <20080129162640.GA16250@rap.rap.dk> <479F5882.8050400@msgid.tls.msk.ru> <20080129180101.GB19527@rap.rap.dk> <47A07D95.2030902@msgid.tls.msk.ru> <47A08E02.3000009@rabbit.us> <20080130152156.GA22131@rap.rap.dk> <47A0993F.8000005@rabbit.us> <47A09BBC.1000800@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47A09BBC.1000800@pobox.com>
Sender: linux-raid-owner@vger.kernel.org
To: Moshe Yudkowsky <moshe@pobox.com>
Cc: Peter Rabbitson <rabbit+list@rabbit.us>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Moshe Yudkowsky wrote:
> My mind boggles. I know how to mount an ISO as a loop device onto the 
> file system, but if you'd be so kind, can you give a super-brief 
> description on how to get a loop device to look like an actual partition 
> that can be made into a RAID array? I can see this software-only 
> solution as being quite interesting for testing in general.
> 

I tried this a while back, IIRC the procedure was:

1) Make some empty files of the required length each.

2) Use losetup to mount each one onto a loop device (loop0-3 say).

3) Use /dev/loop[0-3] as component devices to mdadm as you would use any 
other device or partition. It is not necessary to partition the loop 
devices, use them whole.

HTH

Tim

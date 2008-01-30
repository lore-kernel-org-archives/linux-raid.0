From: Moshe Yudkowsky <moshe@pobox.com>
Subject: Loop devices to RAID? (was Re: In this partition scheme, grub does
 not find md information?)
Date: Wed, 30 Jan 2008 09:46:04 -0600
Message-ID: <47A09BBC.1000800@pobox.com>
References: <479F07E1.7060408@pobox.com> <479F0AAB.3090702@rabbit.us> <479F331F.7080902@msgid.tls.msk.ru> <479F3C74.1050605@rabbit.us> <479F42A5.8040007@msgid.tls.msk.ru> <20080129162640.GA16250@rap.rap.dk> <479F5882.8050400@msgid.tls.msk.ru> <20080129180101.GB19527@rap.rap.dk> <47A07D95.2030902@msgid.tls.msk.ru> <47A08E02.3000009@rabbit.us> <20080130152156.GA22131@rap.rap.dk> <47A0993F.8000005@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47A0993F.8000005@rabbit.us>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Rabbitson <rabbit+list@rabbit.us>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Peter Rabbitson wrote:
> It seems like it. I just created the above raid configuration with 5 
> loop devices. Everything behaved just like Michael described. When the 
> wrong drives disappeared - I started getting IO errors.

My mind boggles. I know how to mount an ISO as a loop device onto the 
file system, but if you'd be so kind, can you give a super-brief 
description on how to get a loop device to look like an actual partition 
that can be made into a RAID array? I can see this software-only 
solution as being quite interesting for testing in general.

-- 
Moshe Yudkowsky * moshe@pobox.com * www.pobox.com/~moshe
  "I'm very well aquainted/with the seven deadly sins/
   I keep a busy schedule/ to try to fit them in."
    			-- Warren Zevon, "Mr. Bad Example"

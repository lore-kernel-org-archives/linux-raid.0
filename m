From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: In this partition scheme, grub does not find md information?
Date: Tue, 29 Jan 2008 19:51:07 +0300
Message-ID: <479F597B.9050105@msgid.tls.msk.ru>
References: <479EAF42.6010604@pobox.com> <18334.46306.611615.493031@notabene.brown> <479F07E1.7060408@pobox.com> <479F0AAB.3090702@rabbit.us> <479F331F.7080902@msgid.tls.msk.ru> <479F3C74.1050605@rabbit.us> <479F42A5.8040007@msgid.tls.msk.ru> <479F4941.1050304@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <479F4941.1050304@rabbit.us>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Rabbitson <rabbit+list@rabbit.us>
Cc: Moshe Yudkowsky <moshe@pobox.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Peter Rabbitson wrote:
[]
> However if you want to be so anal about names and specifications: md
> raid 10 is not a _full_ 1+0 implementation. Consider the textbook
> scenario with 4 drives:
> 
> (A mirroring B) striped with (C mirroring D)
> 
> When only drives A and C are present, md raid 10 with near offset will
> not start, whereas "standard" RAID 1+0 is expected to keep clunking away.

Ugh.  Yes. offset is linux extension.

But md raid 10 with default, n2 (without offset), configuration will behave
exactly like in "classic" docs.

Again.  Linux md raid10 module implements standard raid10 as known in
all widely used docs.  And IN ADDITION, it can do OTHER FORMS, which
differs from "classic" variant.  Pretty like a hardware raid card from
a brand vendor probably implements their own variations of standard
raid levels.

/mjt

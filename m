From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: 3 questions...
Date: Mon, 30 Sep 2002 03:19:08 +0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3D978A6C.1030103@tls.msk.ru>
References: <C65F89D1AC0BB54B865127151A24DA780BAD5C91@nbexchm2.aliant.icn>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Shaw, Marco wrote:
[]
> Remember (with RedHat Advanced Server anyway), you'd have to actually disable autodetection.  I'm still working on how it works because I'm still unclear whether this is a kernel feature, or just a result of init scripts.  An older RedHat reference:
> http://www.redhat.com/support/resources/tips/raid/RAID-4.html

Autodetection works in kernel, before kernel tries to
mount root filesystem.  At this time, kernel looks at
all partitions of type "raid autodetect" to see if this
is a part of an array, and brings up all it can find
(In fact, this seems to be not true sisnce at least on
2.2 here, only root mddev is started while another two
also marked as "autodetect").  The rest is done in
initscripts, after root filesystem gets mounted (kernel
has no clue about initscripts at all).

/mjt


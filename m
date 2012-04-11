From: Joe Lawrence <jdl1291@gmail.com>
Subject: Re: mdadm 3.2.3 and adding metadata 1.0 bitmaps
Date: Wed, 11 Apr 2012 03:05:33 +0000 (UTC)
Message-ID: <loom.20120411T043403-205@post.gmane.org>
References: <loom.20120410T165425-854@post.gmane.org> <20120411085944.0c2e4b5b@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown <neilb <at> suse.de> writes:

> Hi Joe,
>  I haven't had a proper look yet, but does:
> 
>
http://neil.brown.name/git?p=mdadm;a=commitdiff;h=fbdef49811c9e2b54e2064d9af68cfffa77c6e77
> 
>    Bitmap_offset is a signed number
> 
> Make a difference?

Neil, I tried the latest git snapshot of mdadm
(http://neil.brown.name/git?p=mdadm;a=commitdiff;h=508a7f16b242d6c3353e15aab46ac8ca8dc7cd08)
with the same "attempt to access beyond end of device" message.

-- Joe Lawrence
   Stratus Technologies


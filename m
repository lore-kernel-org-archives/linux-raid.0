From: Florent Rougon <florent.rougon@free.fr>
Subject: Re: 3 questions...
Date: 30 Sep 2002 00:23:24 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <87k7l4zb8j.fsf@florent.hn.org>
References: <C65F89D1AC0BB54B865127151A24DA780BAD5C7B@nbexchm2.aliant.icn>
	<3D977753.4010401@tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3D977753.4010401@tls.msk.ru>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

Michael Tokarev <mjt@tls.msk.ru> wrote:

> No.  Raid code will happily use any partition type you'll specify.
> Partition type "fd" stands for "raid AUTODETECT" - that is, at

[...]

> root filesystem.  But instead of guessing, it is better IMHO to
> just tell kernel which devices to use for your root filesystem
> (if your root is on raid device), by using something like
>   append="md=2,/dev/hda1,/dev/hdb1"

I have some partitions with the fd type in raid arrays but would like to
switch to the manual method you just described. These partitions hold
data I care about. Is it safe to change the partition type:
   - while the array is not active?
   - while the array is active?

Thanks.

-- 
Florent

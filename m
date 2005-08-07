From: David Greaves <david@dgreaves.com>
Subject: Re: RAID5 question.
Date: Sun, 07 Aug 2005 12:40:47 +0100
Message-ID: <42F5F33F.8020905@dgreaves.com>
References: <17137.43778.476908.961140@cse.unsw.edu.au>	<01f001c598fd$c59a51a0$0400a8c0@LocalHost> <17138.32835.190046.8088@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17138.32835.190046.8088@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: djani22@dynamicweb.hu, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:

>Technically: no.
>raid5 itself doesn't do readahead.
>  
>
Could you clarify this line please:

>The filesystem or VM layer does read-ahead.
>  
>
 suggests that either: performance should only be affected by the
readahead setting of the block layer immediately below the filesystem
or: lvm and md use the VM layer to access the lower block levels and so
performance is affected by readahead settings for all involved
layers/devices.
I strongly suspect the latter as I run xfs over lvm over md over sata
and I found (I posted the test script aeons ago) that varying the
readhead on different layers affects performance. The best performance
(for my usage) was obtained by setting readahead to zero on all layers
except the topmost (lvm for me).

Comments?

David


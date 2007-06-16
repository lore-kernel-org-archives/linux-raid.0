From: Luca Berra <bluca@comedia.it>
Subject: Re: SLES 9 SP3 and mdadm 2.6.1 (via rpm)
Date: Sat, 16 Jun 2007 18:44:46 +0200
Message-ID: <20070616164446.GE2224@percy.comedia.it>
References: <20070612072408.19140@gmx.net> <18030.19615.898281.457910@notabene.brown> <20070613114553.235550@gmx.net> <Pine.LNX.4.64.0706130749390.31068@p34.internal.lan> <20070614075336.GB7134@percy.comedia.it> <Pine.LNX.4.64.0706140421550.25392@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706140421550.25392@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Jun 14, 2007 at 04:22:03AM -0400, Justin Piszcz wrote:
>
>
>On Thu, 14 Jun 2007, Luca Berra wrote:
>
>>On Wed, Jun 13, 2007 at 07:50:06AM -0400, Justin Piszcz wrote:
>>>You don't even need that, just do this:
>>>
>>>1. echo 'DEVICE /dev/hd*[0-9] /dev/sd*[0-9]' > mdadm.conf
>>do _NOT_ do the above, _never_.
>>recent mdadm do not need the "DEVICE" line
>>for older one use "DEVICE partitions".
>>
>
>Why never do that? It has always worked for me.
>
the keyword here is "for me"
but /dev/hd*[0-9] /dev/sd*[0-9] does not mean "all disks" for everybody.

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \

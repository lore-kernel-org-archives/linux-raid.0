From: Luca Berra <bluca@comedia.it>
Subject: Re: SLES 9 SP3 and mdadm 2.6.1 (via rpm)
Date: Thu, 14 Jun 2007 09:53:36 +0200
Message-ID: <20070614075336.GB7134@percy.comedia.it>
References: <20070612072408.19140@gmx.net> <18030.19615.898281.457910@notabene.brown> <20070613114553.235550@gmx.net> <Pine.LNX.4.64.0706130749390.31068@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706130749390.31068@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jun 13, 2007 at 07:50:06AM -0400, Justin Piszcz wrote:
>You don't even need that, just do this:
>
>1. echo 'DEVICE /dev/hd*[0-9] /dev/sd*[0-9]' > mdadm.conf
do _NOT_ do the above, _never_.
recent mdadm do not need the "DEVICE" line
for older one use "DEVICE partitions".

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \

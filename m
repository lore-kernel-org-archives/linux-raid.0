From: Luca Berra <bluca@comedia.it>
Subject: Re: s2disk and raid
Date: Fri, 6 Apr 2007 11:08:35 +0200
Message-ID: <20070406090834.GA31189@percy.comedia.it>
References: <20070403175521.70e6c876@commensaal.drs.p> <17939.13752.164747.486393@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <17939.13752.164747.486393@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Apr 04, 2007 at 03:20:56PM +1000, Neil Brown wrote:
>The trick is to use the 'start_ro' module parameter.
>  echo 1 > /sys/module/md_mod/parameters/start_ro
>
>Then md will start arrays assuming read-only.  No resync will be
>started, no superblock will be written.  They stay this way until the
>first write at which point they become normal read-write and any
>required resync starts.
>
uh, i tought a read-only array was supposed to remain read-only, and
that write attempts would fail.
My bad for not testing my assumptions.

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \

From: Jani Averbach <jaa@cc.jyu.fi>
Subject: Re: BUG: 2.5.41 left raid array to unclean mode (Kernel bug at
 raid1.c:667)
Date: Tue, 8 Oct 2002 18:09:25 +0300 (EEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.GSO.4.33.0210081807180.20489-100000@tukki.cc.jyu.fi>
References: <15778.27247.271665.487076@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <15778.27247.271665.487076@notabene.cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: mingo@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 8 Oct 2002, Neil Brown wrote:

> Just remove the first instance of:
>
>   return NOTIFY_DONE;
>
> from drivers/md/md.c
>

Done that, and so far it seems to work ok.

Thanks,

Jani

--
Jani Averbach


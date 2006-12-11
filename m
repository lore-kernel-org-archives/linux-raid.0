From: Jiri Kosina <jikos@jikos.cz>
Subject: Re: oops on 2.6.19-rc6-mm2: deref of 0x28 at permission+0x7
Date: Mon, 11 Dec 2006 10:35:51 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0612111034480.1665@twin.jikos.cz>
References: <457A0F4C.9060601@gmail.com> <Pine.LNX.4.64.0612102027350.1665@twin.jikos.cz>
 <17788.48732.53210.631230@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17788.48732.53210.631230@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Jiri Slaby <jirislaby@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>, mingo@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 11 Dec 2006, Neil Brown wrote:

> > this nash thing is exactly the command which triggers a bit different 
> > oops in my case. On my side, the oops is fully reproducible. If you 
> > manage to make your case also reproducible, could you please try to 
> > revert md-change-lifetime-rules-for-md-devices.patch? This made the 
> > oops vanish in my case. I think Neil is working on it.
> Trying to work on it - not making a lot of progress.  I find it hard to 
> see how anything in md can cause the inode for a block-device file to 
> disappear... It is a bit of a long-shot, but this patch might change 
> things.  It changes the order in which things are de-allocated. Jiri and 
> Jiri: would either of both of you see if you can reproduce the bug with 
> this patch on 2.6.19-rc6-mm2 ???

Hi Neil,

sorry to say that, but it's still there after applying your patch.

-- 
Jiri Kosina

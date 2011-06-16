From: NeilBrown <neilb@suse.de>
Subject: Re: md 3.2.1 and xfs kernel panic on Linux 2.6.38
Date: Thu, 16 Jun 2011 12:26:52 +1000
Message-ID: <20110616122652.428ac545@notabene.brown>
References: <BANLkTimCyX=fBuXfuYx30X7M-ninCULq4Q@mail.gmail.com>
	<20110616115531.298328f2@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110616115531.298328f2@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: "fibreraid@gmail.com" <fibreraid@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, linux-xfs@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 16 Jun 2011 11:55:31 +1000 NeilBrown <neilb@suse.de> wrote:


> Hmmm... maybe we are missing the wakeup call.  I can find where we wake-up
> anyone waiting for an overlapping read request to complete, but I cannot find
> where we wake-up someone waiting for when an overlapping write request
> completes.  That should probably go in handle_stripe_clean_event.

On second thoughts, I can find where it is handled correctly for an
overlapping write request.

So I'm not stumped again.

I tried looking at a disassembly listing of make_request to confirm which
'schedule' call it was, but when I disassemble make_request it is about 1700
bytes long where as you trace show:

    make_request+0x138/0x3d0 

That it is 0x3d0 long, or about 900 bytes.  That is odd.

Can you get a disassembly to show me?
e.g.
   gdb raid456.ko
   disassemble make_request

Thanks,
NeilBrown


> 
> Do you have the system still hanging in this state?  If not, can you get it
> back into this state easily?
> If so, you can force a wakeup with the magic incantation:
> 
>  cat /sys/block/mdXX/md/suspend_lo > /sys/block/mdXX/md/suspend_lo
> 
> (with 'XX' suitably substituted).
> 
> If that makes a difference, then I know I am on the right track
> 
> Thanks,
> NeilBrown
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


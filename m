From: Neil Brown <neilb@suse.de>
Subject: Re: Deadlock in md barrier code? / RAID1 / LVM CoW snapshot + ext3
 / Debian 5.0 - lenny 2.6.26 kernel
Date: Tue, 19 Oct 2010 17:16:50 +1100
Message-ID: <20101019171650.20c83e7e@notabene>
References: <4C938103.1010304@seoss.co.uk>
	<20100918085925.5fee83ee@notabene>
	<4C97BD21.1040405@seoss.co.uk>
	<4C991D61.1040400@seoss.co.uk>
	<20100922083039.283ccdfd@notabene>
	<4CBC9774.6020500@seoss.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4CBC9774.6020500@seoss.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Tim Small <tim@seoss.co.uk>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, 18 Oct 2010 19:52:36 +0100
Tim Small <tim@seoss.co.uk> wrote:

> Neil Brown wrote:
> > Maybe if you can get me a full sysrq-T list that might help.
> >    
> 
> At last, yes, courtesy of Ben Hutchings...
> 
> http://buttersideup.com/files/md-raid1-lockup-lvm-snapshot/deadlock-openvz-2.6.26-Debian5.txt

Thanks!

> 
> ... any use?

Only in as much as that it excludes some possible avenues of investigation,
which has some value.

But I'm out of ideas.  I cannot think of anything that could keep
->nr_pending or ->barrier elevated such that raise_barrier would
block for a long time.

Maybe you could try adding printks to print
  conf->{barrier,nr_pending,nr_waiting,nr_queued}
just before and after the second wait_event_lock_irq in raise_barrier().

That might help...

NeilBrown




> 
> Cheers,
> 
> Tim.
> 


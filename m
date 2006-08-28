From: Neil Brown <neilb@suse.de>
Subject: Re: raid5 write performance
Date: Mon, 28 Aug 2006 14:32:55 +1000
Message-ID: <17650.29175.778076.964022@cse.unsw.edu.au>
References: <5d96567b0607020702p25d66490i79445bac606e5210@mail.gmail.com>
	<17576.18978.563672.656847@cse.unsw.edu.au>
	<5d96567b0608130619w60d8d883q4ffbfefcf650ee82@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Raz Ben-Jehuda(caro) on Sunday August 13
Sender: linux-raid-owner@vger.kernel.org
To: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sunday August 13, raziebe@gmail.com wrote:
> well ... me again
> 
> Following your advice....
> 
> I added a deadline for every WRITE stripe head when it is created.
> in raid5_activate_delayed i checked if deadline is expired and if not i am
> setting the sh to prereadactive mode as .
> 
> This small fix ( and in few other places in the code) reduced the
> amount of reads
> to zero with dd but with no improvement to throghput. But with random access to
> the raid  ( buffers are aligned by the stripe width and with the size
> of stripe width )
> there is an improvement of at least 20 % .
> 
> Problem is that a user must know what he is doing else there would be
> a reduction
> in performance if deadline line it too long (say 100 ms).

So if I understand you correctly, you are delaying write requests to
partial stripes slightly (your 'deadline') and this is sometimes
giving you a 20% improvement ?

I'm not surprised that you could get some improvement.  20% is quite
surprising.  It would be worth following through with this to make
that improvement generally available.

As you say, picking a time in milliseconds is very error prone.  We
really need to come up with something more natural.
I had hopped that the 'unplug' infrastructure would provide the right
thing, but apparently not.  Maybe unplug is just being called too
often.

I'll see if I can duplicate this myself and find out what is really
going on.

Thanks for the report.

NeilBrown

From: NeilBrown <neilb@suse.com>
Subject: Re: raid1_end_read_request does not retry failed READ from a
 recovering drive
Date: Fri, 31 Jul 2015 10:12:26 +1000
Message-ID: <20150731101226.46a52236@noble>
References: <CAGRgLy6B0ZWtr1xv7_-qAzww+UNcfausrxRnMzDBP3n5348e7A@mail.gmail.com>
	<20140908171702.5b2853fc@notabene.brown>
	<CAGRgLy54ByqUG8bTyPr_rDrNMbyFYRU+rx4LEWVqMHOw2=k=Dg@mail.gmail.com>
	<20140918110523.3ee5c064@notabene.brown>
	<CAGRgLy7+bN8ztaaN+oh6uATE7=Z=8LnU=R0m2CnVff4ZqgJFKg@mail.gmail.com>
	<20140922101704.53be2056@notabene.brown>
	<CAGRgLy5DsbiPsjJ2ZK_aOZ_UOqxa-zwbdDREv7hdpt7vLXCwOw@mail.gmail.com>
	<20150724092404.66dc284d@noble>
	<CAGRgLy7qkyQquRDGCShjJsuREQXNN+WaNGaq5wK2psMLQ6BGtw@mail.gmail.com>
	<20150727115653.530daba6@noble>
	<CAGRgLy5rE6Yuhcw2jA+4ymv5U489vX_NvSpNAuy0OPbcKnatFA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy5rE6Yuhcw2jA+4ymv5U489vX_NvSpNAuy0OPbcKnatFA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, 27 Jul 2015 10:07:37 +0200 Alexander Lyakas
<alex.bolshoy@gmail.com> wrote:

> Hi Neil,
> Thanks for the comments. Hopefully now we have the complete fix.
> I am posting what we have applied on top of 3.8.13 (now we are moving
> to 3.18.19, which already has part of the fix, so I will need to apply
> a delta, until both your latest patches reach Mr. Stable). Locking the
> spinlock in "error" function is not there (but I will apply it to
> 3.18.19).
> 
> Below patch is a bit ugly:
> - CONFIG_MD_ZADARA is a define that we add, so that every engineer can
> clearly distinguish our changes vs the original code. I know it's
> ugly.
> - zklog is a macro that eventually ends up in printk. This is only to
> have a bit more prints, and is not functionally needed. zklog also
> prints current->pid, function name etc, to have more context.
> 
> Hopefully, gmail will not make the patch even uglier.
> 
> Thanks for your help!
> Alex.
> 

Thanks for that Alex - I think we are one the same page now :-)
Thanks,
NeilBrown


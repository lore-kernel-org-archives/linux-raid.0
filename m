From: Neil Brown <neilb@suse.de>
Subject: Re: Using LVM for RAID 1+0
Date: Thu, 20 Apr 2006 10:15:13 +1000
Message-ID: <17478.53905.609802.307968@cse.unsw.edu.au>
References: <6d5bedd80604181720s4a481844s22e107089c790e80@mail.gmail.com>
	<17477.35448.136382.373967@cse.unsw.edu.au>
	<6d5bedd80604181919o350b715dm1d715d0be01f3c6@mail.gmail.com>
	<17477.42182.423594.547630@cse.unsw.edu.au>
	<6d5bedd80604191340j1bb09f03t4ef1fc765064bf11@mail.gmail.com>
	<17478.46491.638230.95056@cse.unsw.edu.au>
	<6d5bedd80604191702k5e998e83gfd8f74ae168c1cf7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Ewan Grantham on Wednesday April 19
Sender: linux-raid-owner@vger.kernel.org
To: Ewan Grantham <ewan.grantham@gmail.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wednesday April 19, ewan.grantham@gmail.com wrote:
> On 4/19/06, Neil Brown <neilb@suse.de> wrote:
> > You haven't been following the list have you ..... ;-)
> >
> > mdadm-2.4.1 plus linux-2.6.17 (or any -rc) can grow a raid5.
> > Just add a spare drive and
> >    mdadm --grow /dev/mdX --raid-disks=N+1
> 
> Actually I had, but I thought I understood this was extremely
> experimental. Does this mean it's considered accepted/acceptable? In
> which case, the fact that I'm using a 2.6.15 kernel and mdadm 1.12.0
> (June 2005) (is that version number possibly right?) suggest I need to
> do a little tool updating so I can try this out. I presume that I can
> upgrade mdadm and then do the grow - or do I need to upgrade and
> rebuild the array with the upgraded tool before I can use the grow
> option? How much risk do I have of data loss doing this?

I think it has transitioned from "Extremely experimental" to
"Experimental". 

If should be safe, and if anything does go wrong, I'm sure I can pick
up the pieces for you.

But yes, you'll need a tool upgrade.
1.12.0 was the last of the '1' series.
2.4.1 is the latest and is required for raid5 resize.
Also, you will need 2.6.17-rc1 or later. And you'll need to select
CONFIG_EXPERIMENTAL and the config option to enable raid5 reshaping.

You don't need to "upgrade" the array at all, or rebuild it or
anything.

Risk of data loss is very low.  I believe the code is correct and
reliable, but until a wide variety of people test it and report
success, it is hard to be certain.  And as I said, if you do have
problem (other than multiple drive failures), I'll do my best to
stitch things back together for you.

NeilBrown

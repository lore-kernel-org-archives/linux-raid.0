From: Miquel van Smoorenburg <miquels@cistron.nl>
Subject: Booting from partitioned raid,  do_mounts_md.c patch (was: Re: Partitioned raid and major number)
Date: Tue, 9 Mar 2004 17:46:23 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040309164623.GO3084@traveler.cistron.net>
References: <20040225145624.GA1513@cistron.nl> <16445.12026.812778.621025@notabene.cse.unsw.edu.au> <20040226215144.GC11831@drinkel.cistron.nl> <16446.36226.591283.495194@notabene.cse.unsw.edu.au> <16446.39583.968782.41221@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <16446.39583.968782.41221@notabene.cse.unsw.edu.au> (from neilb@cse.unsw.edu.au on Fri, Feb 27, 2004 at 02:17:19 +0100)
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: Miquel van Smoorenburg <miquels@cistron.nl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2004.02.27 02:17, Neil Brown wrote:
> On Friday February 27, neilb@cse.unsw.edu.au wrote:
> > 
> > Right.  I missed a bit in the patch.
> > (I assume you are still wanting to boot off /dev/sda until you copy
> > the data into /dev/md/d0p* - then you will use root=/dev/md_d0p1)
> 
> Sorry, that patch was wrong.
> This one, ontop of the original patch, works for me (I finally got
> around to testing it).
> 
> 
>  ----------- Diffstat output ------------
>  ./drivers/md/md.c     |    2 +-
>  ./init/do_mounts_md.c |    9 ++++++++-
>  2 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff ./drivers/md/md.c~current~ ./drivers/md/md.c
> diff ./init/do_mounts_md.c~current~ ./init/do_mounts_md.c

I've tested this a lot as well, and it works fine. On my supermicro 1U test
machine I can now pull out one of the two disks, and the machine still boots.
I can even take out disk2, insert disk1 in the slot for disk2 and it
still boots. Which is pretty cool ;)

I didn't see this in -rc2-mm1 yet - is this going to be submitted to -mm soon ?

Mike.

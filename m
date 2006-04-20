From: "Ewan Grantham" <ewan.grantham@gmail.com>
Subject: Re: Using LVM for RAID 1+0
Date: Wed, 19 Apr 2006 19:02:50 -0500
Message-ID: <6d5bedd80604191702k5e998e83gfd8f74ae168c1cf7@mail.gmail.com>
References: <6d5bedd80604181720s4a481844s22e107089c790e80@mail.gmail.com>
	 <17477.35448.136382.373967@cse.unsw.edu.au>
	 <6d5bedd80604181919o350b715dm1d715d0be01f3c6@mail.gmail.com>
	 <17477.42182.423594.547630@cse.unsw.edu.au>
	 <6d5bedd80604191340j1bb09f03t4ef1fc765064bf11@mail.gmail.com>
	 <17478.46491.638230.95056@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17478.46491.638230.95056@cse.unsw.edu.au>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 4/19/06, Neil Brown <neilb@suse.de> wrote:
> You haven't been following the list have you ..... ;-)
>
> mdadm-2.4.1 plus linux-2.6.17 (or any -rc) can grow a raid5.
> Just add a spare drive and
>    mdadm --grow /dev/mdX --raid-disks=N+1

Actually I had, but I thought I understood this was extremely
experimental. Does this mean it's considered accepted/acceptable? In
which case, the fact that I'm using a 2.6.15 kernel and mdadm 1.12.0
(June 2005) (is that version number possibly right?) suggest I need to
do a little tool updating so I can try this out. I presume that I can
upgrade mdadm and then do the grow - or do I need to upgrade and
rebuild the array with the upgraded tool before I can use the grow
option? How much risk do I have of data loss doing this?

Thanks,
Ewan

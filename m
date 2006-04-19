From: Neil Brown <neilb@suse.de>
Subject: Re: Using LVM for RAID 1+0
Date: Thu, 20 Apr 2006 08:11:39 +1000
Message-ID: <17478.46491.638230.95056@cse.unsw.edu.au>
References: <6d5bedd80604181720s4a481844s22e107089c790e80@mail.gmail.com>
	<17477.35448.136382.373967@cse.unsw.edu.au>
	<6d5bedd80604181919o350b715dm1d715d0be01f3c6@mail.gmail.com>
	<17477.42182.423594.547630@cse.unsw.edu.au>
	<6d5bedd80604191340j1bb09f03t4ef1fc765064bf11@mail.gmail.com>
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
> On 4/18/06, Neil Brown <neilb@suse.de> wrote:
> > No, you cannot grow an md/raid0 array.  If you need growth, then you
> > would need to consider LVM at this stage, though md/linear will
> > probably be able to grow soon.
> 
> Any chance RAID-5 will be able to grow at some point also?

You haven't been following the list have you ..... ;-)

mdadm-2.4.1 plus linux-2.6.17 (or any -rc) can grow a raid5.
Just add a spare drive and
   mdadm --grow /dev/mdX --raid-disks=N+1

NeilBrown

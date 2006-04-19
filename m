From: "Ewan Grantham" <ewan.grantham@gmail.com>
Subject: Re: Using LVM for RAID 1+0
Date: Wed, 19 Apr 2006 15:40:14 -0500
Message-ID: <6d5bedd80604191340j1bb09f03t4ef1fc765064bf11@mail.gmail.com>
References: <6d5bedd80604181720s4a481844s22e107089c790e80@mail.gmail.com>
	 <17477.35448.136382.373967@cse.unsw.edu.au>
	 <6d5bedd80604181919o350b715dm1d715d0be01f3c6@mail.gmail.com>
	 <17477.42182.423594.547630@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17477.42182.423594.547630@cse.unsw.edu.au>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 4/18/06, Neil Brown <neilb@suse.de> wrote:
> No, you cannot grow an md/raid0 array.  If you need growth, then you
> would need to consider LVM at this stage, though md/linear will
> probably be able to grow soon.

Any chance RAID-5 will be able to grow at some point also?

> I've always felt that raid over USB was a "courageous" design.  USB
> has such a "temporary" feel to it.  However, if it work for you,
> great.

Well, after playing with LVM for a while, I realized that there were a
few limitations I hadn't counted on... :-)

Since everything seemed to be working ok with the switch of cables and
ports, I decided to take the plunge, and am now (knocking on a large
virtual pile of wood) almost 60% through a build of the RAID-5 array
using the same drives I was having issues with earlier. Given that I
had the setup running for several months before Windows decided to get
"funny" with my embedded Linux solution, I have hope that this will
run for a good while. Of course that means my other pair of drives
will now have to be a seperate volume, but that should give me a good
setup for some of my more essential files (photos and home movies).

USB at least has the advantage over 1394 external drives of not
tending to decide to change dev names at each reboot. When I had a
firewire array I was always afraid to do a shutdown not knowing what
would happen when it came back up.

I agree that getting a large box with enough bays to put the disks
internal would probably be preferable - but if I had any extra money
at this point I'd be more likely to get a good UPS to replace my
current power strip with surge protector.

Thanks again for the help and advice,
Ewan

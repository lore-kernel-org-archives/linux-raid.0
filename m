From: Martin Cracauer <cracauer@cons.org>
Subject: Re: Superblock V 1.2
Date: Tue, 9 Nov 2010 11:35:13 -0500
Message-ID: <20101109163512.GA15649@cons.org>
References: <20101107191507.GA31052@cons.org> <E9.7C.19545.72417DC4@cdptpa-omtalb.mail.rr.com> <20101107210852.GA77472@cons.org> <4CD71C77.4030400@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4CD71C77.4030400@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: Martin Cracauer <cracauer@cons.org>, Leslie Rhorer <lrhorer@satx.rr.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

John Robinson wrote on Sun, Nov 07, 2010 at 09:39:03PM +0000: 
> On 07/11/2010 21:08, Martin Cracauer wrote:
> >Thanks, Leslie,
> >
> >Leslie Rhorer wrote on Sun, Nov 07, 2010 at 03:03:39PM -0600:
> >>
> >>>Can I read that array if I ever connect the machine to an older
> >>>kernel/mdadm?
> >>
> >>	That depends on just how old.  The new superblocks have been
> >>supported for quite some time.  Worst case you will need to upgrade the 
> >>old
> >>kernel to a newer one.
> >
> >Is mdadm actually involved? If I have a new enough kernel but an old
> >mdadm, will the kernel code alone be enough to start the array?
> >
> >I guess it should since it can start the arrays at boot time with no
> >mdadm involved.
> 
> That's the other difference between 0.90 and 1.x metadata. In-kernel 
> auto-assembly is only available for 0.90, and Neil Brown has made it 
> clear that there will never be in-kernel auto-assembly for 1.x, and 
> explained at length why. You need mdadm to start 1.x arrays, in your 
> initrd if your root filesystem is on such an array. All modern distros 
> create suitable initrds automatically. We are moving towards having 
> array assembly handled by udev invoking mdadm as devices are discovered.

That's good it know.  I still think that udev is a plot to destroy
Linux as we know it so I guess I'm gonna recreate this particular
 array :-)

What do you do if you plug in a couple harddrives that have arrays on
them that you do not want assembled? Right now you just set them to a
partition type other than autodetect and you are good.

What do you do when udev maintainers in distributions screw up and
replace good udev entires with bad ones? That happened to me
repeatedly and is the major reason for the attitude above.

Martin
-- 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Martin Cracauer <cracauer@cons.org>   http://www.cons.org/cracauer/

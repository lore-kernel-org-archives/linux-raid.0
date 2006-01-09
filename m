From: Sebastian Kuzminsky <seb@highlab.com>
Subject: Re: more info on the hang with 2.6.15-rc5
Date: Sun, 08 Jan 2006 19:33:46 -0700
Message-ID: <E1Evmqw-0001pO-Ng@highlab.com>
References: <E1EpIfb-0001e2-GR@highlab.com> <43C1580B.9020609@tmr.com>
Reply-To: LVM general discussion and development <linux-lvm@redhat.com>
Return-path: <linux-lvm-bounces@redhat.com>
In-reply-to: <43C1580B.9020609@tmr.com> 
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/linux-lvm>,
	<mailto:linux-lvm-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/linux-lvm>
List-Post: <mailto:linux-lvm@redhat.com>
List-Help: <mailto:linux-lvm-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/linux-lvm>,
	<mailto:linux-lvm-request@redhat.com?subject=subscribe>
Sender: linux-lvm-bounces@redhat.com
Errors-To: linux-lvm-bounces@redhat.com
To: linux-raid@vger.kernel.org, linux-lvm@redhat.com
List-Id: linux-raid.ids

Bill Davidsen <davidsen@tmr.com> wrote:
> Sebastian Kuzminsky wrote:
> 
> >Now it works, but I dont trust it one bit.
> >
> >I had been seeing almost immediate, perfectly repeatable hard lockups
> >in 2.6.15-rc5 and 2.6.15-rc5-mm3, when using sata_mv, RAID, and LVM
> >together.  Nothing in the syslog or on the console, and the system is
> >totally unresponsive to the keyboard & network.
> >
> >My hardware setup is: four Seagate Barracuda 500 GB disks, on a Marvell
> >MV88SX6081 8-port SATA-II PCI-X controller, on a PCI-X bus (64/66).
> >
> >The disks work great when accessed directly.  They work great when used
> >as four PVs for LVM, and when assembled into a 4-disk RAID-6.
> >
> >But when I make a RAID-6 array out of them, and use the array as a PV,
> >the system would hang completely, within seconds.  (This is with LVM
> >2.02.01, libdevicemapper 1.02.02, and dm-driver 4.5.0.)
> >
> >I turned on all the debugging options in the kernel config hoping to get
> >some insight, but this "debug" kernel doesnt crash.  It's running fine,
> >and I'm pounding on it.  A timing problem in the interaction between
> >LVM and RAID?  Some kind of wierd heisenbug....
> >
> >
> >I'd be happy to do any debugging tests people suggest.
> >
> >
> >  
> >
> I've been waiting for more info on this, did it get fixed? 2.6.15?

Still broken in 2.6.15.  With all the debugging options OFF in the config,
the system stayed up < 24 hours under load, then a hard lockup like
before: nothing on the console, magic sysrq doesnt work, no caps-lock,
no ping.  Note that this is different from before: it actually ran a
little bit before locking up, rather than locking up within seconds like
it did with 2.6.15-rc5.

With all the debugging options ON, it's stayed up for 3+ days now (and
still running) with no problems.


Any suggestions for how to debug this are welcome!  ;-)


-- 
Sebastian Kuzminsky

_______________________________________________
linux-lvm mailing list
linux-lvm@redhat.com
https://www.redhat.com/mailman/listinfo/linux-lvm
read the LVM HOW-TO at http://tldp.org/HOWTO/LVM-HOWTO/

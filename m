From: Alberto Alonso <alberto@ggsys.net>
Subject: Re: Implementing low level timeouts within MD
Date: Sun, 28 Oct 2007 01:27:02 -0500
Message-ID: <1193552822.6541.8.camel@w100>
References: <1193418753.4771.17.camel@w100>
	 <1193425254.10336.290.camel@firewall.xsintricity.com>
	 <1193521561.7690.14.camel@w100>
	 <1193529329.10336.366.camel@firewall.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1193529329.10336.366.camel@firewall.xsintricity.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 2007-10-27 at 19:55 -0400, Doug Ledford wrote:
> On Sat, 2007-10-27 at 16:46 -0500, Alberto Alonso wrote:
> > Regardless of the fact that it is not MD's fault, it does make
> > software raid an invalid choice when combined with those drivers. A
> > single disk failure within a RAID5 array bringing a file server down
> > is not a valid option under most situations.
> 
> Without knowing the exact controller you have and driver you use, I
> certainly can't tell the situation.  However, I will note that there are
> times when no matter how well the driver is written, the wrong type of
> drive failure *will* take down the entire machine.  For example, on an
> SPI SCSI bus, a single drive failure that involves a blown terminator
> will cause the electrical signaling on the bus to go dead no matter what
> the driver does to try and work around it.

Sorry I thought I copied the list with the info that I sent to Richard.
Here is the main hardware combinations.

--- Excerpt Start ----
Certainly. The times when I had good results (ie. failed drives
with properly degraded arrays have been with old PATA based IDE 
controllers built in the motherboard and the Highpoint PATA
cards). The failures (ie. single disk failure bringing the whole
server down) have been with the following:

* External disks on USB enclosures, both RAID1 and RAID5 (two different
  systems) Don't know the actual controller for these. I assume it is
  related to usb-storage, but can probably research the actual chipset,
  if it is needed.

* Internal serverworks PATA controller on a netengine server. The
  server if off waiting to get picked up, so I can't get the important
  details.

* Supermicro MB with ICH5/ICH5R controller and 2 RAID5 arrays of 3 
  disks each. (only one drive on one array went bad)

* VIA VT6420 built into the MB with RAID1 across 2 SATA drives.

* And the most complex is this week's server with 4 PCI/PCI-X cards.
  But the one that hanged the server was a 4 disk RAID5 array on a
  RocketRAID1540 card.

--- Excerpt End ----

> 
> > I wasn't even asking as to whether or not it should, I was asking if
> > it could.
> 
> It could, but without careful control of timeouts for differing types of
> devices, you could end up making the software raid less reliable instead
> of more reliable overall.

Even if the default timeout was really long (ie. 1 minute) and then
configurable on a per device (or class) via /proc it would really help.

> Generally speaking, most modern drivers will work well.  It's easier to
> maintain a list of known bad drivers than known good drivers.

That's what has been so frustrating. The old PATA IDE hardware always
worked and the new stuff is what has crashed.

> Be careful which hardware raid you choose, as in the past several brands
> have been known to have the exact same problem you are having with
> software raid, so you may not end up buying yourself anything.  (I'm not
> naming names because it's been long enough since I paid attention to
> hardware raid driver issues that the issues I knew of could have been
> solved by now and I don't want to improperly accuse a currently well
> working driver of being broken)

I have settled for 3ware. All my tests showed that it performed quite
well and kicked drives out when needed. Of course, I haven't had a
bad drive on a 3ware production server yet, so.... I may end up
pulling the little bit of hair I have left.

I am now rushing the RocketRAID 2220 into production without testing
due to it being the only thing I could get my hands on. I'll report
any experiences as they happen.

Thanks for all the info,

Alberto



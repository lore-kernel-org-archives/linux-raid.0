From: dean gaudet <dean-list-linux-raid@arctic.org>
Subject: Re: recovery of hosed raid5 array
Date: Mon, 13 Oct 2003 10:00:47 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0310130954280.7866@twinlark.arctic.org>
References: <slrnbog9og.t0c.lunz@orr.homenet> <no.Yo.24973.N.nN.0310111457280@business.com>
 <slrnboirt8.me8.lunz@orr.homenet> <Pine.LNX.4.58.0310121034090.7866@twinlark.arctic.org>
 <Pine.LNX.4.58.0310131544260.2746@oracle.urc.bl.ac.yu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.58.0310131544260.2746@oracle.urc.bl.ac.yu>
To: Dragan Simic <dsimic@urc.bl.ac.yu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 13 Oct 2003, Dragan Simic wrote:

> On Sun, 12 Oct 2003, dean gaudet wrote:
>
> > querying SMART shouldn't cause this to happen -- but i've seen it occur
> > with a promise controller and maxtor disks.  i used to query the SMART
> > data once a night just to have a log.  then i switched it to once every 5
> > minutes so i could graph the drive temperature... and when i went to once
> > every 5 minutes the system became unstable.  the kernel would randomly
> > lose the ability to talk to a disk.  the problem would go away after a
> > reboot.  i assume it was some sort of race condition.
>
> Just a small drop-in: I have a Promise FastTrak133 with two Maxtor HDDs
> attached to it, and running smartmontools every 5 minutes, didn't notice
> any troubles or signs of instability.

yeah i've had a hard time reproducing it outside of the production system
i had the troubles on.  that system was exceptionally busy though.  it was
also SMP.  i had both ultra100tx2 and ultra133tx2 in that box at the time.
(the problem could also have been the maxtor firmware -- they were older
80GB 7200rpm disks.)

-dean

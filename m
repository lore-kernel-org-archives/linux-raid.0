From: Chris Osicki <osk@admin.swisscom-mobile.ch>
Subject: Re: RAID5 troubles
Date: Mon, 12 Jun 2006 12:25:23 +0200
Message-ID: <20060612122523.0f4aa2c6@mwdsp001>
References: <200606102028.k5AKSD86022209@mrz.swissptt.ch>
	<62b0912f0606110842v1fbf117ag8eb57758af06977e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <62b0912f0606110842v1fbf117ag8eb57758af06977e@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 11 Jun 2006 17:42:43 +0200
"Molle Bestefich" <molle.bestefich@gmail.com> wrote:

> Chris wrote:
> > Kernel: 2.6.16.16
> > mdadm: v1.12.0
> 
> > The RAID5 array is still a problem, dmesg says:
> 
> > md: running: <sdc2><sdb2><sda2>
> > raid5: device sdb2 operational as raid disk 0
> > raid5: device sda2 operational as raid disk 1
> > raid5: cannot start dirty degraded array for md1
> 
> Odd.  Perhaps a bug.
> Not sure it will help, but try upgrading mdadm to latest stable (v2.5 or so).
> 
> > raid5: failed to run raid set md1
> > md: pers->run() failed ...
> > md: do_md_run() returned -5
> 
> Rather unhelpful to not print an error message.
> Unfortunately, I've no clue what -5 means, or where one may look up
> do_md_run() errors.
> 

Hi

Sorry for the noise I made. --force was the right way to go which I was too afraid of.
I put lots of work into the data I wanted protect with this newly created array, so
I wanted to ask before I damage it.
So, this did it:

mdadm /dev/md1 --assemble --force /dev/sda2 /dev/sdb2
mdadm /dev/md1 --add /dev/sdc2


Thanks for your help.

Regards,
Chris

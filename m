From: Neil Brown <neilb@suse.de>
Subject: Re: md device on Redhat Linux 3
Date: Wed, 31 Jan 2007 11:52:17 +1100
Message-ID: <17855.59457.265701.451229@notabene.brown>
References: <207069.41342.qm@web30301.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from David Shine on Tuesday January 30
Sender: linux-raid-owner@vger.kernel.org
To: David Shine <davidshine@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday January 30, davidshine@yahoo.com wrote:
> Hi there,
> 
> I am currenlty building a site ysing the following
> 
> 2 * IBM DS4300 (SANS)
> 2 * IBM X346 (intel systems)
> 2 * HBA on each node
> 
> I am using the md device driver to tie the two SANS together and use them in a mirrored environement. So the layout is 3 file systems sitting under and LVM volume group siting under a mirrored SAN (/dev/sdb, /dev/sdc) on 2 g.b. fibre using md driver.
> 
> The problem when we write to one of the SANS when he mirror is
> broken and then take this offline and ring the other SAN online and
> switch on the RAID array and  varyon the volume group and  finally
> mount the file system and then dismount the file system,swithc of
> both the volume group and the RAID array and thn reboot the server
> it finds the most recently updated disk to be the one written to not
> the one last mounted. 

It's not really clear to me what you are trying to do here.... maybe
if you explain your motivations and expectations.

> 
> How does this work? Where is the date and time stamp written. I
> thought it would be at the point of doing a aidstart and the supper
> block would be updated, can you confirm this please? 

There is a timestamp on superblock but it isn't used much.  The 'event
count' is used more.
So if you have a mirrored pair and :
  - stop it
  - restart with just one device - do some stuff, and stop it
  - restart with just the other device, do some stuff, and stop
  - reassemble the pair
then the 'primary' could easily be either of the two, depending on
which got the most event updates.

Just don't do this.

Again: what do you really want to do?

NeilBrown

From: Janek Kozicki <janek_listy@wp.pl>
Subject: Re: mapping ataXX.YY to a /dev/sdX
Date: Thu, 8 Jul 2010 23:26:31 +0200
Message-ID: <20100708232631.014a5ade@atak.bl.pg.gda.pl>
References: <alpine.DEB.1.10.1007070810540.23489@uplift.swm.pp.se>
 <87wrt7ijp3.fsf@rimspace.net>
 <alpine.DEB.1.10.1007071749320.23489@uplift.swm.pp.se>
 <4C35A2FC.5080402@buttersideup.com>
 <alpine.DEB.1.10.1007081214590.23489@uplift.swm.pp.se>
 <20100708104422.GA32564@cthulhu.home.robinhill.me.uk>
 <alpine.DEB.1.10.1007081259560.23489@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.1007081259560.23489@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mikael Abrahamsson said:     (by the date of Thu, 8 Jul 2010 13:05:06 +0200 (CEST))

> On Thu, 8 Jul 2010, Robin Hill wrote:
> 
> > It would look like ata14 is the equivalent of scsi13 then - lsscsi or 
> > "cat /proc/scsi" should show you the drives connected on controller 13 
> > (or look in /sys/class/scsi_disk/13*/device/block).
> 
> Oki, yes, that's true, but the mapping from scsi13 to sdj isn't really my 
> problem, I can find that out in quite a few ways. It's the mapping of 
> ata14.00 to scsi13 that I can say is likely (from dmesg), but not certain.

could you make some trial and error tests, while staying safe?

turn off the array. Shut down. Unplug sdj, boot up. See if it is sdj
that disappeared, but do not assemble the array (so that it won't get
corrupted).

-- 
Janek Kozicki                               http://janek.kozicki.pl/  |

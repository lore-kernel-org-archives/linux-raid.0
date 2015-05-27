From: "Wilson, Jonathan" <piercing_male@hotmail.com>
Subject: Re: Which physical device failed?
Date: Wed, 27 May 2015 19:16:04 +0100
Message-ID: <BLU436-SMTP2403ED333F23D8DB23296C398CB0@phx.gbl>
References: <5565B2BB.5090701@gmail.com>	<5565B41B.8040104@aei.mpg.de>
	 <20150527172701.1090e525@natsu> <5565C3AA.7020809@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5565C3AA.7020809@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Roman Mamedov <rm@romanrm.net>, Carsten Aulbert <Carsten.Aulbert@aei.mpg.de>, Michael Munger <michael.munger@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 2015-05-27 at 09:16 -0400, Phil Turmel wrote:
> On 05/27/2015 08:27 AM, Roman Mamedov wrote:
> > On Wed, 27 May 2015 14:10:03 +0200
> > Carsten Aulbert <Carsten.Aulbert@aei.mpg.de> wrote:
> > 
> >> On 05/27/2015 02:04 PM, Michael Munger wrote:
> >>> Or, does the OS have access to serial numbers, etc...?
> >>>
> >>> I have to guide someone through a drive replacement on the phone, and it
> >>> would be great if I could tell them exactly which drive to swap out...
> >>
> >> If you have direct knowledge, which serial number is where, you could
> >> use hdparm -I /dev/sdX or smartctl -a /dev/sdX against the still
> >> reachable drives.
> > 
> > If /dev/sdc is still present in the system (even if not responding correctly to
> > hdparm or smartctl anymore), you should be able to find its serial number from
> > the udev symlink that was registered earlier, by running e.g.:
> > 
> >   ls -la /dev/disk/by-id/ | grep sdc$
> > 
> > Serial number is typically the last piece of the ID, after the manufacturer
> > name and model number.
> > 
> 
> This is one of the reasons I wrote lsdrv [1], especially after I noticed
> that the port sequence it reports is stable for the various ports on
> every mobo  and sata expansion card I've handled.  Per controller, at least.

Interesting that you should say that as on my z97 board if I do a power
off, power on, the drives do indeed stay numbered to the sata ports...
however if I do a "restart" sometimes, very rarely, the drives are
listed with different sdX designations. It may be a quirk of either the
efi, linux, or the fact the drives are not, I believe, turned off during
a restart which may impact on designation. I didn't investigate the whys
as I just noticed that two drives had swapped in two arrays (sdb moved
from a raid10 into the raid6 and that sdc moved from the raid6 into the
raid10) which scared the heck out of me until I realised that it was
just the sdX that had changed not the drives so for one minute I was
expecting massive problems to ensue.



> 
> I save of copy of an lsdrv report for each system I commission so that
> there's no ambiguity later.
> 
> Phil
> 
> [1] https://github.com/pturmel/lsdrv
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 



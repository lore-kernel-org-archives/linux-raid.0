From: David Nedved <dnedved@nuvox.net>
Subject: Re: how to change sector size on fibrechannel drives
Date: Wed, 12 Jun 2002 23:39:31 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020612233931.A26722@nuvox.net>
References: <20020612171724.A25071@nuvox.net> <1023917694.4763.2.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1023917694.4763.2.camel@localhost.localdomain>; from scott@bisker.com on Wed, Jun 12, 2002 at 05:34:54PM -0400
To: Scott Bisker <scott@bisker.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks Scott, I'll check it out.  Also, I apologize for sending
this to linux-raid, I meant to type linux-scsi, but made a typo.

Thanks even more for answering an off-topic question!

David

On Wed, Jun 12, 2002 at 05:34:54PM -0400, Scott Bisker wrote:
> I know emulex has some utilities available for linux
> 
> http://www.emulex.com/ts/docfc/linuxframe.htm
> 
> I think the one you are looking for is lputil (LPUTIL).
> 
> -sb
> 
> 
> On Wed, 2002-06-12 at 17:17, David Nedved wrote:
> > Hi All,
> > 
> > I've salvaged some drives from a MTI fibre channel RAID device, and I'm
> > trying to use them in linux 2.4.18.  When the scsi module loads, it sees
> > the drives, but reports them all as having the dreaded
> > "unsupported sector size 528" message.  All the searches I've done seem
> > to indicate a low-level format of the drives.   The FC card I'm using,
> > however (Emulex LP8000), doesn't seem to have an option for low-level
> > formatting.
> > 
> > My fibre channel toys are rather limited, in other words, I don't have
> > any other controllers with which to low-level these drives.
> > 
> > Am I out of luck?  I wouldn't mind the inefficiency of only using 512
> > of the 528 bytes in each block if there's some way to override the
> > default setting... although I would much rather reformat them...
> > 
> > Oh, the drives are all ST136403FC drives if that matters.
> > 
> > Thanks in advance for any clues...
> > 
> > David
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
   __   __   __ _ __ __      __  __ ____ __   __ _ ____ __
  /  | /, | / / // //  |    /  |/ // __//  | / / // __//  |
 / / //   // / // // / /   / , ' // _/ / / // / // _/ / / /
/___//_/_/ |__//_//___/   /_/|__//___//___/ |__//___//___/

Unix Systems Engineer              VOICE: +1 864 331 8181
NuVox Communications, Inc.         FAX:   +1 864 331 7234
301 North Main Street, Ste 5000    EMAIL: dnedved@nuvox.net
Greenville, SC  29601   USA        PAGER: pagenedved@nuvox.net

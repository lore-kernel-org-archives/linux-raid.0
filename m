From: Doug Ledford <dledford@redhat.com>
Subject: Re: RFC - new raid superblock layout for md driver
Date: Thu, 21 Nov 2002 16:55:09 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20021121215509.GJ14063@redhat.com>
References: <15835.2798.613940.614361@notabene.cse.unsw.edu.au> <1037914176.9122.2.camel@irongate.swansea.linux.org.uk> <20021121212251.GI14063@redhat.com> <02112114532304.06518@boiler>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <02112114532304.06518@boiler>
To: Kevin Corry <corryk@us.ibm.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Steven Dake <sdake@mvista.com>, Joel Becker <Joel.Becker@oracle.com>, Neil Brown <neilb@cse.unsw.edu.au>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Nov 21, 2002 at 02:53:23PM -0600, Kevin Corry wrote:
> 
> LVM doesn't handle the filesystem resizing, the filesystem tools do. The only 
> thing you need is something in user-space to ensure the correct ordering. For 
> an expand, the MD device must be expanded first. When that is complete, 
> resizefs is called to expand the filesystem.
> 
> MD currently doesn't allow resize of RAID 0, 4 or 5, because expanding 
> striped devices is way ugly.

MD doesn't, raidreconf does but not online.

> If it was determined to be possible, the MD 
> driver may need additional support to allow online resize.

Yes, it would.  It's not impossible, just difficult.

> But it is just as 
> easy to add this support to MD rather than have to merge MD and DM.

Well, merging the two would actually be rather a simple task I think since 
you would still keep each md mode a separate module, the only difference 
might be some inter-communication call backs between LVM and MD, but even 
those aren't necessarily required.  The prime benefit I would see from 
making the two into one is being able to integrate all the disparate 
superblocks into a single superblock format that helps to avoid any 
possible startup errors between the different logical mapping levels.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  

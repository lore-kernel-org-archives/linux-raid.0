From: Kevin Corry <corryk@us.ibm.com>
Subject: Re: RFC - new raid superblock layout for md driver
Date: Thu, 21 Nov 2002 14:35:59 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <02112114355903.06518@boiler>
References: <15835.2798.613940.614361@notabene.cse.unsw.edu.au> <20021121203829.GH14063@redhat.com> <3DDD46E0.9040909@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3DDD46E0.9040909@mvista.com>
To: Steven Dake <sdake@mvista.com>, Doug Ledford <dledford@redhat.com>
Cc: Joel Becker <Joel.Becker@oracle.com>, Neil Brown <neilb@cse.unsw.edu.au>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday 21 November 2002 14:49, Steven Dake wrote:
> Doug,
>
> Yup this would be ideal and I think this is what EVMS tries to do,
> although I haven't tried it.

This is indeed what EVMS's new design does. It has user-space plugins that 
understand a variety of on-disk-metadata formats. There are plugins for LVM 
volumes, for MD RAID devices, for partitions, as well as others. The plugins 
communicate with the MD driver to activate MD devices, and with the 
device-mapper driver to activate other devices.

As for whether DM and MD kernel drivers should be merged: I imagine it could 
be done, since DM already has support for easily adding new modules, but I 
don't see any overwhelming reason to merge them right now. I'm sure it will 
be discussed more when 2.7 comes out. For now they seem to work fine as 
separate drivers doing what each specializes in. All the integration issues 
that have been brought up can usually be dealt with in user-space.

-- 
Kevin Corry
corryk@us.ibm.com
http://evms.sourceforge.net/

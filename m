From: Joel Becker <Joel.Becker@oracle.com>
Subject: Re: RFC - new raid superblock layout for md driver
Date: Thu, 21 Nov 2002 11:36:54 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20021121193653.GC770@nic1-pc.us.oracle.com>
References: <15835.2798.613940.614361@notabene.cse.unsw.edu.au> <3DDBC0D9.5030904@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3DDBC0D9.5030904@mvista.com>
To: Steven Dake <sdake@mvista.com>
Cc: Neil Brown <neilb@cse.unsw.edu.au>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Nov 20, 2002 at 10:05:29AM -0700, Steven Dake wrote:
> per-device structure.  This would allow a RAID volume to be locked to a 
> specific host, allowing the ability for true multihost operation.

	Locking to a specific host isn't the only thing to do though.
Allowing multiple hosts to share the disk is quite interesting as well.

Joel


-- 

 The zen have a saying:
 "When you learn how to listen, ANYONE can be your teacher."

Joel Becker
Senior Member of Technical Staff
Oracle Corporation
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127

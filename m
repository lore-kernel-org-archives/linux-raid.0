From: "Sean Kormilo" <skormilo@nortelnetworks.com>
Subject: Re: Expanding size of existing raid1 md device
Date: 25 Apr 2003 07:57:22 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1051271841.2851.83.camel@pcary03q.ca.nortel.com>
References: <1051210082.2852.65.camel@pcary03q.ca.nortel.com>
	 <05bf01c30a93$5cd3a3b0$f6de11cc@black>
	 <1051217226.2856.77.camel@pcary03q.ca.nortel.com>
	 <20030424171426.A17124@newbox.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20030424171426.A17124@newbox.localdomain>
To: Scott McDermott <vaxerdec@frontiernet.net>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Scott,

I'm using XFS and have the ability to grow the filesystem. That piece
isn't a problem. The issue I have is "growing" the md raid1 device.

Sean.

> Sean Kormilo on Thu 24/04 16:47 -0400:
> > One thing I forgot to mention is that I want to be able to
> > do this without taking the system down at all.
> 
> You can only do that if you have built your kernel with the
> online ext[23]-resize patches.  Otherwise there is no way to
> grow a mounted filesystem.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 

Sean C. Kormilo, STORM Software Architect, Nortel Networks
              email: skormilo@nortelnetworks.com
  


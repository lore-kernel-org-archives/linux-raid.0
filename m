From: Scott McDermott <vaxerdec@frontiernet.net>
Subject: Re: Expanding size of existing raid1 md device
Date: Thu, 24 Apr 2003 17:14:26 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030424171426.A17124@newbox.localdomain>
References: <1051210082.2852.65.camel@pcary03q.ca.nortel.com> <05bf01c30a93$5cd3a3b0$f6de11cc@black> <1051217226.2856.77.camel@pcary03q.ca.nortel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1051217226.2856.77.camel@pcary03q.ca.nortel.com>; from skormilo@nortelnetworks.com on Thu, Apr 24, 2003 at 04:47:07PM -0400
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Sean Kormilo on Thu 24/04 16:47 -0400:
> One thing I forgot to mention is that I want to be able to
> do this without taking the system down at all.

You can only do that if you have built your kernel with the
online ext[23]-resize patches.  Otherwise there is no way to
grow a mounted filesystem.

From: Paul Jakma <paul@clubi.ie>
Subject: Re: [RFCI] How best to partition MD/raid devices in 2.6
Date: Fri, 14 Nov 2003 08:04:08 +0000 (GMT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.56.0311140801030.22888@fogarty.jakma.org>
References: <16308.18387.142415.469027@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16308.18387.142415.469027@notabene.cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

On Fri, 14 Nov 2003, Neil Brown wrote:

>  4/ just use 'dm', or write a new 'md' module that can present a
>     partition of a device.  Then leave the setup to user-space.
>     This is least impact on the kernel, but most impact on
>     user-space.  It would not be too hard to create a userspace tool

From a user/admin POV, I'd say go with dm. Even the 'virt-partition
by way of dm' isnt needed if you have LVM tools, but I guess might be
nice to obviate need for extra tools. (though, I couldnt live without
LVM anymore, its just /too/ useful.).

regards,
-- 
Paul Jakma	paul@clubi.ie	paul@jakma.org	Key ID: 64A2FF6A
	warning: do not ever send email to spam@dishone.st
Fortune:
It is against the law for a monster to enter the corporate limits of
Urbana, Illinois.

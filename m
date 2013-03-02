From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Expanding array with multiple devices
Date: Sat, 2 Mar 2013 18:31:24 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1303021828510.14991@uplift.swm.pp.se>
References: <25032068.12.1362244556592.JavaMail.root@zimbra> <51323563.4@turmel.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51323563.4@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Roy Sigurd Karlsbakk <roy@karlsbakk.net>, Oliver Schinagl <oliver+list@schinagl.nl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 2 Mar 2013, Phil Turmel wrote:

> I agree.  And the file copy to the raid5 would almost certainly run 
> faster than any raid6 with "missing".  Then the reshape is one operation 
> to both expand the drive count and switch to raid6.

If he's running 2.6.32 that option isn't available (if I remember 
correctly). Since he didn't disclose what mdadm and kernel version he was 
running, I suggested the safest path that works on most kernels and mdadm 
versions.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se

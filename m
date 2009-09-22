From: "Sunpyo Hong" <sunpyo.hong@amac.com>
Subject: RE: Raid 5 Issue, cannot recognize EXT3 File system.
Date: Tue, 22 Sep 2009 11:15:38 -0400
Message-ID: <200909221115737.SM02380@trainer>
References: <20090921155621.GA29813@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090921155621.GA29813@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: 'Robin Hill' <robin@robinhill.me.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> I am stopping and starting the array. I couldn't mount in both instances.
> The before is the initial assembly array that I force assembled through
> mdadm -Af. This assembled the raid, but couldn't see an ext3 file system.

>I haven't followed all of this thread, so maybe I missed something,
>but have you considered the possibility that there is an LVM config
>on the md array, and that the ext3 filesystem is inside a logical
>volume?

>NeilBrown

Hi Neil, I already checked with western digital and its support team. What
they've told me is that the Raid is an EXT3 and is not LVM config on the HD,
however knowing WD they might just say that so I'd fork over the cash to get
my HD recovered for thousands of dollars from them. Is there a way I can
check if it's LVM config-ed? Thanks!



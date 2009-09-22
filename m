From: "NeilBrown" <neilb@suse.de>
Subject: RE: Raid 5 Issue, cannot recognize EXT3 File system.
Date: Tue, 22 Sep 2009 14:33:21 +1000
Message-ID: <078832839f5e1bb68daee9415b06b8f4.squirrel@neil.brown.name>
References: <200909211214960.SM04344@trainer>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200909211214960.SM04344@trainer>
Sender: linux-raid-owner@vger.kernel.org
To: Sunpyo Hong <sunpyo.hong@amac.com>
Cc: 'Robin Hill' <robin@robinhill.me.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, September 22, 2009 2:14 am, Sunpyo Hong wrote:
> I am stopping and starting the array. I couldn't mount in both instances.
> The before is the initial assembly array that I force assembled through
> mdadm -Af. This assembled the raid, but couldn't see an ext3 file system.

I haven't followed all of this thread, so maybe I missed something,
but have you considered the possibility that there is an LVM config
on the md array, and that the ext3 filesystem is inside a logical
volume?

NeilBrown



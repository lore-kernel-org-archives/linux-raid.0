From: "Labun, Marcin" <Marcin.Labun@intel.com>
Subject: RE: Devel 3.2 branch issues
Date: Mon, 22 Nov 2010 17:18:06 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D174BA8CE8@irsmsx503.ger.corp.intel.com>
References: <A9DE54D0CD747C4CB06DCE5B6FA2246F010BAF0FAF@irsmsx504.ger.corp.intel.com>
	<20101117212242.5ad7b210@notabene.brown>
	<A9DE54D0CD747C4CB06DCE5B6FA2246F010BE8FD35@irsmsx504.ger.corp.intel.com>
	<A9DE54D0CD747C4CB06DCE5B6FA2246F010BE90089@irsmsx504.ger.corp.intel.com>
 <20101122142953.7934c8ca@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101122142953.7934c8ca@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Czarnowska, Anna" <anna.czarnowska@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>
List-Id: linux-raid.ids

> - the getinfo_super_disks method.  I couldn't see why you need this.
> All the
>   info about the state of the arrays should already be available.
>   If there is something that you need that we don't have, please
> explain and
>   we can see how best to add it back in.

For external metadata we have added a metadata handler to get a disk state (a spare or not a spare) based on current metadata state on disk.
Ioctl(GET_DISK_INFO) does not have a disk state info for containers (returns 0 - so we don't know if it is a spare or a failed disk).
We know that a disk is an array member based on check its state in the array.

Since Monitor code on devel-3.2 does not have calls to getinfo_super_disks method, 
auto-rebuild grabs the first disk in container and tries to move it to a degraded one (without a successes), and the first one happens to be array member and have state = 0 (a good spare).
Like all disks in container. 

There is also a fatal in pol_add, when trying to update policy rules with NULL spare_group:
@@ -732,7 +738,8 @@ static int move_spare(struct state *from, struct state *to,
 				continue;
 
 			pol = devnum_policy(from->devid[d]);
-			pol_add(&pol, pol_domain, from->spare_group, NULL);
+			if (from->spare_group)
+				pol_add(&pol, pol_domain, from->spare_group, NULL);

We will send you our FT integrated with your mdadm test suit in a couple of days. 

Marcin





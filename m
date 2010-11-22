From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: RE: [Patch 00/17] Autorebuild
Date: Mon, 22 Nov 2010 15:08:27 +0000
Message-ID: <A9DE54D0CD747C4CB06DCE5B6FA2246F010BF03A1F@irsmsx504.ger.corp.intel.com>
References: <A9DE54D0CD747C4CB06DCE5B6FA2246F010BAF0FAF@irsmsx504.ger.corp.intel.com>
	<20101117212242.5ad7b210@notabene.brown>
	<A9DE54D0CD747C4CB06DCE5B6FA2246F010BE8FD35@irsmsx504.ger.corp.intel.com>
 <20101122131644.6ba971f2@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101122131644.6ba971f2@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>
List-Id: linux-raid.ids

> > 4. With spare-same-slot when there is a cookie and disk has no
> metadata then we probably shouldn't look at domains. Just add.
> >
> 
> I disagree.  We must always check domains.
> Why do you think we should ignore domains in that case?
 
Easy example is: we have an array made on two disks sda and sdb.
Sda has domain d1. Sdb has domain d2. This is perfectly ok for Create.
Now sdb fails and we put a new disk in that place. It gets domain d2 because it is in the same slot as old disk.
When the array went degraded and sdb was removed, the domain for the array was reduced to d1 only.
New disk does not match any more so it is not added.

I think we should still add it because we have a file saying that this slot belongs to that array.
There is also controller domain that has the special meaning but I don't think it is a problem.
If the user originally created the array spanning different controllers why wouldn't we take a replacement occupying the same slot as original member?

My conclusion is: we should ignore domains when there is a cookie.

Note that we don't look at domains at all when we add a disk with spare metadata. Here it is indeed very much needed.
When someone creates some arrays and adds some spares, additionally defines domains to keep all related disks together, then he may be disappointed seeing that after reboot all spares end up in one container anyway. This happens for imsm and because of this issue some spare that was meant for a different array may be used in the first array from config instead (all spares will be added there regardless of domains).

Anna

---------------------------------------------------------------------
Intel Technology Poland sp. z o.o.
z siedziba w Gdansku
ul. Slowackiego 173
80-298 Gdansk

Sad Rejonowy Gdansk Polnoc w Gdansku, 
VII Wydzial Gospodarczy Krajowego Rejestru Sadowego, 
numer KRS 101882

NIP 957-07-52-316
Kapital zakladowy 200.000 zl

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.


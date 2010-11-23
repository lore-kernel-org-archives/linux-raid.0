From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: RE: Devel 3.2 branch issues
Date: Tue, 23 Nov 2010 12:04:37 +0000
Message-ID: <A9DE54D0CD747C4CB06DCE5B6FA2246F010BF9203D@irsmsx504.ger.corp.intel.com>
References: <A9DE54D0CD747C4CB06DCE5B6FA2246F010BF03CC6@irsmsx504.ger.corp.intel.com>
 <20101123115213.3664ec27@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101123115213.3664ec27@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>
List-Id: linux-raid.ids


> I don't think it is possible to come up with an automatic way to
> determine if
> a given spare suits a given array that is always correct.  There are
> too many
> subtleties.
> So I would like to allow the sysadmin to exercise complete control, and
> have
> defaults that make reasonable sense in common cases.
> 
> The 'complete control' can be exercised through domain - though I will
> probably add some size based rule mechanism to the policy code so
> devices can
> be categorised by size if wanted.
> The 'safe default' is probably best left to the metadata handler.  So
> ultimately all metadata types *should* specify
> min_acceptable_spare_size,
> and we will just make do with that.
> 
> Does that sound OK?

Yes. 
When all metadata types have min_acceptable_spare_size there will be no need for min_active_disk_size at all.
One more thought: Manage_subdevs checks component_size so for native metadata it will not allow to add a spare that is too small.
But checking size in Monitor will prevent unnecessary removal and re-adding. 
It would make sense to get Manage_subdevs to check the size properly for external metadata too.
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


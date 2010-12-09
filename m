From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: spare-same-slot question
Date: Thu, 9 Dec 2010 14:10:21 +0000
Message-ID: <A9DE54D0CD747C4CB06DCE5B6FA2246F010E24D62C@irsmsx504.ger.corp.intel.com>
References: <905EDD02F158D948B186911EB64DB3D17676E3B8@irsmsx503.ger.corp.intel.com>
	<20101208132942.1a59efb1@notabene.brown>
	<905EDD02F158D948B186911EB64DB3D176A1AE79@irsmsx503.ger.corp.intel.com>
 <20101209083724.3228dc34@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101209083724.3228dc34@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>
List-Id: linux-raid.ids

Hi,
Here is my observation:
Imagine that we have an array that went degraded leaving a cookie (appropriate config is there).
When we plug in a disk without metadata into the same slot that was used by this array
mdadm should add the new disk to that array. This is the way it goes at the moment.

What should happen when we connect a disk with spare metadata to this slot?

At the moment it is added to the original array or (imsm) anywhere.
Wouldn't it be reasonable to use the slot information when we have a spare?

In some cases Monitor will move it anyway but there is a chance that 
another array may get it before the "owner" of this slot.
Or that Monitor may not move it as domain of the array doesn't include 
domain of this slot any more.
We agreed that domain shouldn't be checked when there is a cookie but this only applies to Incremental.
(It will be implemented shortly.)

"spare-same-slot" sounds to me like a spare in the same slot should also go to the array described by cookie.
What is your opinion?

Anna

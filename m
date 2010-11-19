From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: Devel 3.2 branch issues
Date: Fri, 19 Nov 2010 12:43:20 +0000
Message-ID: <A9DE54D0CD747C4CB06DCE5B6FA2246F010BE90089@irsmsx504.ger.corp.intel.com>
References: <A9DE54D0CD747C4CB06DCE5B6FA2246F010BAF0FAF@irsmsx504.ger.corp.intel.com>
 <20101117212242.5ad7b210@notabene.brown>
 <A9DE54D0CD747C4CB06DCE5B6FA2246F010BE8FD35@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A9DE54D0CD747C4CB06DCE5B6FA2246F010BE8FD35@irsmsx504.ger.corp.intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>
List-Id: linux-raid.ids

Hi Neil,
Our validation team have reported problems with assembly on the devel 3.2 branch.
I have verified that currently it is not possible to assemble any array.

Patch: Assemble - avoid including wayward devices
It does not affect native metadata but breaks assembly of external arrays.
Only one disk is assembled for any raid level. 

After patch: super_by_fd: return subarray info explicitly
Assembly becomes much slower.

Patch: Assemble: small cleanup of error checking
Breaks assembly for all metadata types. Nothing assembles after it is applied.

These are just early modifications of Assemble.c. The impact of further changes
can't be verified at the moment. 
Are you aware of the above issues? This is stopping our further validation.
I also mentioned issues with Incremental in previous mail.
When are you planning to submit the rest of modified autorebuild code?

Regards
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


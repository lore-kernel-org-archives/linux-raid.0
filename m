From: "Labun, Marcin" <Marcin.Labun@intel.com>
Subject: RE: [PATCH 2/2] IMSM: do not rebuild the array if a non-redundant
 sub-array with failed disks is present
Date: Wed, 8 Dec 2010 14:59:26 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D17676EB61@irsmsx503.ger.corp.intel.com>
References: <905EDD02F158D948B186911EB64DB3D17676E3C3@irsmsx503.ger.corp.intel.com>
 <20101208133208.0f62b900@notabene.brown>
 <905EDD02F158D948B186911EB64DB3D17676EB3F@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <905EDD02F158D948B186911EB64DB3D17676EB3F@irsmsx503.ger.corp.intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Czarnowska, Anna" <anna.czarnowska@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>
List-Id: linux-raid.ids

> >
> > This seems to imply that there are only ever at most 2 volumes in a
> > container.  Is that really true?  The rest of the code seems to
> assume
> > that
> > there could be several.
> 
> 
> There are at most two sub-array in one array.
> 
One correction. As I said in legacy imsm there at most two volumes, however, there is an assumption 
that in IMSM_NO_PLATFORM mode it should support more then 2.
So this needs to be corrected, too.
Marcin


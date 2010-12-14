From: Neil Brown <neilb@suse.de>
Subject: Re: PATCH 1/2] IMSM: Fix problem in mdmon monitor of using removed
 disk from in imsm container.
Date: Tue, 14 Dec 2010 15:30:45 +1100
Message-ID: <20101214153045.139be105@notabene.brown>
References: <905EDD02F158D948B186911EB64DB3D176AAED46@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <905EDD02F158D948B186911EB64DB3D176AAED46@irsmsx503.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Labun, Marcin" <Marcin.Labun@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

On Mon, 13 Dec 2010 16:27:20 +0000 "Labun, Marcin" <Marcin.Labun@intel.com>
wrote:

> Hi Neil,
> Reworked according your suggestion:
> - fd removed from remove_from_super() parameters list.
> Marcin

Thanks.  I've applied both of these.

NeilBrown


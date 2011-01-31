From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 0/2] Release 3.2 summary
Date: Mon, 31 Jan 2011 17:34:06 +1100
Message-ID: <20110131173406.1c69d042@notabene.brown>
References: <20110127154905.11703.56960.stgit@gklab-128-111.igk.intel.com>
	<20110128112606.076f6d49@nbeee.brown>
	<BE2BFE91933D1B4089447C644860408067042CDE@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BE2BFE91933D1B4089447C644860408067042CDE@irsmsx503.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Wojcik, Krzysztof" <krzysztof.wojcik@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Kwolek, Adam" <adam.kwolek@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

On Sat, 29 Jan 2011 17:52:45 +0000 "Wojcik, Krzysztof"
<krzysztof.wojcik@intel.com> wrote:

> Neil,
> 
> Thank you for applying last patches.
> It seems that only two patches left to complete features planed for 3.2 release:
> - imsm: Update metadata for second array
> - imsm: FIX: not all disks are released in free_imsm_disks()
> 
> Please, apply them if they are meet your requirements.

All the acceptable patches are now in my devel-3.2 branch

   git://neil.brown.name/mdadm devel-3.2

It still doesn't pass all of my self-tests, though it is getting closer.
Hopefully it will pass them all tomorrow.

> 
> I would also mention that we expect that the kernel patches will be applied.

All the acceptable patches are now in my for-next branch:

    git://neil.brown.name/md  for-next

Others have been replied to.

NeilBrown


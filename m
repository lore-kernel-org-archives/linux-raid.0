From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 0/2] Release 3.2 summary
Date: Mon, 31 Jan 2011 10:44:56 +1100
Message-ID: <20110131104456.117da756@notabene.brown>
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
> 
> After the 3.2 release we plan to submit to you next mdadm's features.

This is probably not a good idea.  I don't want to add new features to mdadm
until I am sure that the current ones are stable - and I am not.

I need to see lots of testing of the current features - both for IMSM
metadata and for native metadata, including restart of an array that is
undergoing reshape etc.
I also need to do quite a bit of code review.  Reviewing each patch as it
goes in is of course important, but it is quite possible to miss things in
that process.  The recent changes evolved quite a bit as they were being
developed, so I am far from confident that the final form really is right.

> On Monday I will send you a draft plan our next steps related to mdadm (what and at what time we plan to submit)
> I hope that this will improve our cooperation.

I'll be happy to look over your draft plan and comment on it, but I don't
expect to be reviewing/accepting any patches for new functionality at least
until 3.2.1 is out which will be primarily bug fixes.

NeilBrown



> 
> I would also mention that we expect that the kernel patches will be applied.
> 
> Regards
> Krzysztof
> 

From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: Something wrong with __prep_thunderdome in super-intel.c
Date: Fri, 25 Mar 2011 11:50:27 -0700
Message-ID: <4D8CE3F3.8090505@intel.com>
References: <20110314140052.20478.45664.stgit@gklab-128-013.igk.intel.com>	 <20110315085346.3bf9feb7@notabene.brown>	 <905EDD02F158D948B186911EB64DB3D17A9910DD@irsmsx503.ger.corp.intel.com>	 <20110322132307.34e9bb3b@notabene.brown> <1301020846.15264.12.camel@dwillia2-linux>  <905EDD02F158D948B186911EB64DB3D19204D155@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <905EDD02F158D948B186911EB64DB3D19204D155@irsmsx503.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Kwolek, Adam" <adam.kwolek@intel.com>
Cc: NeilBrown <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Wojcik, Krzysztof" <krzysztof.wojcik@intel.com>
List-Id: linux-raid.ids

On 3/25/2011 1:43 AM, Kwolek, Adam wrote:
>
> Unfortunately this doesn't close issue.
>
> I've reached the same from IMSM compatibility point of view, but have in mind that unit test suit 11 fails using this approach.
> Put focus on test 5 in this suit (I'm using it, as this is the only one that fails for me) for IMSM (note that first test pass is for native metadata).
> Using your path tests 5b and 5c fails. My code fails 5c test only. I'm currently working on it.

I am seeing a different failing set (after applying Anna's patches): 1, 
1a, 2, 4, 5b, 5c...

One thing too look out for is that failed disks will no longer self 
identify.  Prior to this mdadm would update the metadata on failed disks 
to show "failed", now the disk must be viewed in relation to others to 
determine if it is stale or not.  This makes the mdadm -f case more in 
line with the hot removed case.

--
Dan

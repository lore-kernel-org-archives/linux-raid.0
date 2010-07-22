From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 1/2] md: raid5 return new layout in mdstat while reshaping
Date: Wed, 21 Jul 2010 17:58:43 -0700
Message-ID: <AANLkTikwhea8haXm1Pdu-iQZ50Rtd5qixU2oNa7T2VZc@mail.gmail.com>
References: <AcsoxGax1b+/Kg5eR/SJirk+wfgLpw==>
	<BE2BFE91933D1B4089447C64486040804E2A4993@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BE2BFE91933D1B4089447C64486040804E2A4993@irsmsx503.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Trela, Maciej" <Maciej.Trela@intel.com>
Cc: Neil Brown <neilb@suse.de>, "Kwolek, Adam" <adam.kwolek@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Jul 21, 2010 at 4:03 AM, Trela, Maciej <Maciej.Trela@intel.com> wrote:
> From: Maciej Trela <maciej.trela@intel.com>
>
> While reshaping, report mdstat algorithm according to the new_layout.

It's not immediately clear to me why this is needed?  The md/layout
attribute in sysfs shows the new_layout during reshape if userspace
forgets what it changed (should also be recorded in the metadata).  If
it is needed then spell that out in the commit message.

--
Dan

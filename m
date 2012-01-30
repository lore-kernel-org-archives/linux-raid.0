From: "Labun, Marcin" <Marcin.Labun@intel.com>
Subject: RE: [PATCH 5/5] imsm: verify maximum supported active volumes in
 assembly
Date: Mon, 30 Jan 2012 10:24:25 +0000
Message-ID: <F9123E44003394499FDD2B17C60621D408AE9B@IRSMSX101.ger.corp.intel.com>
References: <F9123E44003394499FDD2B17C60621D4075DE9@IRSMSX101.ger.corp.intel.com>
 <20120130120232.236c5343@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120130120232.236c5343@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Kwolek, Adam" <adam.kwolek@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>
List-Id: linux-raid.ids

Hi,
> 
> hi,
>  I've applied the first four in this series, but I don't like this one.
> 
> 1/ I don't think there is any need to impose this restriction when
>    assembling an array - only when creating a new volume in an array.
We want to support only as many volumes as OROM (platform) supports. Disks with IMSM metadata may be carried from other systems.

> 
> 2/ The check_volumes_number approach feels clumsy ... there must be a
>    a better way (Assuming it is needed at all).
container_content handler is to check OROM capabilities and mark unsupported volumes with 
disable bits (array.state:MD_SB_BLOCK_CONTAINER_RESHAPE and MD_SB_BLOCK_VOLUME). The caller function shall interpret the bits and act
accordingly to the context (for instance block activation but display the volume information). I think that this restriction
falls into that area. However, there are only a few situations when this info is really needed ie. When volumes are activated in various ways.
Therefore I thought it makes sense to pass the info if counting of activate volumes is really needed. 
More straightforward option is to add another input parameters to container_content and change it in numerous places.
Do you prefer this way? Or add a specialized handler to count the volumes when it is needed?
Thanks,
Marcin Labun

From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [mdadm PATCH 0/2] two 3.1.3 regression fixes (incremental assembly)
Date: Tue, 10 Aug 2010 16:40:46 -0700
Message-ID: <4C61E37E.4060403@intel.com>
References: <20100810164551.26691.17944.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100810164551.26691.17944.stgit@localhost.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: "neilb@suse.de" <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, Ignacy Kasperowicz <ignacy.kasperowicz@intel.com>
List-Id: linux-raid.ids

On 8/10/2010 9:46 AM, Williams, Dan J wrote:
> Hi Neil,
>
> The mdadm -I --no-degraded option needs to be acceptable for some time
> to come, do you have a policy for when deprecated options can be scheduled for
> removal?  The error code for -I shall be zero in the 'not enough' case to
> restore the correct and established pre-3.1.3 behavior.
>
> Also available via git:
>
>     git://github.com/djbw/mdadm.git master
>
> ---
>
> Dan Williams (2):
>        Incremental: return success in 'container not enough' case
>        Incremental: accept '--no-degraded' as a deprecated option

Note, both of these should have been tagged:

Reported-by: Ignacy Kasperowicz <ignacy.kasperowicz@intel.com>

If you take the patches directly.

Thanks,
Dan

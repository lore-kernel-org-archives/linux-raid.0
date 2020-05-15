From: Jes Sorensen <jes@trained-monkey.org>
Subject: Re: [PATCH, v2] Makefile: add EXTRAVERSION support
Date: Fri, 15 May 2020 09:52:14 -0400
Message-ID: <90b6261f-f0dd-1a0c-f91b-21e47f1deef1@trained-monkey.org>
References: <20200515092314.2711-1-mariusz.tkaczyk@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200515092314.2711-1-mariusz.tkaczyk@intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Tkaczyk Mariusz <mariusz.tkaczyk@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 5/15/20 5:23 AM, Tkaczyk Mariusz wrote:
> Add optional EXTRAVERSION parameter to Makefile and allow to mark version
> by user friendly label. It might be useful when creating custom
> spins of mdadm, or labeling some instance in between major releases.
> 
> Signed-off-by: Tkaczyk Mariusz <mariusz.tkaczyk@intel.com>
> ---
> 
> V2: rename LABEL to EXTRAVERSION.

Applied!

Thanks,
Jes

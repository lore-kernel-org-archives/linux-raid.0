From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [PATCH] Get failed disk count from array state
Date: Fri, 19 May 2017 15:43:07 -0400
Message-ID: <bc4470f4-20bf-c45a-9d96-385e4b46e1e3@gmail.com>
References: <1494850636-28438-1-git-send-email-tomasz.majchrzak@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1494850636-28438-1-git-send-email-tomasz.majchrzak@intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Tomasz Majchrzak <tomasz.majchrzak@intel.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 05/15/2017 08:17 AM, Tomasz Majchrzak wrote:
> Recent commit has changed the way failed disks are counted. It breaks
> recovery for external metadata arrays as failed disks are not part of
> the array and have no corresponding entries is sysfs (they are only
> reported for containers) so degraded arrays show no failed disks.
> 
> Recent commit overwrites GET_DEGRADED result prior to GET_STATE and it
> is not set again if GET_STATE has not been requested. As GET_STATE
> provides the same information as GET_DEGRADED, the latter is not needed
> anymore. Remove GET_DEGRADED option and replace it with GET_STATE
> option.
> 
> Don't count number of failed disks looking at sysfs entries but
> calculate it at the end. Do it only for arrays as containers report
> no disks, just spares.

Hi Tomasz,

I have been sitting on a stack of patches in this area as I wanted to 
test them before pushing them out. I finally got a change to run the 
testsuite and pushed them, but your patch no longer applied.

Would you mind having a look at the current trunk and see how you want 
to address it?

Thanks,
Jes

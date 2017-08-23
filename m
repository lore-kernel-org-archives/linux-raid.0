From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [PATCH] Detail: differentiate between container and inactive
 arrays
Date: Wed, 23 Aug 2017 13:43:07 -0400
Message-ID: <13b894c3-a7b7-5d7e-46cc-a653eb04282c@gmail.com>
References: <1503050423-20984-1-git-send-email-mariusz.tkaczyk@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1503050423-20984-1-git-send-email-mariusz.tkaczyk@intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 08/18/2017 06:00 AM, Mariusz Tkaczyk wrote:
> Containers used to be handled as active arrays because GET_ARRAY_INFO
> ioctl returns valid structure for them. As containers appear as inactive
> in sysfs, the output for detail command has changed.
> 
> Stop relying on inactive state for containers. Make the output look the
> same as in mdadm 4.0.
> 
> Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>

Applied!

Thanks,
Jes


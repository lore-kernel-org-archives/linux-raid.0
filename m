From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [PATCH] Grow.c: Block any level migration with chunk size change
Date: Thu, 25 Jan 2018 14:32:35 -0500
Message-ID: <979ac127-3b88-55ba-35e7-d4cdf4e910bb@gmail.com>
References: <1516889570-16742-1-git-send-email-mariusz.tkaczyk@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1516889570-16742-1-git-send-email-mariusz.tkaczyk@intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 01/25/2018 09:12 AM, Mariusz Tkaczyk wrote:
> Mixing level and chunk changes in one grow operation is not supported.
> Mdadm performs level migration correctly and ignores new chunk, but
> after migration it tries to write this chunk to sysfs properties.
> This is dangerous and can cause unexpected behaviours.
> 
> Block it before level migration starts.
> 
> Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>

Applied!

Thanks,
Jes


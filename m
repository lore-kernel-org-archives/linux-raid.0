From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [mdadm PATCH 4/4] Create: tell udev device is not ready when
 first created.
Date: Thu, 20 Apr 2017 13:29:53 -0400
Message-ID: <dedd27cd-9c2e-f244-d8aa-7a074679d3c6@gmail.com>
References: <149265560315.31004.3851231165281498425.stgit@noble>
 <149265600601.31004.323865505557190368.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <149265600601.31004.323865505557190368.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/19/2017 10:40 PM, NeilBrown wrote:
> When an array is created the content is not initializes,
> so it could have remnants of an old filesystem or md array
> etc on it.
> udev will see this and might try to activate it, which is almost
> certainly not what is wanted.
>
> So create a temporary udev rules files to set ENV{SYSTEMD_READY}="0"
> while the creation event is processed.  This is fairly uniformly
> used to suppress actions based on the contents of the device.
>
> Signed-off-by: NeilBrown <neilb@suse.com>
> ---
>  Create.c |    9 +++++++++
>  lib.c    |   22 ++++++++++++++++++++++
>  mdadm.h  |    2 ++
>  3 files changed, 33 insertions(+)

Neil,

I have heard of this problem before, but I have some concerns about the 
solution. First of all, /run/udev/rules.d/ isn't a universal directory. 
At least Fedora doesn't have it, so we need to take that into account. I 
wasn't aware it was possible to create temporary udev rules like this.

Second, isn't this going to be racey if you have multiple arrays 
running? I am wondering if we cannot find a solution that relies on a 
permanently installed udev rule that we enable/disable with systemctl 
and use the device name as an argument?

Thoughts?

Jes


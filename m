From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [PATCH v3] udev rules: introduce rules for cluster-md to confirm
 device
Date: Wed, 2 Aug 2017 09:31:22 -0400
Message-ID: <3d3a6efb-c9a8-52bf-83e7-fd20ee4908cd@gmail.com>
References: <20170801031504.8452-1-gqjiang@suse.com>
 <20170802020541.3412-1-gqjiang@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170802020541.3412-1-gqjiang@suse.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>, linux-raid@vger.kernel.org
Cc: neilb@suse.com
List-Id: linux-raid.ids

On 08/01/2017 10:05 PM, Guoqing Jiang wrote:
> For cluster scenario, add device is different with native raid.
> When a node issues adds a device, then the node will broadcast
> a message with UUID to other nodes in the cluster. If receiving
> node can find the device with the specific UUID, it must confirm
> the device, otherwise reports it is missing.
> 
> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
> ---
>   Makefile                               |  6 ++++--
>   udev-md-clustered-confirm-device.rules | 21 +++++++++++++++++++++
>   2 files changed, 25 insertions(+), 2 deletions(-)
>   create mode 100644 udev-md-clustered-confirm-device.rules

Looks reasonable to me - and thanks Neil for the previous reviews.

Applied!

Jes


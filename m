From: Roman Mamedov <rm@romanrm.net>
Subject: Re: Accidentally resized array to 9
Date: Sat, 30 Sep 2017 00:50:05 +0500
Message-ID: <20170930005005.68beae8b@natsu>
References: <0e59cefd-662f-bf77-0c32-49424d504c77@benshoshan.com>
        <20170929175524.57fea3b5@natsu>
        <fec79486-8f23-74dd-9c62-4f89ac00b95d@benshoshan.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <fec79486-8f23-74dd-9c62-4f89ac00b95d@benshoshan.com>
Sender: linux-raid-owner@vger.kernel.org
To: Eli Ben-Shoshan <eli@benshoshan.com>
Cc: linux-raid@vger.kernel.org, John Stoffel <john@stoffel.org>
List-Id: linux-raid.ids

On Fri, 29 Sep 2017 10:53:57 -0400
Eli Ben-Shoshan <eli@benshoshan.com> wrote:

> I am just hoping that there might be a way that I can get the 
> data back.

In theory what you did was cut the array size to only use 9 KB of each device,
then reshaped THAT tiny array from 8 to 9 devices, with the rest left
completely untouched.

So you could try removing the "new" disk, then try --create --assume-clean
with old devices only and --raid-devices=8.

But I'm not sure how you would get the device order right.

Ideally what you can hope for, is you would get the bulk of array data intact,
only with the first 9 KB of each device *(8-2), so about the first 54 KB of
data on the md array, corrupted and unusable. It is likely the LVM and
filesystem tools will not recognize anything due to that, so you will need to
use some data recovery software to look for and save the data.

-- 
With respect,
Roman

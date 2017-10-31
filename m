From: Erik Berg <erik.berg@digitalgarden.no>
Subject: Re: [PATCH] Monitor: Allow taking spare from rebuilding array
Date: Tue, 31 Oct 2017 11:23:45 +0000
Message-ID: <dcdc90fd-0d17-578b-ade8-5da21261e787@digitalgarden.no>
References: <eddc14d2-8210-a73d-d879-7d709de4fde1@digitalgarden.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <eddc14d2-8210-a73d-d879-7d709de4fde1@digitalgarden.no>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com, jsorensen@fb.com
List-Id: linux-raid.ids

On 10/25/2017 10:37 AM, Erik Berg wrote:
> When you have a box with 60 8TB drives, 8 RAID6 sets and 12 spares
> assigned to the first set, and the first set has a failed disk and is
> rebuilding, spares aren't given to other sets with failing disks.
> Waiting 2-3 days for a rebuild to complete before giving out spares to
> other failing sets seems excessive.

Anyone got any comments/opinions on this, or suggestions as to other 
ways of doing this?

We'd ultimately just like to have a pool of 12 spares that can go to any 
raid-set as drives fail.


--
erikberg

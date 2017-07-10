From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [PATCH v2] Monitor: don't assume mdadm parameter is a block
 device
Date: Mon, 10 Jul 2017 13:40:28 -0400
Message-ID: <53e5b16d-0f69-ac8a-3955-d9871001a386@gmail.com>
References: <20170619091658.GA9305@proton.igk.intel.com>
 <1497863993-9725-1-git-send-email-tomasz.majchrzak@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1497863993-9725-1-git-send-email-tomasz.majchrzak@intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Tomasz Majchrzak <tomasz.majchrzak@intel.com>, linux-raid@vger.kernel.org
Cc: zlliu@suse.com
List-Id: linux-raid.ids

On 06/19/2017 05:19 AM, Tomasz Majchrzak wrote:
> If symlink (e.g. /dev/md/raid) is passed as a parameter to mdadm --wait,
> it fails as it's not able to find a corresponding entry in /proc/mdstat
> output. Get parameter file major:minor and look for block device name in
> sysfs. This commit is partial revert of commit 9e04ac1c43e6
> ("mdadm/util: unify stat checking blkdev into function").
> 
> Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
> ---
>   Monitor.c | 13 +++++++++++--
>   1 file changed, 11 insertions(+), 2 deletions(-)
> 
> v2:
>    corrected referenced commit title in commit message

Applied!

Thanks,
Jes


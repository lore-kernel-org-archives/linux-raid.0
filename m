From: Jes Sorensen <jsorensen@fb.com>
Subject: Re: [PATCH] sysfs: include faulty drive in disk count
Date: Thu, 9 Nov 2017 15:46:08 -0500
Message-ID: <f8739ccc-3ca5-ed7a-4b3b-30e867a4f5de@fb.com>
References: <1510069796-17515-1-git-send-email-mariusz.tkaczyk@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1510069796-17515-1-git-send-email-mariusz.tkaczyk@intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/07/2017 10:49 AM, Mariusz Tkaczyk wrote:
> When the disk fails, it goes into faulty state first and it is removed
> from the array in a while. It gives mdadm monitor a chance to see the disk
> has failed and notify an event (e.g. FailSpare). It doesn't work when 
> sysfs is used to get a number of disks in the array as it skips faulty
> disk. ioctl implementation doesn't differentiate between active and
> faulty disk. Do the same for sysfs then. It should not matter that number
> of disks reported is greater than list of disk structures returned by the
> call because the same approach already takes place for offline disks.
> 
> Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
> ---
>  sysfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied!

Thanks,
Jes


From: Guoqing Jiang <gqjiang@suse.com>
Subject: Re: [PATCH V1] md/raid10: refactor some codes from
 raid10_write_request
Date: Mon, 20 Mar 2017 16:28:35 +0800
Message-ID: <58CF92B3.3050900@suse.com>
References: <201703201246.zBo2ZrYb%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201703201246.zBo2ZrYb%fengguang.wu@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: kbuild test robot <lkp@intel.com>
Cc: kbuild-all@01.org, linux-raid@vger.kernel.org, shli@fb.com, neilb@suse.com
List-Id: linux-raid.ids



On 03/20/2017 01:05 PM, kbuild test robot wrote:
> Hi Guoqing,
>
> [auto build test ERROR on next-20170310]
> [also build test ERROR on v4.11-rc3]
> [cannot apply to md/for-next v4.9-rc8 v4.9-rc7 v4.9-rc6]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
>
> url:    https://github.com/0day-ci/linux/commits/Guoqing-Jiang/md-raid10-refactor-some-codes-from-raid10_write_request/20170320-124148
> config: x86_64-randconfig-x004-201712 (attached as .config)
> compiler: gcc-6 (Debian 6.2.0-3) 6.2.0 20160901
> reproduce:
>          # save the attached .config to linux build tree
>          make ARCH=x86_64
>
> All errors (new ones prefixed by >>):
>
>     drivers/md/raid10.c: In function 'raid10_write_one_disk':
>>> drivers/md/raid10.c:1203:29: error: 'i' undeclared (first use in this function)
>       int devnum = r10_bio->devs[i].devnum;
>                                  ^
>     drivers/md/raid10.c:1203:29: note: each undeclared identifier is reported only once for each function it appears in
>
> vim +/i +1203 drivers/md/raid10.c
>
>    1197		const unsigned long do_fua = (bio->bi_opf & REQ_FUA);
>    1198		unsigned long flags;
>    1199		struct blk_plug_cb *cb;
>    1200		struct raid10_plug_cb *plug = NULL;
>    1201		struct r10conf *conf = mddev->private;
>    1202		struct md_rdev *rdev;
>> 1203		int devnum = r10_bio->devs[i].devnum;

Oops, I forgot to compile it, :-

Thanks,
Guoqing

From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [PATCH v2 1/3] mdadm/test: Refactor and revamp 'test' script
Date: Mon, 10 Jul 2017 13:31:49 -0400
Message-ID: <0eb07878-815c-82c8-c869-1646ab4e4863@gmail.com>
References: <1497445373-27985-1-git-send-email-zlliu@suse.com>
 <1497445373-27985-2-git-send-email-zlliu@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1497445373-27985-2-git-send-email-zlliu@suse.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Zhilong Liu <zlliu@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 06/14/2017 09:02 AM, Zhilong Liu wrote:
> Adding functions:
> die()
>    uniform the abnormal situations that have to abort.
> check_env()
>    do various basic checking before running test suite.
> save_log()
>    collect array infos, include of dmesg, superblock,
>    bitmap and /proc/mdstat.
> main()
>    the core function of this script.
> 
> Improve functions:
> cleanup()
>    clear dmesg and remove the /vat/tmp/mdtest* files.
> mdadm()
>    clear superblock once creating or building arrays
>    every time, because it's always creating arrays
>    many times in a test case.
> check()
>    just tidy up with die(), didn't change code meanings.
> testdev()
>    add checking $1 must be a block device, add 'return 0'
>    in final because this function exists in last line of
>    test case, such as tests/05r6tor0.
> do_test()
>    add checking abnormal dmesg and changing log management.
> do_help()
>    just recommend a better way to print Usage.
> parse_args()
>    revamp and improve.
> 
> Delete function:
> fast_sync()
>    It's no longer used, so get rid of it.
> 
> Signed-off-by: Zhilong Liu <zlliu@suse.com>

Applied!

I fixed the s/vat/var/ issue.

Thanks,
Jes



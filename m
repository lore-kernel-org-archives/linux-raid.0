From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [PATCH 2/3 v1] mdadm/test: Refactor the codes of 'test' script
Date: Fri, 9 Jun 2017 11:05:35 -0400
Message-ID: <a9a775d0-8c42-35a1-17cc-0ab17aaeccab@gmail.com>
References: <1496827888-17118-3-git-send-email-zlliu@suse.com>
 <1496913628-22779-1-git-send-email-zlliu@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1496913628-22779-1-git-send-email-zlliu@suse.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Zhilong Liu <zlliu@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 06/08/2017 05:20 AM, Zhilong Liu wrote:
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
>    just tidy up.
> 
> Signed-off-by: Zhilong Liu <zlliu@suse.com>
> ---
>   test | 346 +++++++++++++++++++++++++++++++++++++------------------------------
>   1 file changed, 191 insertions(+), 155 deletions(-)

Zhilong,

When sending out a v2 please add a small comment below the --- 
explaining what you changed.

Cheers,
Jes


PS: I note you start with v1 for updates, but v1 is really the first 
version - not a big deal.

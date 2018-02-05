From: Zhilong Liu <zlliu@suse.com>
Subject: Re: [PATCH v3] Since changing number of devices in RAID10 is possible
 fix man and add a test
Date: Mon, 5 Feb 2018 14:45:45 +0800
Message-ID: <502e2189-0804-a9d2-dac3-14adb142f6d4@suse.com>
References: <20180204213409.4872-1-a3at.mail@gmail.com>
 <20180204215012.14745-1-a3at.mail@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20180204215012.14745-1-a3at.mail@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Azat Khuzhin <a3at.mail@gmail.com>, linux-raid@vger.kernel.org
Cc: NeilBrown <neilb@suse.com>
List-Id: linux-raid.ids



On 02/05/2018 05:50 AM, Azat Khuzhin wrote:
> It requires patch from, otherwise it fails anyway:
>    "mdadm/grow: adding a test to ensure resize was required"
>    https://www.spinics.net/lists/raid/msg59743.html
>
> Since: 19ceb16dafb7df98ff90298008d4488dc93b370a ("Grow: add raid10
> reshape.") # mdadm mdadm-3.2.5-120-g19ceb16
> Since: 3ea7daa5d7fde47cd41f4d56c2deb949114da9d6 ("md/raid10: add reshape
> support")  # linux v3.4-rc5-15-g3ea7daa5d7fd
> Tested-on: linux 4.4
>
> v2: update man about layouts and add more test cases (with reducing
>      number of devices) as suggested by NeilBrown
>
> Signed-off-by: Azat Khuzhin <a3at.mail@gmail.com>
> Cc: NeilBrown <neilb@suse.com>
> Cc: Zhilong Liu <zlliu@suse.com>
> Link: https://www.spinics.net/lists/raid/msg60522.html
> ---
> Please ignore v2 patch, since it has bug with --remove in test case, and
> sorry for the noise. Thanks, Azat.

Hi,
Thanks for catching this, appreciate your test case. I'm adding comment 
below.

>
>   mdadm.8.in         |  3 ++-
>   tests/02r10reshape | 63 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>   2 files changed, 65 insertions(+), 1 deletion(-)
>   create mode 100644 tests/02r10reshape
>
> diff --git a/mdadm.8.in b/mdadm.8.in
> index f0fd1fc..0a1907c 100644
> --- a/mdadm.8.in
> +++ b/mdadm.8.in
> @@ -123,7 +123,8 @@ missing, spare, or failed drives, so there is nothing to monitor.
>   Grow (or shrink) an array, or otherwise reshape it in some way.
>   Currently supported growth options including changing the active size
>   of component devices and changing the number of active devices in
> -Linear and RAID levels 0/1/4/5/6,
> +Linear and RAID levels 0/1/4/5/6 and 10 (but only with 'offset' or 'near'
> +layout),
>   changing the RAID level between 0, 1, 5, and 6, and between 0 and 10,
>   changing the chunk size and layout for RAID 0,4,5,6,10 as well as adding or
>   removing a write-intent bitmap and changing the array's consistency policy.
> diff --git a/tests/02r10reshape b/tests/02r10reshape
> new file mode 100644
> index 0000000..a8b2e47
> --- /dev/null
> +++ b/tests/02r10reshape
> @@ -0,0 +1,63 @@
> +
> +# create a 4-disk raid10 array, make it 8-disk array and than shrink it back
> +#
> +# This SHOULD fail:
> +# - before mdadm 3.3 and linux 3.5
> +# - with metadata v0.90
> +#
> +# This also fails:
> +# - with metadata 1.0 with "mdadm: Insufficient head-space for reshape on /dev/loop1" error

 From my opinion, I'd recommend to cover bitmap situations. Refer to the 
commit in md:
e8a27f836f16 (md/bitmap: disable bitmap_resize for file-backed bitmaps.)
This test case covers 'none' bitmap mode, and it still has 'internal', 
'external' and 'clustered'
bitmap mode. For grow_add_device scenario, it isn't supported by 
external and clustered
bitmap mode(for clustered mode, I have mentioned in the cluster-md test 
suite). Thus here
add a comment:

+ This also fails by external bitmap mode.

And in test case, I would suggest to cover testing 'internal' bitmap at 
least.

Thanks,
-Zhilong

> +
> +function get_component_size() { cat /sys/block/$1/md/component_size; }
> +
> +function raid10_reshape()
> +{
> +    local layout=$1 metadata=$2
> +    shift 2
> +
> +    local m=2 cm=1
> +
> +    echo "Checking layout=$layout/metadata=$metadata"
> +
> +    # 4 disks
> +    mdadm -CR $md0 --metadata $metadata --level raid10 --layout $layout --raid-disks 4 $dev1 $dev2 $dev3 $dev4
> +    check wait
> +    check state UUUU
> +    check raid10
> +    testdev $md0 $m $mdsize1 $[512*cm]
> +
> +    # growing array to 8 disks
> +    mdadm $md0 --add $dev8 $dev9 $dev10 $dev11
> +    mdadm $md0 --grow --raid-devices 8
> +    check wait
> +    check state UUUUUUUU
> +    check raid10
> +    testdev $md0 $m $[mdsize1*2] $[512*cm]
> +
> +    # reducing array to 4 disks again
> +    dsize=$(get_component_size md0)
> +    mdadm $md0 --grow --array-size $[dsize*2]
> +    mdadm $md0 --grow --raid-devices 4
> +    check wait
> +    mdadm $md0 --remove $dev8 $dev9 $dev10 $dev11
> +    check state UUUU
> +    check raid10
> +    testdev $md0 $m $mdsize1 $[512*cm]
> +}
> +
> +function run_test()
> +{
> +    "$@"
> +    mdadm -S $md0
> +}
> +function main()
> +{
> +    local layout metadata
> +
> +    for layout in n2 o2; do
> +        for metadata in 1.1 1.2; do
> +            run_test raid10_reshape $layout $metadata
> +        done
> +    done
> +}
> +main "$@"


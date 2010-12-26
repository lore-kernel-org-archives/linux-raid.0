From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] Enable tests for OLCE, takeover, migrations for imsm
 metadata
Date: Sun, 26 Dec 2010 21:56:50 +1100
Message-ID: <20101226215650.7bc2eef7@notabene.brown>
References: <20101223144344.12291.43809.stgit@gklab-170-111.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101223144344.12291.43809.stgit@gklab-170-111.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

On Thu, 23 Dec 2010 15:43:44 +0100 Krzysztof Wojcik
<krzysztof.wojcik@intel.com> wrote:

> Patch provides set of tests for On-line Capacity Expansion,
> takeover, migrations operations for imsm metadata type.
> Tests are grouped by operation type:
> 12 - On-line Capacity Expansion on one volume
> 13 - On-line Capacity Expansion on two volumes
> 14 - Negative tests for takeover, migrations
> 15 - Chunk size migrations
> 16 - raid0 -> raid5, raid5 -> raid0 migrations
> 18 - takeover operations
> To run particular test group, following command should be executed:
> (from mdadm's source code root directory)
> ./test <group number>
> Example:
> To run On-line Capacity Expansion on one volume tests:
> ./test 12
> Tests execution results:
> - In case of test pass, "succeeded" word is printed on console
> - If test is failed, "FAILED" word is printed on console

Thanks  I've applied all the tests and some of the changes to 'test', but not
this one:

> and logs are stored in <mdadm-root-dir>/tests/log/ directory

I'm not sure I like it - and it should be a separate patch anyway (but then
there really should have been a few separate patches here...)

Maybe doing something like that is OK with an arg is given or an environment
variable is set, but I don't want to create all these log files by default.

Also, I'm begining to hate all this 'env-*' stuff.  Can someone remind me
why this was a good idea?

All the symlinks definitely are ugly and bad.  If each test script just
started with

   source env-whatever

when they wouldn't be necessary, would they ????

Thanks,

NeilBrown


> 
> Signed-off-by: Artur Wojcik <artur.wojcik@intel.com>
> Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
> ---
>  test                                               |   61 +++++++-----
>  tests/12imsm-r0_2d-grow-r0_3d                      |   18 +++
>  tests/12imsm-r0_2d-grow-r0_4d                      |   18 +++
>  tests/12imsm-r0_2d-grow-r0_5d                      |   18 +++
>  tests/12imsm-r0_3d-grow-r0_4d                      |   18 +++
>  tests/12imsm-r5_3d-grow-r5_4d                      |   18 +++
>  tests/12imsm-r5_3d-grow-r5_5d                      |   18 +++
>  tests/13imsm-r0_r0_2d-grow-r0_r0_4d                |   27 +++++
>  tests/13imsm-r0_r0_2d-grow-r0_r0_5d                |   27 +++++
>  tests/13imsm-r0_r0_3d-grow-r0_r0_4d                |   27 +++++
>  tests/13imsm-r0_r5_3d-grow-r0_r5_4d                |   27 +++++
>  tests/13imsm-r0_r5_3d-grow-r0_r5_5d                |   27 +++++
>  tests/13imsm-r5_r0_3d-grow-r5_r0_4d                |   27 +++++
>  tests/13imsm-r5_r0_3d-grow-r5_r0_5d                |   27 +++++
>  tests/14imsm-r0_3d-r5_3d-migrate-r5_4d-r5_4d       |   27 +++++
>  tests/14imsm-r0_3d_no_spares-migrate-r5_3d         |   19 ++++
>  tests/14imsm-r0_r0_2d-takeover-r10_4d              |   29 ++++++
>  tests/14imsm-r10_4d-grow-r10_5d                    |   18 +++
>  tests/14imsm-r10_r5_4d-takeover-r0_2d              |   28 +++++
>  tests/14imsm-r1_2d-grow-r1_3d                      |   18 +++
>  tests/14imsm-r1_2d-takeover-r0_2d                  |   20 ++++
>  tests/14imsm-r5_3d-grow-r5_5d-no-spares            |   18 +++
>  tests/14imsm-r5_3d-migrate-r4_3d                   |   19 ++++
>  tests/15imsm-r0_3d_64k-migrate-r0_3d_256k          |   22 ++++
>  tests/15imsm-r5_3d_4k-migrate-r5_3d_256k           |   19 ++++
>  tests/15imsm-r5_3d_64k-migrate-r5_3d_256k          |   19 ++++
>  tests/15imsm-r5_6d_4k-migrate-r5_6d_256k           |   19 ++++
>  tests/15imsm-r5_r0_3d_64k-migrate-r5_r0_3d_256k    |   32 ++++++
>  tests/16imsm-r0_3d-migrate-r5_4d                   |   19 ++++
>  tests/16imsm-r0_5d-migrate-r5_6d                   |   19 ++++
>  tests/16imsm-r5_3d-migrate-r0_3d                   |   19 ++++
>  tests/16imsm-r5_5d-migrate-r0_5d                   |   19 ++++
>  tests/18imsm-1d-takeover-r0_1d                     |   21 ++++
>  tests/18imsm-1d-takeover-r1_2d                     |   19 ++++
>  tests/18imsm-r0_2d-takeover-r10_4d                 |   19 ++++
>  tests/18imsm-r10_4d-takeover-r0_2d                 |   20 ++++
>  tests/env-12imsm-r0_2d-grow-r0_3d                  |    1 
>  tests/env-12imsm-r0_2d-grow-r0_4d                  |    1 
>  tests/env-12imsm-r0_2d-grow-r0_5d                  |    1 
>  tests/env-12imsm-r0_3d-grow-r0_4d                  |    1 
>  tests/env-12imsm-r5_3d-grow-r5_4d                  |    1 
>  tests/env-12imsm-r5_3d-grow-r5_5d                  |    1 
>  tests/env-13imsm-r0_r0_2d-grow-r0_r0_4d            |    1 
>  tests/env-13imsm-r0_r0_2d-grow-r0_r0_5d            |    1 
>  tests/env-13imsm-r0_r0_3d-grow-r0_r0_4d            |    1 
>  tests/env-13imsm-r0_r5_3d-grow-r0_r5_4d            |    1 
>  tests/env-13imsm-r0_r5_3d-grow-r0_r5_5d            |    1 
>  tests/env-13imsm-r5_r0_3d-grow-r5_r0_4d            |    1 
>  tests/env-13imsm-r5_r0_3d-grow-r5_r0_5d            |    1 
>  tests/env-14imsm-r0_3d-r5_3d-migrate-r5_4d-r5_4d   |    1 
>  tests/env-14imsm-r0_3d_no_spares-migrate-r5_3d     |    1 
>  tests/env-14imsm-r0_r0_2d-takeover-r10_4d          |    1 
>  tests/env-14imsm-r10_4d-grow-r10_5d                |    1 
>  tests/env-14imsm-r10_r5_4d-takeover-r0_2d          |    1 
>  tests/env-14imsm-r1_2d-grow-r1_3d                  |    1 
>  tests/env-14imsm-r1_2d-takeover-r0_2d              |    1 
>  tests/env-14imsm-r5_3d-grow-r5_4d-no-spares        |    1 
>  tests/env-14imsm-r5_3d-grow-r5_5d-no-spares        |    1 
>  tests/env-14imsm-r5_3d-migrate-r4_3d               |    1 
>  tests/env-15imsm-r0_3d_64k-migrate-r0_3d_256k      |    1 
>  tests/env-15imsm-r5_3d_4k-migrate-r5_3d_256k       |    1 
>  tests/env-15imsm-r5_3d_64k-migrate-r5_3d_256k      |    1 
>  tests/env-15imsm-r5_6d_4k-migrate-r5_6d_256k       |    1 
>  .../env-15imsm-r5_r0_3d_64k-migrate-r5_r0_3d_128k  |    1 
>  .../env-15imsm-r5_r0_3d_64k-migrate-r5_r0_3d_256k  |    1 
>  tests/env-16imsm-r0_3d-migrate-r5_4d               |    1 
>  tests/env-16imsm-r0_5d-migrate-r5_6d               |    1 
>  tests/env-16imsm-r5_3d-migrate-r0_3d               |    1 
>  tests/env-16imsm-r5_5d-migrate-r0_5d               |    1 
>  tests/env-17imsm-r5_3d-migrate-r4_3d               |    1 
>  tests/env-18imsm-1d-takeover-r0_1d                 |    1 
>  tests/env-18imsm-1d-takeover-r1_2d                 |    1 
>  tests/env-18imsm-r0_2d-takeover-r10_4d             |    1 
>  tests/env-18imsm-r10_4d-takeover-r0_2d             |    1 
>  tests/env-18imsm-r1_2d-takeover-r0_2d              |    1 
>  tests/env-imsm-template                            |   85 ++++++++++++++++
>  tests/imsm-grow-template                           |  104 ++++++++++++++++++++
>  77 files changed, 1024 insertions(+), 24 deletions(-)
>  mode change 100644 => 100755 test
>  create mode 100644 tests/12imsm-r0_2d-grow-r0_3d
>  create mode 100644 tests/12imsm-r0_2d-grow-r0_4d
>  create mode 100644 tests/12imsm-r0_2d-grow-r0_5d
>  create mode 100644 tests/12imsm-r0_3d-grow-r0_4d
>  create mode 100644 tests/12imsm-r5_3d-grow-r5_4d
>  create mode 100644 tests/12imsm-r5_3d-grow-r5_5d
>  create mode 100644 tests/13imsm-r0_r0_2d-grow-r0_r0_4d
>  create mode 100644 tests/13imsm-r0_r0_2d-grow-r0_r0_5d
>  create mode 100644 tests/13imsm-r0_r0_3d-grow-r0_r0_4d
>  create mode 100644 tests/13imsm-r0_r5_3d-grow-r0_r5_4d
>  create mode 100644 tests/13imsm-r0_r5_3d-grow-r0_r5_5d
>  create mode 100644 tests/13imsm-r5_r0_3d-grow-r5_r0_4d
>  create mode 100644 tests/13imsm-r5_r0_3d-grow-r5_r0_5d
>  create mode 100644 tests/14imsm-r0_3d-r5_3d-migrate-r5_4d-r5_4d
>  create mode 100644 tests/14imsm-r0_3d_no_spares-migrate-r5_3d
>  create mode 100644 tests/14imsm-r0_r0_2d-takeover-r10_4d
>  create mode 100644 tests/14imsm-r10_4d-grow-r10_5d
>  create mode 100644 tests/14imsm-r10_r5_4d-takeover-r0_2d
>  create mode 100644 tests/14imsm-r1_2d-grow-r1_3d
>  create mode 100644 tests/14imsm-r1_2d-takeover-r0_2d
>  create mode 100644 tests/14imsm-r5_3d-grow-r5_5d-no-spares
>  create mode 100644 tests/14imsm-r5_3d-migrate-r4_3d
>  create mode 100644 tests/15imsm-r0_3d_64k-migrate-r0_3d_256k
>  create mode 100644 tests/15imsm-r5_3d_4k-migrate-r5_3d_256k
>  create mode 100644 tests/15imsm-r5_3d_64k-migrate-r5_3d_256k
>  create mode 100644 tests/15imsm-r5_6d_4k-migrate-r5_6d_256k
>  create mode 100644 tests/15imsm-r5_r0_3d_64k-migrate-r5_r0_3d_256k
>  create mode 100644 tests/16imsm-r0_3d-migrate-r5_4d
>  create mode 100644 tests/16imsm-r0_5d-migrate-r5_6d
>  create mode 100644 tests/16imsm-r5_3d-migrate-r0_3d
>  create mode 100644 tests/16imsm-r5_5d-migrate-r0_5d
>  create mode 100644 tests/18imsm-1d-takeover-r0_1d
>  create mode 100644 tests/18imsm-1d-takeover-r1_2d
>  create mode 100644 tests/18imsm-r0_2d-takeover-r10_4d
>  create mode 100644 tests/18imsm-r10_4d-takeover-r0_2d
>  create mode 120000 tests/env-12imsm-r0_2d-grow-r0_3d
>  create mode 120000 tests/env-12imsm-r0_2d-grow-r0_4d
>  create mode 120000 tests/env-12imsm-r0_2d-grow-r0_5d
>  create mode 120000 tests/env-12imsm-r0_3d-grow-r0_4d
>  create mode 120000 tests/env-12imsm-r5_3d-grow-r5_4d
>  create mode 120000 tests/env-12imsm-r5_3d-grow-r5_5d
>  create mode 120000 tests/env-13imsm-r0_r0_2d-grow-r0_r0_4d
>  create mode 120000 tests/env-13imsm-r0_r0_2d-grow-r0_r0_5d
>  create mode 120000 tests/env-13imsm-r0_r0_3d-grow-r0_r0_4d
>  create mode 120000 tests/env-13imsm-r0_r5_3d-grow-r0_r5_4d
>  create mode 120000 tests/env-13imsm-r0_r5_3d-grow-r0_r5_5d
>  create mode 120000 tests/env-13imsm-r5_r0_3d-grow-r5_r0_4d
>  create mode 120000 tests/env-13imsm-r5_r0_3d-grow-r5_r0_5d
>  create mode 120000 tests/env-14imsm-r0_3d-r5_3d-migrate-r5_4d-r5_4d
>  create mode 120000 tests/env-14imsm-r0_3d_no_spares-migrate-r5_3d
>  create mode 120000 tests/env-14imsm-r0_r0_2d-takeover-r10_4d
>  create mode 120000 tests/env-14imsm-r10_4d-grow-r10_5d
>  create mode 120000 tests/env-14imsm-r10_r5_4d-takeover-r0_2d
>  create mode 120000 tests/env-14imsm-r1_2d-grow-r1_3d
>  create mode 120000 tests/env-14imsm-r1_2d-takeover-r0_2d
>  create mode 120000 tests/env-14imsm-r5_3d-grow-r5_4d-no-spares
>  create mode 120000 tests/env-14imsm-r5_3d-grow-r5_5d-no-spares
>  create mode 120000 tests/env-14imsm-r5_3d-migrate-r4_3d
>  create mode 120000 tests/env-15imsm-r0_3d_64k-migrate-r0_3d_256k
>  create mode 120000 tests/env-15imsm-r5_3d_4k-migrate-r5_3d_256k
>  create mode 120000 tests/env-15imsm-r5_3d_64k-migrate-r5_3d_256k
>  create mode 120000 tests/env-15imsm-r5_6d_4k-migrate-r5_6d_256k
>  create mode 120000 tests/env-15imsm-r5_r0_3d_64k-migrate-r5_r0_3d_128k
>  create mode 120000 tests/env-15imsm-r5_r0_3d_64k-migrate-r5_r0_3d_256k
>  create mode 120000 tests/env-16imsm-r0_3d-migrate-r5_4d
>  create mode 120000 tests/env-16imsm-r0_5d-migrate-r5_6d
>  create mode 120000 tests/env-16imsm-r5_3d-migrate-r0_3d
>  create mode 120000 tests/env-16imsm-r5_5d-migrate-r0_5d
>  create mode 120000 tests/env-17imsm-r5_3d-migrate-r4_3d
>  create mode 120000 tests/env-18imsm-1d-takeover-r0_1d
>  create mode 120000 tests/env-18imsm-1d-takeover-r1_2d
>  create mode 120000 tests/env-18imsm-r0_2d-takeover-r10_4d
>  create mode 120000 tests/env-18imsm-r10_4d-takeover-r0_2d
>  create mode 120000 tests/env-18imsm-r1_2d-takeover-r0_2d
>  create mode 100644 tests/env-imsm-template
>  create mode 100644 tests/imsm-grow-template
> 
> diff --git a/test b/test
> old mode 100644
> new mode 100755
> index d1b4582..8d74252
> --- a/test
> +++ b/test
> @@ -49,13 +49,13 @@ mdsize12=19988
>  ddfsize=65536
>  
>  cleanup() {
> -	udevadm settle
> -	$mdadm -Ssq
> -	for d in 0 1 2 3 4 5 6 7  8 9 10 11 12
> -	do
> -	    losetup -d /dev/loop$d ; # rm -f $targetdir/mdtest$d
> -	    rm -f /dev/disk/by-path/loop*
> -        done
> +    udevadm settle
> +    $mdadm -Ssq 2> /dev/null
> +    for d in 0 1 2 3 4 5 6 7  8 9 10 11 12
> +    do
> +        losetup -d /dev/loop$d ; # rm -f $targetdir/mdtest$d
> +        rm -f /dev/disk/by-path/loop*
> +    done
>  }
>  
>  trap cleanup 0 1 2 3 15
> @@ -117,45 +117,45 @@ check() {
>        ;;
>      raid* | linear )
>        grep -s "active $1 " /proc/mdstat > /dev/null || {
> -   		echo >&2 "ERROR active $1 not found" ; cat /proc/mdstat ; exit 1;}
> + 	echo >&2 "ERROR active $1 not found" ; cat /proc/mdstat ; exit 1;}
>       ;;
>      resync | recovery | reshape)
>        sleep 0.5
>        grep -s $1 /proc/mdstat > /dev/null || {
> -   		echo >&2 ERROR no $1 happening; cat /proc/mdstat; exit 1; }
> +      echo >&2 ERROR no $1 happening; cat /proc/mdstat; exit 1; }
>       ;;
> -   
> +
>       nosync )
>         sleep 0.5
>         if grep -s -E '(resync|recovery|reshape) =' > /dev/null /proc/mdstat ; then
> -   	   echo >&2 "ERROR resync or recovery is happening!"; cat /proc/mdstat ; exit 1; 
> +		echo >&2 "ERROR resync or recovery is happening!"; cat /proc/mdstat ; exit 1;
>         fi
>       ;;
> -   
> +
>      wait )
>        sleep 0.1
>        while grep -E '(resync|recovery|reshape|check|repair) =' > /dev/null /proc/mdstat
>        do sleep 2;
>        done
>        ;;
> -   
> +
>      state )
>         grep -s "blocks.*\[$2\]\$" /proc/mdstat > /dev/null || {
> -   		echo >&2 "ERROR state $2 not found!"; cat /proc/mdstat ; exit 1; }
> +       echo >&2 "ERROR state $2 not found!"; cat /proc/mdstat ; exit 1; }
>         sleep 0.5
>        ;;
>  
>      bitmap )
>         grep -s bitmap > /dev/null /proc/mdstat || {
> -	   echo >&2 ERROR no bitmap ; cat /proc/mdstat ; exit 1; }
> +       echo >&2 ERROR no bitmap ; cat /proc/mdstat ; exit 1; }
>        ;;
>      nobitmap )
> -       if grep -s "bitmap" > /dev/null /proc/mdstat 
> +       if grep -s "bitmap" > /dev/null /proc/mdstat
>         then
> -	   echo >&2 ERROR bitmap present ; cat /proc/mdstat ; exit 1;
> +		echo >&2 ERROR bitmap present ; cat /proc/mdstat ; exit 1;
>         fi
>        ;;
> -   
> +
>      * ) echo >&2 ERROR unknown check $1 ; exit 1;
>     esac
>  }
> @@ -212,25 +212,38 @@ reset_environment() {
>     fi
>  }
>  
> +# Create directory for logs and stderr based on current timestamp
> +start_date=`date +%Y-%m-%d`
> +start_time=`date +%H-%M-%S`
> +
>  for script in tests/$prefix tests/$prefix*[^~]
>  do
>    if [ -f "$script" ]
>    then
>     rm -f $targetdir/stderr
>     # stop all arrays, just incase some script left an array active.
> -   mdadm -Ssq
> +   $mdadm -Ssq 2> /dev/null
>     mdadm --zero $devlist 2> /dev/null
>     mdadm --zero $devlist 2> /dev/null
>     environment="tests/env-`basename $script`"
>     setup_environment $environment
>     # source script in a subshell, so it has access to our
>     # namespace, but cannot change it.
> +   echo -ne "$script... "
>     if ( set -ex ; . $script )  2> $targetdir/log
> -   then echo "$script succeeded" 
> -   else cat $targetdir/log ; cat $targetdir/stderr
> -        echo "$script failed"
> -	reset_environment $environment
> -       exit 1
> +   then echo "succeeded"
> +   else echo "FAILED"
> +        short_path="by-date/$start_date/$start_time/`basename $script`"
> +        log_path="tests/log/$short_path"
> +        alternate_log_path="tests/log/by-case/`basename $script`"
> +        timestamp=`date +%N`
> +        mkdir -p $log_path $alternate_log_path
> +        mv $targetdir/log $log_path/$timestamp.log
> +        ln -s ../../$short_path/$timestamp.log $alternate_log_path/$start_date\_$start_time\_$timestamp.log
> +        mv $targetdir/stderr $log_path/$timestamp.stderr
> +        ln -s ../../$short_path/$timestamp.stderr $alternate_log_path/$start_date\_$start_time\_$timestamp.stderr
> +        cat /proc/mdstat > $log_path/$timestamp.mdstat
> +        ln -s ../../$short_path/$timestamp.mdstat $alternate_log_path/$start_date\_$start_time\_$timestamp.mdstat
>     fi
>     reset_environment $environment
>    fi
> diff --git a/tests/12imsm-r0_2d-grow-r0_3d b/tests/12imsm-r0_2d-grow-r0_3d
> new file mode 100644
> index 0000000..7f3d38f
> --- /dev/null
> +++ b/tests/12imsm-r0_2d-grow-r0_3d
> @@ -0,0 +1,18 @@
> +# RAID 0 volume, 2 disks grow to RAID 0 volume, 3 disks
> +# POSITIVE test
> +
> +num_disks=2
> +device_list="$dev0 $dev1"
> +spare_list="$dev2"
> +
> +# Before: RAID 0 volume, 2 disks, 64k chunk size
> +vol0_level=0
> +vol0_comp_size=$((5 * 1024))
> +vol0_chunk=64
> +vol0_num_comps=$num_disks
> +vol0_offset=0
> +
> +# After: RAID 0 volume, 3 disks, 64k chunk size
> +vol0_new_num_comps=$((num_disks + 1))
> +
> +. tests/imsm-grow-template 0 0
> diff --git a/tests/12imsm-r0_2d-grow-r0_4d b/tests/12imsm-r0_2d-grow-r0_4d
> new file mode 100644
> index 0000000..de76920
> --- /dev/null
> +++ b/tests/12imsm-r0_2d-grow-r0_4d
> @@ -0,0 +1,18 @@
> +# RAID 0 volume, 2 disks grow to RAID 0 volume, 4 disks
> +# POSITIVE test
> +
> +num_disks=2
> +device_list="$dev0 $dev1"
> +spare_list="$dev2 $dev3"
> +
> +# Before: RAID 0 volume, 2 disks, 64k chunk size
> +vol0_level=0
> +vol0_comp_size=$((5 * 1024))
> +vol0_chunk=64
> +vol0_num_comps=$num_disks
> +vol0_offset=0
> +
> +# After: RAID 0 volume, 4 disks, 64k chunk size
> +vol0_new_num_comps=$((num_disks + 2))
> +
> +. tests/imsm-grow-template 0 0
> diff --git a/tests/12imsm-r0_2d-grow-r0_5d b/tests/12imsm-r0_2d-grow-r0_5d
> new file mode 100644
> index 0000000..ffa4cc1
> --- /dev/null
> +++ b/tests/12imsm-r0_2d-grow-r0_5d
> @@ -0,0 +1,18 @@
> +# RAID 0 volume, 2 disks grow to RAID 0 volume, 5 disks
> +# POSITIVE test
> +
> +num_disks=2
> +device_list="$dev0 $dev1"
> +spare_list="$dev2 $dev3 $dev4"
> +
> +# Before: RAID 0 volume, 2 disks, 64k chunk size
> +vol0_level=0
> +vol0_comp_size=$((5 * 1024))
> +vol0_chunk=64
> +vol0_num_comps=$num_disks
> +vol0_offset=0
> +
> +# After: RAID 0 volume, 5 disks, 64k chunk size
> +vol0_new_num_comps=$((num_disks + 3))
> +
> +. tests/imsm-grow-template 0 0
> diff --git a/tests/12imsm-r0_3d-grow-r0_4d b/tests/12imsm-r0_3d-grow-r0_4d
> new file mode 100644
> index 0000000..d1fa584
> --- /dev/null
> +++ b/tests/12imsm-r0_3d-grow-r0_4d
> @@ -0,0 +1,18 @@
> +# RAID 0 volume, 3 disks grow to RAID 0 volume, 4 disks
> +# POSITIVE test
> +
> +num_disks=3
> +device_list="$dev0 $dev1 $dev2"
> +spare_list="$dev3"
> +
> +# Before: RAID 0 volume, 3 disks, 64k chunk size
> +vol0_level=0
> +vol0_comp_size=$((5 * 1024))
> +vol0_chunk=64
> +vol0_num_comps=$num_disks
> +vol0_offset=0
> +
> +# After: RAID 0 volume, 4 disks, 64k chunk size
> +vol0_new_num_comps=$((num_disks + 1))
> +
> +. tests/imsm-grow-template 0 0
> diff --git a/tests/12imsm-r5_3d-grow-r5_4d b/tests/12imsm-r5_3d-grow-r5_4d
> new file mode 100644
> index 0000000..a87ef8c
> --- /dev/null
> +++ b/tests/12imsm-r5_3d-grow-r5_4d
> @@ -0,0 +1,18 @@
> +# RAID 5 volume, 3 disks grow to RAID 5 volume, 4 disks
> +# POSITIVE test
> +
> +num_disks=3
> +device_list="$dev0 $dev1 $dev2"
> +spare_list="$dev3"
> +
> +# Before: RAID 5 volume, 3 disks, 64k chunk size
> +vol0_level=5
> +vol0_comp_size=$((5 * 1024))
> +vol0_chunk=64
> +vol0_num_comps=$((num_disks - 1))
> +vol0_offset=0
> +
> +# After: RAID 5 volume, 4 disks, 64k chunk size
> +vol0_new_num_comps=$num_disks
> +
> +. tests/imsm-grow-template 0 0
> diff --git a/tests/12imsm-r5_3d-grow-r5_5d b/tests/12imsm-r5_3d-grow-r5_5d
> new file mode 100644
> index 0000000..2fa3711
> --- /dev/null
> +++ b/tests/12imsm-r5_3d-grow-r5_5d
> @@ -0,0 +1,18 @@
> +# RAID 5 volume, 3 disks grow to RAID 5 volume, 5 disks
> +# POSITIVE test
> +
> +num_disks=3
> +device_list="$dev0 $dev1 $dev2"
> +spare_list="$dev3 $dev4"
> +
> +# Before: RAID 5 volume, 3 disks, 64k chunk size
> +vol0_level=5
> +vol0_comp_size=$((5 * 1024))
> +vol0_chunk=64
> +vol0_num_comps=$((num_disks - 1))
> +vol0_offset=0
> +
> +# After: RAID 5 volume, 5 disks, 64k chunk size
> +vol0_new_num_comps=$((num_disks + 1))
> +
> +. tests/imsm-grow-template 0 0
> diff --git a/tests/13imsm-r0_r0_2d-grow-r0_r0_4d b/tests/13imsm-r0_r0_2d-grow-r0_r0_4d
> new file mode 100644
> index 0000000..9b6256b
> --- /dev/null
> +++ b/tests/13imsm-r0_r0_2d-grow-r0_r0_4d
> @@ -0,0 +1,27 @@
> +# Grow the container (arrays inside) from 2 disks to 4 disks
> +# POSITIVE test
> +
> +num_disks=2
> +device_list="$dev0 $dev1"
> +spare_list="$dev2 $dev3"
> +
> +# Before: RAID 0 volume in slot #0, 2 disks, 128k chunk size
> +#         RAID 0 volume in slot #1, 2 disks, 64k chunk size
> +vol0_level=0
> +vol0_comp_size=$((5 * 1024))
> +vol0_chunk=128
> +vol0_num_comps=$num_disks
> +vol0_offset=0
> +
> +vol1_level=0
> +vol1_comp_size=$((5 * 1024))
> +vol1_chunk=64
> +vol1_num_comps=$num_disks
> +vol1_offset=$((vol0_comp_size + 2048))
> +
> +# After: RAID 0 volume in slot #0, 4 disks, 128k chunk size
> +#        RAID 0 volume in slot #1, 4 disks, 64k chunk size
> +vol0_new_num_comps=$((num_disks + 2))
> +vol1_new_num_comps=$vol0_new_num_comps
> +
> +. tests/imsm-grow-template 0 0
> diff --git a/tests/13imsm-r0_r0_2d-grow-r0_r0_5d b/tests/13imsm-r0_r0_2d-grow-r0_r0_5d
> new file mode 100644
> index 0000000..05364f5
> --- /dev/null
> +++ b/tests/13imsm-r0_r0_2d-grow-r0_r0_5d
> @@ -0,0 +1,27 @@
> +# Grow both members from 2 disks to 5 disks
> +# POSITIVE test
> +
> +num_disks=2
> +device_list="$dev0 $dev1"
> +spare_list="$dev2 $dev3 $dev4"
> +
> +# Before: RAID 0 volume in slot #0, 2 disks, 64k chunk size
> +#         RAID 0 volume in slot #1, 2 disks, 256k chunk size
> +vol0_level=0
> +vol0_comp_size=$((5 * 1024))
> +vol0_chunk=64
> +vol0_num_comps=$num_disks
> +vol0_offset=0
> +
> +vol1_level=0
> +vol1_comp_size=$((5 * 1024))
> +vol1_chunk=256
> +vol1_num_comps=$num_disks
> +vol1_offset=$((vol0_comp_size + 2048))
> +
> +# After: RAID 0 volume in slot #0, 5 disks, 64k chunk size
> +#        RAID 0 volume in slot #1, 5 disks, 256k chunk size
> +vol0_new_num_comps=$((num_disks + 3))
> +vol1_new_num_comps=$vol0_new_num_comps
> +
> +. tests/imsm-grow-template 0 0
> diff --git a/tests/13imsm-r0_r0_3d-grow-r0_r0_4d b/tests/13imsm-r0_r0_3d-grow-r0_r0_4d
> new file mode 100644
> index 0000000..26b69f1
> --- /dev/null
> +++ b/tests/13imsm-r0_r0_3d-grow-r0_r0_4d
> @@ -0,0 +1,27 @@
> +# Grow a container (arrays inside) from 3 disks to 4 disks
> +# POSITIVE test
> +
> +num_disks=3
> +device_list="$dev0 $dev1 $dev2"
> +spare_list="$dev3"
> +
> +# Before: RAID 0 volume in slot #0, 3 disks, 128k chunk size
> +#         RAID 0 volume in slot #1, 3 disks, 512k chunk size
> +vol0_level=0
> +vol0_comp_size=$((5 * 1024))
> +vol0_chunk=128
> +vol0_num_comps=$num_disks
> +vol0_offset=0
> +
> +vol1_level=0
> +vol1_comp_size=$((5 * 1024))
> +vol1_chunk=512
> +vol1_num_comps=$num_disks
> +vol1_offset=$((vol0_comp_size + 2048))
> +
> +# After: RAID0 volume in slot #0, 4 disks, 128k chunk size
> +#        RAID0 volume in slot #1, 4 disks, 512k chunk size
> +vol0_new_num_comps=$((num_disks + 1))
> +vol1_new_num_comps=$vol0_new_num_comps
> +
> +. tests/imsm-grow-template 0 0
> diff --git a/tests/13imsm-r0_r5_3d-grow-r0_r5_4d b/tests/13imsm-r0_r5_3d-grow-r0_r5_4d
> new file mode 100644
> index 0000000..e2ce5d0
> --- /dev/null
> +++ b/tests/13imsm-r0_r5_3d-grow-r0_r5_4d
> @@ -0,0 +1,27 @@
> +# Grow the container (arrays inside) from 3 disks to 4 disks
> +# POSITIVE test
> +
> +num_disks=3
> +device_list="$dev0 $dev1 $dev2"
> +spare_list="$dev3"
> +
> +# Before: RAID 0 volume in slot #0, 3 disks, 64k chunk size
> +#         RAID 5 volume in slot #1, 3 disks, 128k chunk size
> +vol0_level=0
> +vol0_comp_size=$((5 * 1024))
> +vol0_chunk=64
> +vol0_num_comps=$num_disks
> +vol0_offset=0
> +
> +vol1_level=5
> +vol1_comp_size=$((5 * 1024))
> +vol1_chunk=128
> +vol1_num_comps=$((num_disks - 1))
> +vol1_offset=$((vol0_comp_size + 2048))
> +
> +# After: RAID 0 volume in slot #0, 4 disks, 64k chunk size
> +#        RAID 5 volume in slot #1, 4 disks, 128k chunk size
> +vol1_new_num_comps=$num_disks
> +vol0_new_num_comps=$((num_disks + 1))
> +
> +. tests/imsm-grow-template 0 0
> diff --git a/tests/13imsm-r0_r5_3d-grow-r0_r5_5d b/tests/13imsm-r0_r5_3d-grow-r0_r5_5d
> new file mode 100644
> index 0000000..47d3f37
> --- /dev/null
> +++ b/tests/13imsm-r0_r5_3d-grow-r0_r5_5d
> @@ -0,0 +1,27 @@
> +# Grow the container (arrays inside) from 3 disks to 5 disks
> +# POSITIVE test
> +
> +num_disks=3
> +device_list="$dev0 $dev1 $dev2"
> +spare_list="$dev3 $dev4"
> +
> +# Before: RAID 0 volume in slot #0, 3 disks, 256k chunk size
> +#         RAID 5 volume in slot #1, 3 disks, 512k chunk size
> +vol0_level=0
> +vol0_comp_size=$((5 * 1024))
> +vol0_chunk=256
> +vol0_num_comps=$num_disks
> +vol0_offset=0
> +
> +vol1_level=5
> +vol1_comp_size=$((5 * 1024))
> +vol1_chunk=512
> +vol1_num_comps=$((num_disks - 1))
> +vol1_offset=$((vol0_comp_size + 2048))
> +
> +# After: RAID 0 volume in slot #0, 5 disks, 256k chunk size
> +#        RAID 5 volume in slot #1, 5 disks, 512k chunk size
> +vol0_new_num_comps=$((num_disks + 2))
> +vol1_new_num_comps=$((num_disks + 1))
> +
> +. tests/imsm-grow-template 0 0
> diff --git a/tests/13imsm-r5_r0_3d-grow-r5_r0_4d b/tests/13imsm-r5_r0_3d-grow-r5_r0_4d
> new file mode 100644
> index 0000000..79115a3
> --- /dev/null
> +++ b/tests/13imsm-r5_r0_3d-grow-r5_r0_4d
> @@ -0,0 +1,27 @@
> +# Grow the container (arrays inside) from 3 disks to 4 disks
> +# POSITIVE test
> +
> +num_disks=3
> +device_list="$dev0 $dev1 $dev2"
> +spare_list="$dev3"
> +
> +# Before: RAID 5 volume in slot #0, 3 disks, 64k chunk size
> +#         RAID 0 volume in slot #1, 3 disks, 64k chunk size
> +vol0_level=5
> +vol0_comp_size=$((5 * 1024))
> +vol0_chunk=64
> +vol0_num_comps=$((num_disks - 1))
> +vol0_offset=0
> +
> +vol1_level=0
> +vol1_comp_size=$((5 * 1024))
> +vol1_chunk=64
> +vol1_offset=$((vol0_comp_size + 2048))
> +vol1_num_comps=$num_disks
> +
> +# After: RAID 5 volume in slot #0, 4 disks, 64k chunk size
> +#        RAID 0 volume in slot #1, 4 disks, 64k chunk size
> +vol0_new_num_comps=$num_disks
> +vol1_new_num_comps=$((num_disks + 1))
> +
> +. tests/imsm-grow-template 0 0
> diff --git a/tests/13imsm-r5_r0_3d-grow-r5_r0_5d b/tests/13imsm-r5_r0_3d-grow-r5_r0_5d
> new file mode 100644
> index 0000000..990c828
> --- /dev/null
> +++ b/tests/13imsm-r5_r0_3d-grow-r5_r0_5d
> @@ -0,0 +1,27 @@
> +# Grow the container (arrays inside) from 3 disks to 5 disks
> +# POSITIVE test
> +
> +num_disks=3
> +device_list="$dev0 $dev1 $dev2"
> +spare_list="$dev3 $dev4"
> +
> +# Before: RAID 5 volume in slot #0, 3 disks, 128k chunk size
> +#         RAID 0 volume in slot #1, 3 disks, 256k chunk size
> +vol0_level=5
> +vol0_comp_size=$((5 * 1024))
> +vol0_chunk=64
> +vol0_num_comps=$((num_disks - 1))
> +vol0_offset=0
> +
> +vol1_level=0
> +vol1_comp_size=$((5 * 1024))
> +vol1_chunk=64
> +vol1_offset=$((vol0_comp_size + 2048))
> +vol1_num_comps=$num_disks
> +
> +# After: RAID 5 volume in slot #0, 5 disks, 128k chunk size
> +#        RAID 0 volume in slot #1, 5 disks, 256k chunk size
> +vol0_new_num_comps=$((num_disks + 1))
> +vol1_new_num_comps=$((num_disks + 2))
> +
> +. tests/imsm-grow-template 0 0
> diff --git a/tests/14imsm-r0_3d-r5_3d-migrate-r5_4d-r5_4d b/tests/14imsm-r0_3d-r5_3d-migrate-r5_4d-r5_4d
> new file mode 100644
> index 0000000..378d343
> --- /dev/null
> +++ b/tests/14imsm-r0_3d-r5_3d-migrate-r5_4d-r5_4d
> @@ -0,0 +1,27 @@
> +# RAID 0 and RAID 5 volumes (3 disks) migrate to RAID 5 and RAID 5 volumes (4 disks)
> +# NEGATIVE test - migration is not allowed if there is more then one array in a container
> +
> +num_disks=3
> +device_list="$dev0 $dev1 $dev2"
> +spare_list="$dev3"
> +
> +# Before: RAID 0 volume, 3 disks, 64k chunk size, as member #0
> +vol0_level=0
> +vol0_comp_size=$((5 * 1024))
> +vol0_chunk=64
> +vol0_num_comps=$num_disks
> +vol0_offset=0
> +
> +# Extra: RAID 5 volume, 3 disks, 64k chunk size, as member #1
> +vol1_level=5
> +vol1_comp_size=$((5 * 1024))
> +vol1_chunk=64
> +vol1_num_comps=$((num_disks - 1))
> +vol1_offset=$((vol0_comp_size + 2048))
> +
> +# After: RAID 5 volume, 4 disks, 64k chunk size (only member #0)
> +vol0_new_level=5
> +vol0_new_num_comps=$num_disks
> +vol0_new_chunk=64
> +
> +. tests/imsm-grow-template 1 1
> diff --git a/tests/14imsm-r0_3d_no_spares-migrate-r5_3d b/tests/14imsm-r0_3d_no_spares-migrate-r5_3d
> new file mode 100644
> index 0000000..44b3f42
> --- /dev/null
> +++ b/tests/14imsm-r0_3d_no_spares-migrate-r5_3d
> @@ -0,0 +1,19 @@
> +# RAID 0 volume (3 disks, no spares) migrate to RAID 5 volume (3 disks)
> +# NEGATIVE test
> +
> +num_disks=3
> +device_list="$dev0 $dev1 $dev2"
> +
> +# Before: RAID 0 volume, 3 disks, 64k chunk size
> +vol0_level=0
> +vol0_comp_size=$((5 * 1024))
> +vol0_chunk=64
> +vol0_num_comps=$num_disks
> +vol0_offset=0
> +
> +# After: RAID 5, 3 disks, 64k chunk size
> +vol0_new_level=5
> +vol0_new_num_comps=$((num_disks - 1))
> +vol0_new_chunk=64
> +
> +. tests/imsm-grow-template 1
> diff --git a/tests/14imsm-r0_r0_2d-takeover-r10_4d b/tests/14imsm-r0_r0_2d-takeover-r10_4d
> new file mode 100644
> index 0000000..da1a892
> --- /dev/null
> +++ b/tests/14imsm-r0_r0_2d-takeover-r10_4d
> @@ -0,0 +1,29 @@
> +
> +# Two RAID 0 volumes (2 disks) migrate to RAID 10 volume (4 disks)
> +# NEGATIVE test
> +
> +num_disks=2
> +device_list="$dev0 $dev1"
> +
> +# Before: RAID 0 volume in slot #0, 2 disks, 64k chunk size
> +#         RAID 0 volume in slot #1, 2 disks, 64k chunk size
> +vol0_level=0
> +vol0_comp_size=$((5 * 1024))
> +vol0_chunk=64
> +vol0_num_comps=$num_disks
> +vol0_offset=0
> +
> +# Before: RAID 0 volume,  disks, 64k chunk size
> +vol1_level=0
> +vol1_comp_size=$((5 * 1024))
> +vol1_chunk=64
> +vol1_num_comps=num_disks
> +vol1_offset=$(( $vol0_comp_size + 2048 ))
> +
> +# After: RAID 10, 4 disks, 64k chunk size
> +vol0_new_level=10
> +vol0_new_num_comps=$((num_disks - 1))
> +vol0_new_chunk=64
> +
> +. tests/imsm-grow-template 1 1
> +
> diff --git a/tests/14imsm-r10_4d-grow-r10_5d b/tests/14imsm-r10_4d-grow-r10_5d
> new file mode 100644
> index 0000000..efffb9a
> --- /dev/null
> +++ b/tests/14imsm-r10_4d-grow-r10_5d
> @@ -0,0 +1,18 @@
> +# RAID 10 volume, 4 disks grow to RAID 10 volume, 5 disks
> +# NEGATIVE test
> +
> +num_disks=4
> +device_list="$dev0 $dev1 $dev2 $dev3"
> +spare_list="$dev4"
> +
> +# Before: RAID 10 volume, 4 disks, 128k chunk size
> +vol0_level=10
> +vol0_comp_size=$((5 * 1024))
> +vol0_chunk=128
> +vol0_num_comps=$((num_disks - 2))
> +vol0_offset=0
> +
> +# After: RAID 10 volume, 5 disks, 128k chunks size (test should fail)
> +vol0_new_num_comps=$((num_disks + 1))
> +
> +. tests/imsm-grow-template 1 0
> diff --git a/tests/14imsm-r10_r5_4d-takeover-r0_2d b/tests/14imsm-r10_r5_4d-takeover-r0_2d
> new file mode 100644
> index 0000000..b0a8331
> --- /dev/null
> +++ b/tests/14imsm-r10_r5_4d-takeover-r0_2d
> @@ -0,0 +1,28 @@
> +
> +# Two RAID volumes: RAID10 and RAID5 (4 disks) migrate to RAID 0 volume (2 disks)
> +# NEGATIVE test
> +
> +num_disks=4
> +device_list="$dev0 $dev1 $dev2 $dev3"
> +
> +# Before: RAID 10 volume in slot #0, 4 disks, 64k chunk size
> +#         RAID 5 volume in slot #1, 4 disks, 64k chunk size
> +vol0_level=10
> +vol0_comp_size=$((5 * 1024))
> +vol0_chunk=64
> +vol0_num_comps=$(( $num_disks - 2 ))
> +vol0_offset=0
> +
> +# Before: RAID 0 volume,  disks, 64k chunk size
> +vol1_level=5
> +vol1_comp_size=$((5 * 1024))
> +vol1_chunk=64
> +vol1_num_comps=$(( $num_disks - 1 ))
> +vol1_offset=$(( $vol0_comp_size + 2048 ))
> +
> +# After: RAID 10, 4 disks, 64k chunk size
> +vol0_new_level=0
> +vol0_new_num_comps=2
> +vol0_new_chunk=64
> +
> +. tests/imsm-grow-template 1 1
> diff --git a/tests/14imsm-r1_2d-grow-r1_3d b/tests/14imsm-r1_2d-grow-r1_3d
> new file mode 100644
> index 0000000..d0d51eb
> --- /dev/null
> +++ b/tests/14imsm-r1_2d-grow-r1_3d
> @@ -0,0 +1,18 @@
> +# RAID 1 volume, 2 disks grow to RAID 1 volume, 3 disks
> +# NEGATIVE test
> +
> +num_disks=2
> +device_list="$dev0 $dev1"
> +spare_list="$dev4"
> +
> +# Before: RAID 1 volume, 2 disks, 64k chunk size
> +vol0_level=1
> +vol0_comp_size=$((5 * 1024))
> +vol0_chunk=64
> +vol0_num_comps=$((num_disks - 1))
> +vol0_offset=0
> +
> +# After: RAID 1 volume, 3 disks, 64k chunks size (test should fail)
> +vol0_new_num_comps=$num_disks
> +
> +. tests/imsm-grow-template 1 0
> diff --git a/tests/14imsm-r1_2d-takeover-r0_2d b/tests/14imsm-r1_2d-takeover-r0_2d
> new file mode 100644
> index 0000000..7f57ebf
> --- /dev/null
> +++ b/tests/14imsm-r1_2d-takeover-r0_2d
> @@ -0,0 +1,20 @@
> +# RAID 1 volume, 2 disks change to RAID 0 volume, 2 disks
> +#
> +#NEGATIVE test
> +
> +num_disks=2
> +device_list="$dev0 $dev1"
> +
> +# Before: RAID 1 volume, 2 disks, 64k chunk size
> +vol0_level=1
> +vol0_comp_size=$((5 * 1024))
> +vol0_chunk=64
> +vol0_num_comps=$((num_disks - 1))
> +vol0_offset=0
> +
> +# After: RAID 0 volume, 2 disks, 64k chunk size
> +vol0_new_level=0
> +vol0_new_num_comps=$num_disks
> +vol0_new_chunk=64
> +
> +. tests/imsm-grow-template 1
> diff --git a/tests/14imsm-r5_3d-grow-r5_5d-no-spares b/tests/14imsm-r5_3d-grow-r5_5d-no-spares
> new file mode 100644
> index 0000000..ff3cd59
> --- /dev/null
> +++ b/tests/14imsm-r5_3d-grow-r5_5d-no-spares
> @@ -0,0 +1,18 @@
> +# RAID 5 volume, 3 disks grow to RAID 5 volume, 4 disks
> +# NEGATIVE test
> +
> +num_disks=3
> +device_list="$dev0 $dev1 $dev2"
> +
> +# Before: RAID 5 volume, 3 disks, 64k chunk size
> +vol0_level=5
> +vol0_comp_size=$((5 * 1024))
> +vol0_chunk=64
> +vol0_num_comps=$((num_disks - 1))
> +vol0_offset=0
> +
> +# After: RAID 5 volume, 4 disks, 64k chunks size
> +add_to_num_disks=2
> +vol0_new_num_comps=$((num_disks + 2))
> +
> +. tests/imsm-grow-template 1 0
> diff --git a/tests/14imsm-r5_3d-migrate-r4_3d b/tests/14imsm-r5_3d-migrate-r4_3d
> new file mode 100644
> index 0000000..506772e
> --- /dev/null
> +++ b/tests/14imsm-r5_3d-migrate-r4_3d
> @@ -0,0 +1,19 @@
> +# RAID 5 volume (3 disks) migrate to RAID 4 volume (3 disks)
> +# NEGATIVE test
> +
> +num_disks=3
> +device_list="$dev0 $dev1 $dev2"
> +
> +# Before: RAID 5 volume, 3 disks, 64k chunk size
> +vol0_level=5
> +vol0_comp_size=$((5 * 1024))
> +vol0_chunk=64
> +vol0_num_comps=$((num_disks - 1))
> +vol0_offset=0
> +
> +# After: RAID 4, 3 disks, 64k chunk size
> +vol0_new_level=4
> +vol0_new_num_comps=$((num_disks - 1))
> +vol0_new_chunk=64
> +
> +. tests/imsm-grow-template 1
> diff --git a/tests/15imsm-r0_3d_64k-migrate-r0_3d_256k b/tests/15imsm-r0_3d_64k-migrate-r0_3d_256k
> new file mode 100644
> index 0000000..03b19ff
> --- /dev/null
> +++ b/tests/15imsm-r0_3d_64k-migrate-r0_3d_256k
> @@ -0,0 +1,22 @@
> +# RAID 0 volume, Migration from 64k to 256k chunk size.
> +# POSITIVE test
> +
> +num_disks=2
> +device_list="$dev0 $dev1"
> +
> +# RAID 0, 2 disks, 64k chunk size
> +vol0_level=0
> +vol0_comp_size=$((5 * 1024))
> +vol0_chunk=64
> +vol0_num_comps=$num_disks
> +vol0_offset=0
> +
> +# RAID 0, 2 disks, 256k chunk size
> +vol0_new_level=0
> +vol0_new_num_comps=$vol0_num_comps
> +vol0_new_chunk=256
> +
> +
> +. tests/imsm-grow-template 0 1
> +
> +
> diff --git a/tests/15imsm-r5_3d_4k-migrate-r5_3d_256k b/tests/15imsm-r5_3d_4k-migrate-r5_3d_256k
> new file mode 100644
> index 0000000..14106e0
> --- /dev/null
> +++ b/tests/15imsm-r5_3d_4k-migrate-r5_3d_256k
> @@ -0,0 +1,19 @@
> +# RAID 5 volume, Migration from 4k to 256 chunk size.
> +# POSITIVE test
> +
> +num_disks=3
> +device_list="$dev0 $dev1 $dev2"
> +
> +# RAID 5, 3 disks, 4k chunk size
> +vol0_level=5
> +vol0_comp_size=$((5 * 1024))
> +vol0_chunk=4
> +vol0_num_comps=$((num_disks - 1))
> +vol0_offset=0
> +
> +# RAID 5, 3 disks, 256k chunk size
> +vol0_new_level=5
> +vol0_new_num_comps=$vol0_num_comps
> +vol0_new_chunk=256
> +
> +. tests/imsm-grow-template 0 1
> diff --git a/tests/15imsm-r5_3d_64k-migrate-r5_3d_256k b/tests/15imsm-r5_3d_64k-migrate-r5_3d_256k
> new file mode 100644
> index 0000000..9c447a5
> --- /dev/null
> +++ b/tests/15imsm-r5_3d_64k-migrate-r5_3d_256k
> @@ -0,0 +1,19 @@
> +# RAID 5 volume, Migration from 64k to 256k chunk size.
> +# POSITIVE test
> +
> +num_disks=3
> +device_list="$dev0 $dev1 $dev2"
> +
> +# RAID 5, 3 disks, 64k chunk size
> +vol0_level=5
> +vol0_comp_size=$((5 * 1024))
> +vol0_chunk=64
> +vol0_num_comps=$((num_disks - 1))
> +vol0_offset=0
> +
> +# RAID 5, 3 disks, 256k chunk size
> +vol0_new_level=5
> +vol0_new_num_comps=$vol0_num_comps
> +vol0_new_chunk=256
> +
> +. tests/imsm-grow-template 0 1
> diff --git a/tests/15imsm-r5_6d_4k-migrate-r5_6d_256k b/tests/15imsm-r5_6d_4k-migrate-r5_6d_256k
> new file mode 100644
> index 0000000..baaa182
> --- /dev/null
> +++ b/tests/15imsm-r5_6d_4k-migrate-r5_6d_256k
> @@ -0,0 +1,19 @@
> +# RAID 5 volume, Migration from 4k to 256k chunk size.
> +# POSITIVE test
> +
> +num_disks=6
> +device_list="$dev0 $dev1 $dev2 $dev3 $dev4 $dev5"
> +
> +# RAID 5, 6 disks, 4k chunk size
> +vol0_level=5
> +vol0_comp_size=$((5 * 1024))
> +vol0_chunk=4
> +vol0_num_comps=$((num_disks - 1))
> +vol0_offset=0
> +
> +# RAID 5, 6 disks, 256k chunk size
> +vol0_new_level=5
> +vol0_new_num_comps=$vol0_num_comps
> +vol0_new_chunk=256
> +
> +. tests/imsm-grow-template 0 1
> diff --git a/tests/15imsm-r5_r0_3d_64k-migrate-r5_r0_3d_256k b/tests/15imsm-r5_r0_3d_64k-migrate-r5_r0_3d_256k
> new file mode 100644
> index 0000000..5508036
> --- /dev/null
> +++ b/tests/15imsm-r5_r0_3d_64k-migrate-r5_r0_3d_256k
> @@ -0,0 +1,32 @@
> +# Member 0: RAID 5 volume, Member 1: RAID 0 volume
> +# Migration from 64k to 256k chunk size (both members)
> +# POSITIVE test
> +
> +num_disks=3
> +device_list="$dev0 $dev1 $dev2"
> +
> +# RAID 5, 3 disks, 64k chunk size
> +vol0_level=5
> +vol0_comp_size=$((5 * 1024))
> +vol0_chunk=64
> +vol0_num_comps=$((num_disks - 1))
> +vol0_offset=0
> +
> +# After migration parameters
> +vol0_new_level=5
> +vol0_new_num_comps=$vol0_num_comps
> +vol0_new_chunk=256
> +
> +# RAID 0, 3 disks, 64k chunk size
> +vol1_level=0
> +vol1_comp_size=$((5 * 1024))
> +vol1_chunk=64
> +vol1_num_comps=$num_disks
> +vol1_offset=$((vol0_comp_size + 2048))
> +
> +# After migration paramters
> +vol1_new_level=0
> +vol1_new_num_comps=$vol1_num_comps
> +vol1_new_chunk=256
> +
> +. tests/imsm-grow-template 0 1
> diff --git a/tests/16imsm-r0_3d-migrate-r5_4d b/tests/16imsm-r0_3d-migrate-r5_4d
> new file mode 100644
> index 0000000..cef4512
> --- /dev/null
> +++ b/tests/16imsm-r0_3d-migrate-r5_4d
> @@ -0,0 +1,19 @@
> +# RAID 0 volume (3 disks) migrate to RAID 5 volume (4 disks)
> +# POSITIVE test
> +
> +num_disks=3
> +device_list="$dev0 $dev1 $dev2"
> +
> +# Before: RAID 0, 3 disks, 64k chunk size
> +vol0_level=0
> +vol0_comp_size=$((5 * 1024))
> +vol0_chunk=64
> +vol0_num_comps=$num_disks
> +vol0_offset=0
> +
> +# After: RAID 5, 4 disks, 64k chunk size
> +vol0_new_level=5
> +vol0_new_num_comps=$num_disks
> +vol0_new_chunk=64
> +
> +. tests/imsm-grow-template 0 1
> diff --git a/tests/16imsm-r0_5d-migrate-r5_6d b/tests/16imsm-r0_5d-migrate-r5_6d
> new file mode 100644
> index 0000000..1c83da1
> --- /dev/null
> +++ b/tests/16imsm-r0_5d-migrate-r5_6d
> @@ -0,0 +1,19 @@
> +# RAID 0 volume (5 disks) migrate to RAID 5 volume (6 disks)
> +# POSITIVE test
> +
> +num_disks=5
> +device_list="$dev0 $dev1 $dev2 $dev3 $dev4"
> +
> +# Before: RAID 0, 5 disks, 64k chunk size
> +vol0_level=0
> +vol0_comp_size=$((5 * 1024))
> +vol0_chunk=64
> +vol0_num_comps=$num_disks
> +vol0_offset=0
> +
> +# After: RAID 5, 6 disks, 64k chunk size
> +vol0_new_level=5
> +vol0_new_num_comps=$num_disks
> +vol0_new_chunk=64
> +
> +. tests/imsm-grow-template 0 1
> diff --git a/tests/16imsm-r5_3d-migrate-r0_3d b/tests/16imsm-r5_3d-migrate-r0_3d
> new file mode 100644
> index 0000000..28ea863
> --- /dev/null
> +++ b/tests/16imsm-r5_3d-migrate-r0_3d
> @@ -0,0 +1,19 @@
> +# RAID 5 volume (3 disks) migrate to RAID 0 volume (3 disks)
> +# POSITIVE test
> +
> +num_disks=3
> +device_list="$dev0 $dev1 $dev2"
> +
> +# Before: RAID 5, 3 disks, 64k chunk size
> +vol0_level=5
> +vol0_comp_size=$((5 * 1024))
> +vol0_chunk=64
> +vol0_num_comps=$((num_disks - 1))
> +vol0_offset=0
> +
> +# After: RAID 5, 4 disks, 64k chunk size
> +vol0_new_level=0
> +vol0_new_num_comps=$num_disks
> +vol0_new_chunk=64
> +
> +. tests/imsm-grow-template 0 1
> diff --git a/tests/16imsm-r5_5d-migrate-r0_5d b/tests/16imsm-r5_5d-migrate-r0_5d
> new file mode 100644
> index 0000000..f035b74
> --- /dev/null
> +++ b/tests/16imsm-r5_5d-migrate-r0_5d
> @@ -0,0 +1,19 @@
> +# RAID 5 volume (5 disks) migration to RAID 0 volume (5 disks)
> +# POSITIVE test
> +
> +num_disks=5
> +device_list="$dev0 $dev1 $dev2 $dev3 $dev4"
> +
> +# Before: RAID 5 volume, 5 disks, 64k chunk size
> +vol0_level=5
> +vol0_comp_size=$((5 * 1024))
> +vol0_chunk=64
> +vol0_num_comps=$((num_disks - 1))
> +vol0_offset=0
> +
> +# After: RAID 0 volume, 5 disks, 64k chunk size
> +vol0_new_level=0
> +vol0_new_num_comps=$num_disks
> +vol0_new_chunk=64
> +
> +. tests/imsm-grow-template 0 1
> diff --git a/tests/18imsm-1d-takeover-r0_1d b/tests/18imsm-1d-takeover-r0_1d
> new file mode 100644
> index 0000000..82401fc
> --- /dev/null
> +++ b/tests/18imsm-1d-takeover-r0_1d
> @@ -0,0 +1,21 @@
> +# Create RAID 0 from a single disk.
> +# POSITIVE test
> +
> +vol0_num_comps=1
> +vol0_comp_size=$((10 * 1024))
> +
> +# Create container
> +mdadm --create --run $container --auto=md --metadata=imsm --force --raid-disks=$vol0_num_comps $dev0
> +wait
> +imsm_check container $vol0_num_comps
> +
> +# Create RAID 0 volume
> +mdadm --create --run $member0 --auto=md --level=0 --size=$vol0_comp_size --chunk=64 --force --raid-disks=$vol0_num_comps $dev0
> +wait
> +check wait
> +
> +# Test the member
> +imsm_check member $member0 $vol0_num_comps 0 $vol0_comp_size $((vol0_num_comps * vol0_comp_size)) 0 64
> +testdev $member0 $vol0_num_comps $vol0_comp_size 64
> +
> +exit 0
> diff --git a/tests/18imsm-1d-takeover-r1_2d b/tests/18imsm-1d-takeover-r1_2d
> new file mode 100644
> index 0000000..e965cbd
> --- /dev/null
> +++ b/tests/18imsm-1d-takeover-r1_2d
> @@ -0,0 +1,19 @@
> +# Create RAID 1 from a single disk
> +# POSITIVE test
> +
> +vol0_num_comps=1
> +vol0_comp_size=$((10 * 1024))
> +
> +# Create container
> +mdadm --create --run $container --auto=md --metadata=imsm --force --raid-disks=$vol0_num_comps $dev0
> +wait
> +imsm_check container $vol0_num_comps
> +
> +# Create RAID 1 volume
> +mdadm --create --run $member0 --auto=md --level=1 --size=$vol0_comp_size --chunk=64 --raid-disks=$((vol0_num_comps + 1)) $dev0 missing
> +wait
> +check wait
> +
> +# Test the member0
> +imsm_check member $member0 $((vol_num_comps + 1)) 1 $vol0_comp_size $((vol0_num_comps * vol0_comp_size)) 0 64
> +testdev $member0 $vol0_num_comps $vol0_comp_size 64
> diff --git a/tests/18imsm-r0_2d-takeover-r10_4d b/tests/18imsm-r0_2d-takeover-r10_4d
> new file mode 100644
> index 0000000..fd825d9
> --- /dev/null
> +++ b/tests/18imsm-r0_2d-takeover-r10_4d
> @@ -0,0 +1,19 @@
> +# RAID 0 volume, 2 disks change to RAID 10 volume, 4 disks
> +# POSITIVE test
> +
> +num_disks=2
> +device_list="$dev0 $dev1"
> +
> +# Before: RAID 0 volume, 2 disks, 256k chunk size
> +vol0_level=0
> +vol0_comp_size=$((5 * 1024))
> +vol0_chunk=128
> +vol0_num_comps=$num_disks
> +vol0_offset=0
> +
> +# After: RAID 10 volume, 4 disks, 256k chunk size
> +vol0_new_level=10
> +vol0_new_num_comps=$vol0_num_comps
> +vol0_new_chunk=128
> +
> +. tests/imsm-grow-template 0 1 1
> diff --git a/tests/18imsm-r10_4d-takeover-r0_2d b/tests/18imsm-r10_4d-takeover-r0_2d
> new file mode 100644
> index 0000000..19a1160
> --- /dev/null
> +++ b/tests/18imsm-r10_4d-takeover-r0_2d
> @@ -0,0 +1,20 @@
> +# RAID 10 volume, 4 disks change to RAID 0 volume, 2 disks
> +# POSITIVE test
> +
> +num_disks=4
> +device_list="$dev0 $dev1 $dev2 $dev3"
> +
> +# Before: RAID 10 volume, 4 disks, 128k chunk size
> +vol0_level=10
> +vol0_comp_size=$((5 * 1024))
> +vol0_chunk=128
> +vol0_num_comps=$((num_disks - 2))
> +vol0_offset=0
> +
> +# After: RAID 0 volume, 2 disks, 128k chunk size
> +vol0_new_level=0
> +vol0_new_num_comps=2
> +vol0_new_chunk=128
> +new_num_disks=2
> +
> +. tests/imsm-grow-template 0 1
> diff --git a/tests/env-12imsm-r0_2d-grow-r0_3d b/tests/env-12imsm-r0_2d-grow-r0_3d
> new file mode 120000
> index 0000000..1801784
> --- /dev/null
> +++ b/tests/env-12imsm-r0_2d-grow-r0_3d
> @@ -0,0 +1 @@
> +env-imsm-template
> \ No newline at end of file
> diff --git a/tests/env-12imsm-r0_2d-grow-r0_4d b/tests/env-12imsm-r0_2d-grow-r0_4d
> new file mode 120000
> index 0000000..1801784
> --- /dev/null
> +++ b/tests/env-12imsm-r0_2d-grow-r0_4d
> @@ -0,0 +1 @@
> +env-imsm-template
> \ No newline at end of file
> diff --git a/tests/env-12imsm-r0_2d-grow-r0_5d b/tests/env-12imsm-r0_2d-grow-r0_5d
> new file mode 120000
> index 0000000..1801784
> --- /dev/null
> +++ b/tests/env-12imsm-r0_2d-grow-r0_5d
> @@ -0,0 +1 @@
> +env-imsm-template
> \ No newline at end of file
> diff --git a/tests/env-12imsm-r0_3d-grow-r0_4d b/tests/env-12imsm-r0_3d-grow-r0_4d
> new file mode 120000
> index 0000000..1801784
> --- /dev/null
> +++ b/tests/env-12imsm-r0_3d-grow-r0_4d
> @@ -0,0 +1 @@
> +env-imsm-template
> \ No newline at end of file
> diff --git a/tests/env-12imsm-r5_3d-grow-r5_4d b/tests/env-12imsm-r5_3d-grow-r5_4d
> new file mode 120000
> index 0000000..1801784
> --- /dev/null
> +++ b/tests/env-12imsm-r5_3d-grow-r5_4d
> @@ -0,0 +1 @@
> +env-imsm-template
> \ No newline at end of file
> diff --git a/tests/env-12imsm-r5_3d-grow-r5_5d b/tests/env-12imsm-r5_3d-grow-r5_5d
> new file mode 120000
> index 0000000..1801784
> --- /dev/null
> +++ b/tests/env-12imsm-r5_3d-grow-r5_5d
> @@ -0,0 +1 @@
> +env-imsm-template
> \ No newline at end of file
> diff --git a/tests/env-13imsm-r0_r0_2d-grow-r0_r0_4d b/tests/env-13imsm-r0_r0_2d-grow-r0_r0_4d
> new file mode 120000
> index 0000000..1801784
> --- /dev/null
> +++ b/tests/env-13imsm-r0_r0_2d-grow-r0_r0_4d
> @@ -0,0 +1 @@
> +env-imsm-template
> \ No newline at end of file
> diff --git a/tests/env-13imsm-r0_r0_2d-grow-r0_r0_5d b/tests/env-13imsm-r0_r0_2d-grow-r0_r0_5d
> new file mode 120000
> index 0000000..1801784
> --- /dev/null
> +++ b/tests/env-13imsm-r0_r0_2d-grow-r0_r0_5d
> @@ -0,0 +1 @@
> +env-imsm-template
> \ No newline at end of file
> diff --git a/tests/env-13imsm-r0_r0_3d-grow-r0_r0_4d b/tests/env-13imsm-r0_r0_3d-grow-r0_r0_4d
> new file mode 120000
> index 0000000..1801784
> --- /dev/null
> +++ b/tests/env-13imsm-r0_r0_3d-grow-r0_r0_4d
> @@ -0,0 +1 @@
> +env-imsm-template
> \ No newline at end of file
> diff --git a/tests/env-13imsm-r0_r5_3d-grow-r0_r5_4d b/tests/env-13imsm-r0_r5_3d-grow-r0_r5_4d
> new file mode 120000
> index 0000000..1801784
> --- /dev/null
> +++ b/tests/env-13imsm-r0_r5_3d-grow-r0_r5_4d
> @@ -0,0 +1 @@
> +env-imsm-template
> \ No newline at end of file
> diff --git a/tests/env-13imsm-r0_r5_3d-grow-r0_r5_5d b/tests/env-13imsm-r0_r5_3d-grow-r0_r5_5d
> new file mode 120000
> index 0000000..1801784
> --- /dev/null
> +++ b/tests/env-13imsm-r0_r5_3d-grow-r0_r5_5d
> @@ -0,0 +1 @@
> +env-imsm-template
> \ No newline at end of file
> diff --git a/tests/env-13imsm-r5_r0_3d-grow-r5_r0_4d b/tests/env-13imsm-r5_r0_3d-grow-r5_r0_4d
> new file mode 120000
> index 0000000..1801784
> --- /dev/null
> +++ b/tests/env-13imsm-r5_r0_3d-grow-r5_r0_4d
> @@ -0,0 +1 @@
> +env-imsm-template
> \ No newline at end of file
> diff --git a/tests/env-13imsm-r5_r0_3d-grow-r5_r0_5d b/tests/env-13imsm-r5_r0_3d-grow-r5_r0_5d
> new file mode 120000
> index 0000000..1801784
> --- /dev/null
> +++ b/tests/env-13imsm-r5_r0_3d-grow-r5_r0_5d
> @@ -0,0 +1 @@
> +env-imsm-template
> \ No newline at end of file
> diff --git a/tests/env-14imsm-r0_3d-r5_3d-migrate-r5_4d-r5_4d b/tests/env-14imsm-r0_3d-r5_3d-migrate-r5_4d-r5_4d
> new file mode 120000
> index 0000000..1801784
> --- /dev/null
> +++ b/tests/env-14imsm-r0_3d-r5_3d-migrate-r5_4d-r5_4d
> @@ -0,0 +1 @@
> +env-imsm-template
> \ No newline at end of file
> diff --git a/tests/env-14imsm-r0_3d_no_spares-migrate-r5_3d b/tests/env-14imsm-r0_3d_no_spares-migrate-r5_3d
> new file mode 120000
> index 0000000..1801784
> --- /dev/null
> +++ b/tests/env-14imsm-r0_3d_no_spares-migrate-r5_3d
> @@ -0,0 +1 @@
> +env-imsm-template
> \ No newline at end of file
> diff --git a/tests/env-14imsm-r0_r0_2d-takeover-r10_4d b/tests/env-14imsm-r0_r0_2d-takeover-r10_4d
> new file mode 120000
> index 0000000..1801784
> --- /dev/null
> +++ b/tests/env-14imsm-r0_r0_2d-takeover-r10_4d
> @@ -0,0 +1 @@
> +env-imsm-template
> \ No newline at end of file
> diff --git a/tests/env-14imsm-r10_4d-grow-r10_5d b/tests/env-14imsm-r10_4d-grow-r10_5d
> new file mode 120000
> index 0000000..1801784
> --- /dev/null
> +++ b/tests/env-14imsm-r10_4d-grow-r10_5d
> @@ -0,0 +1 @@
> +env-imsm-template
> \ No newline at end of file
> diff --git a/tests/env-14imsm-r10_r5_4d-takeover-r0_2d b/tests/env-14imsm-r10_r5_4d-takeover-r0_2d
> new file mode 120000
> index 0000000..1801784
> --- /dev/null
> +++ b/tests/env-14imsm-r10_r5_4d-takeover-r0_2d
> @@ -0,0 +1 @@
> +env-imsm-template
> \ No newline at end of file
> diff --git a/tests/env-14imsm-r1_2d-grow-r1_3d b/tests/env-14imsm-r1_2d-grow-r1_3d
> new file mode 120000
> index 0000000..1801784
> --- /dev/null
> +++ b/tests/env-14imsm-r1_2d-grow-r1_3d
> @@ -0,0 +1 @@
> +env-imsm-template
> \ No newline at end of file
> diff --git a/tests/env-14imsm-r1_2d-takeover-r0_2d b/tests/env-14imsm-r1_2d-takeover-r0_2d
> new file mode 120000
> index 0000000..1801784
> --- /dev/null
> +++ b/tests/env-14imsm-r1_2d-takeover-r0_2d
> @@ -0,0 +1 @@
> +env-imsm-template
> \ No newline at end of file
> diff --git a/tests/env-14imsm-r5_3d-grow-r5_4d-no-spares b/tests/env-14imsm-r5_3d-grow-r5_4d-no-spares
> new file mode 120000
> index 0000000..1801784
> --- /dev/null
> +++ b/tests/env-14imsm-r5_3d-grow-r5_4d-no-spares
> @@ -0,0 +1 @@
> +env-imsm-template
> \ No newline at end of file
> diff --git a/tests/env-14imsm-r5_3d-grow-r5_5d-no-spares b/tests/env-14imsm-r5_3d-grow-r5_5d-no-spares
> new file mode 120000
> index 0000000..1801784
> --- /dev/null
> +++ b/tests/env-14imsm-r5_3d-grow-r5_5d-no-spares
> @@ -0,0 +1 @@
> +env-imsm-template
> \ No newline at end of file
> diff --git a/tests/env-14imsm-r5_3d-migrate-r4_3d b/tests/env-14imsm-r5_3d-migrate-r4_3d
> new file mode 120000
> index 0000000..1801784
> --- /dev/null
> +++ b/tests/env-14imsm-r5_3d-migrate-r4_3d
> @@ -0,0 +1 @@
> +env-imsm-template
> \ No newline at end of file
> diff --git a/tests/env-15imsm-r0_3d_64k-migrate-r0_3d_256k b/tests/env-15imsm-r0_3d_64k-migrate-r0_3d_256k
> new file mode 120000
> index 0000000..1801784
> --- /dev/null
> +++ b/tests/env-15imsm-r0_3d_64k-migrate-r0_3d_256k
> @@ -0,0 +1 @@
> +env-imsm-template
> \ No newline at end of file
> diff --git a/tests/env-15imsm-r5_3d_4k-migrate-r5_3d_256k b/tests/env-15imsm-r5_3d_4k-migrate-r5_3d_256k
> new file mode 120000
> index 0000000..1801784
> --- /dev/null
> +++ b/tests/env-15imsm-r5_3d_4k-migrate-r5_3d_256k
> @@ -0,0 +1 @@
> +env-imsm-template
> \ No newline at end of file
> diff --git a/tests/env-15imsm-r5_3d_64k-migrate-r5_3d_256k b/tests/env-15imsm-r5_3d_64k-migrate-r5_3d_256k
> new file mode 120000
> index 0000000..1801784
> --- /dev/null
> +++ b/tests/env-15imsm-r5_3d_64k-migrate-r5_3d_256k
> @@ -0,0 +1 @@
> +env-imsm-template
> \ No newline at end of file
> diff --git a/tests/env-15imsm-r5_6d_4k-migrate-r5_6d_256k b/tests/env-15imsm-r5_6d_4k-migrate-r5_6d_256k
> new file mode 120000
> index 0000000..1801784
> --- /dev/null
> +++ b/tests/env-15imsm-r5_6d_4k-migrate-r5_6d_256k
> @@ -0,0 +1 @@
> +env-imsm-template
> \ No newline at end of file
> diff --git a/tests/env-15imsm-r5_r0_3d_64k-migrate-r5_r0_3d_128k b/tests/env-15imsm-r5_r0_3d_64k-migrate-r5_r0_3d_128k
> new file mode 120000
> index 0000000..1801784
> --- /dev/null
> +++ b/tests/env-15imsm-r5_r0_3d_64k-migrate-r5_r0_3d_128k
> @@ -0,0 +1 @@
> +env-imsm-template
> \ No newline at end of file
> diff --git a/tests/env-15imsm-r5_r0_3d_64k-migrate-r5_r0_3d_256k b/tests/env-15imsm-r5_r0_3d_64k-migrate-r5_r0_3d_256k
> new file mode 120000
> index 0000000..1801784
> --- /dev/null
> +++ b/tests/env-15imsm-r5_r0_3d_64k-migrate-r5_r0_3d_256k
> @@ -0,0 +1 @@
> +env-imsm-template
> \ No newline at end of file
> diff --git a/tests/env-16imsm-r0_3d-migrate-r5_4d b/tests/env-16imsm-r0_3d-migrate-r5_4d
> new file mode 120000
> index 0000000..1801784
> --- /dev/null
> +++ b/tests/env-16imsm-r0_3d-migrate-r5_4d
> @@ -0,0 +1 @@
> +env-imsm-template
> \ No newline at end of file
> diff --git a/tests/env-16imsm-r0_5d-migrate-r5_6d b/tests/env-16imsm-r0_5d-migrate-r5_6d
> new file mode 120000
> index 0000000..1801784
> --- /dev/null
> +++ b/tests/env-16imsm-r0_5d-migrate-r5_6d
> @@ -0,0 +1 @@
> +env-imsm-template
> \ No newline at end of file
> diff --git a/tests/env-16imsm-r5_3d-migrate-r0_3d b/tests/env-16imsm-r5_3d-migrate-r0_3d
> new file mode 120000
> index 0000000..1801784
> --- /dev/null
> +++ b/tests/env-16imsm-r5_3d-migrate-r0_3d
> @@ -0,0 +1 @@
> +env-imsm-template
> \ No newline at end of file
> diff --git a/tests/env-16imsm-r5_5d-migrate-r0_5d b/tests/env-16imsm-r5_5d-migrate-r0_5d
> new file mode 120000
> index 0000000..1801784
> --- /dev/null
> +++ b/tests/env-16imsm-r5_5d-migrate-r0_5d
> @@ -0,0 +1 @@
> +env-imsm-template
> \ No newline at end of file
> diff --git a/tests/env-17imsm-r5_3d-migrate-r4_3d b/tests/env-17imsm-r5_3d-migrate-r4_3d
> new file mode 120000
> index 0000000..1801784
> --- /dev/null
> +++ b/tests/env-17imsm-r5_3d-migrate-r4_3d
> @@ -0,0 +1 @@
> +env-imsm-template
> \ No newline at end of file
> diff --git a/tests/env-18imsm-1d-takeover-r0_1d b/tests/env-18imsm-1d-takeover-r0_1d
> new file mode 120000
> index 0000000..1801784
> --- /dev/null
> +++ b/tests/env-18imsm-1d-takeover-r0_1d
> @@ -0,0 +1 @@
> +env-imsm-template
> \ No newline at end of file
> diff --git a/tests/env-18imsm-1d-takeover-r1_2d b/tests/env-18imsm-1d-takeover-r1_2d
> new file mode 120000
> index 0000000..1801784
> --- /dev/null
> +++ b/tests/env-18imsm-1d-takeover-r1_2d
> @@ -0,0 +1 @@
> +env-imsm-template
> \ No newline at end of file
> diff --git a/tests/env-18imsm-r0_2d-takeover-r10_4d b/tests/env-18imsm-r0_2d-takeover-r10_4d
> new file mode 120000
> index 0000000..1801784
> --- /dev/null
> +++ b/tests/env-18imsm-r0_2d-takeover-r10_4d
> @@ -0,0 +1 @@
> +env-imsm-template
> \ No newline at end of file
> diff --git a/tests/env-18imsm-r10_4d-takeover-r0_2d b/tests/env-18imsm-r10_4d-takeover-r0_2d
> new file mode 120000
> index 0000000..1801784
> --- /dev/null
> +++ b/tests/env-18imsm-r10_4d-takeover-r0_2d
> @@ -0,0 +1 @@
> +env-imsm-template
> \ No newline at end of file
> diff --git a/tests/env-18imsm-r1_2d-takeover-r0_2d b/tests/env-18imsm-r1_2d-takeover-r0_2d
> new file mode 120000
> index 0000000..1801784
> --- /dev/null
> +++ b/tests/env-18imsm-r1_2d-takeover-r0_2d
> @@ -0,0 +1 @@
> +env-imsm-template
> \ No newline at end of file
> diff --git a/tests/env-imsm-template b/tests/env-imsm-template
> new file mode 100644
> index 0000000..8238ddd
> --- /dev/null
> +++ b/tests/env-imsm-template
> @@ -0,0 +1,85 @@
> +imsm_check() {
> +    udevadm settle
> +    case $1 in
> +    container )
> +        grep -s "$(((418 * $2) / 2)) blocks super external:imsm" /proc/mdstat > /dev/null || {
> +            echo >&2 "**Fatal** Correctly formed container not found"; cat /proc/mdstat; exit 1; }
> +        ;;
> +    member )
> +        t_member=$2
> +        t_num_disks=$3
> +        t_level=$4
> +        t_rd_size=$5
> +        t_size=$6
> +        t_offset=$7
> +        t_chunk=$8
> +	t_takeover10=$9
> +
> +        err=0
> +
> +        eval `stat -L -c "let major=0x%t; let minor=0x%T;" $t_member`
> +        sysfs=/sys/dev/block/${major}:${minor}
> +        if [ ! -f ${sysfs}/md/array_state ]; then
> +            echo "**Fatal**: Array member $t_member not found" >&2; cat /proc/mdstat >&2; exit 1
> +        fi
> +        _chunk=`cat ${sysfs}/md/chunk_size`
> +        if [ $t_chunk -ne $((_chunk/1024)) ]; then
> +            echo "**Error**: Chunk size mismatch - expected $t_chunk, actual $_chunk" >&2
> +            err=$((err + 1))
> +        fi
> +	if [ ! -z $t_takeover10 ] ; then
> +		t_num_disks=$(( t_num_disks * 2 ))
> +	fi
> +        for i in `seq 0 $((t_num_disks - 1))`; do
> +	    if [ ! -z $t_takeover10 ] && [ ! -z $(( $i % 2 )) ] ; then
> +		continue
> +	    fi
> +	    _offset=`cat ${sysfs}/md/rd${i}/offset`
> +	    if [ $t_offset -ne $((_offset / 2)) ]; then
> +		echo "**Error**: Offset mismatch - expected $t_offset, actual $_offset" >&2
> +		err=$((err + 1))
> +	    fi
> +	    _rd_size=`cat ${sysfs}/md/rd${i}/size`
> +	    if [ $t_rd_size -ne $_rd_size ]; then
> +		echo "**Error**: Component size mismatch - expected $t_rd_size, actual $_rd_size" >&2
> +		err=$((err + 1))
> +	    fi
> +        done
> +        _size=`cat ${sysfs}/md/array_size`
> +        if [ $t_size -ne $_size ]; then
> +            echo "**Error**: Array size mismatch - expected $t_size, actual $_size" >&2
> +            err=$((err + 1))
> +        fi
> +        if [ $err -gt 0 ]; then
> +            echo "$t_member failed check" >&2
> +            cat /proc/mdstat >&2
> +            mdadm -E /dev/loop0 >&2
> +            exit 1
> +        fi
> +        ;;
> +    * )
> +        echo >&2 "**Error** unknown check $1"; exit 1;
> +    esac
> +}
> +
> +setup_env() {
> +    export IMSM_NO_PLATFORM=1
> +    export IMSM_DEVNAME_AS_SERIAL=1
> +    export IMSM_TEST_OROM=1
> +    export MDADM_EXPERIMENTAL=1
> +    container=/dev/md/container
> +    member0=/dev/md/vol0
> +    member1=/dev/md/vol1
> +}
> +
> +reset_env() {
> +    unset IMSM_NO_PLATFORM
> +    unset IMSM_DENAME_AS_SERIAL
> +    unset IMSM_TEST_OROM
> +    unset MDADM_EXPERIMENTAL
> +    unset member0
> +    unset member1
> +    unset imsm_check
> +    unset container
> +    rm -f /tmp/backup_imsm
> +}
> diff --git a/tests/imsm-grow-template b/tests/imsm-grow-template
> new file mode 100644
> index 0000000..0944d09
> --- /dev/null
> +++ b/tests/imsm-grow-template
> @@ -0,0 +1,104 @@
> +
> +# 0 - POSITIVE test, otherwise NEGATIVE test
> +negative_test=$1
> +
> +# 0 - On-line Capacity Expansion test, otherwise LEVEL migration or CHUNK size migration test
> +migration_test=$2
> +
> +# 1 - raid0 -> raid10 takeover verification
> +takeover10_test=$3
> +
> +function grow_member() {
> +	local member=$1
> +	local disks=$2
> +	local comps=$3
> +	local level=$4
> +	local size=$5
> +	local offset=$6
> +	local chunk=$7
> +	local array_size=$((comps * size))
> +
> +	( set -ex; mdadm --grow $member --chunk=$chunk --level=$level --backup-file=/tmp/backup_imsm )
> +	local status=$?
> +	if [ $negative_test -ne 0 ]; then
> +		if [ $status -eq 0 ]; then
> +			echo >&2 "**Error**: $member: --grow should failed, but it completed successfuly"
> +			exit 1
> +		fi
> +		return
> +	fi
> +	check wait
> +	sleep 5
> +	imsm_check member $member $disks $level $size $array_size $offset $chunk $takeover10_test
> +	testdev $member $comps $size $chunk $takeover10_test
> +}
> +
> +# Create container
> +mdadm --create --run $container --auto=md --metadata=imsm --raid-disks=$num_disks $device_list
> +wait
> +imsm_check container $num_disks
> +
> +# Create first volume inside the container
> +mdadm --create --run $member0 --auto=md --level=$vol0_level --size=$vol0_comp_size --chunk=$vol0_chunk --raid-disks=$num_disks $device_list
> +wait
> +
> +# Create second volume inside the container (if defined)
> +if [ ! -z $vol1_chunk ]; then
> +    mdadm --create --run $member1 --auto=md --level=$vol1_level --size=$vol1_comp_size --chunk=$vol1_chunk --raid-disks=$num_disks $device_list
> +    wait
> +fi
> +
> +# Wait for any RESYNC to complete
> +check wait
> +
> +# Test first volume
> +imsm_check member $member0 $num_disks $vol0_level $vol0_comp_size $((vol0_comp_size * vol0_num_comps)) $vol0_offset $vol0_chunk
> +testdev $member0 $vol0_num_comps $vol0_comp_size $vol0_chunk
> +
> +# Test second volume (if defined)
> +if [ ! -z $vol1_chunk ]; then
> +    imsm_check member $member1 $num_disks $vol1_level $vol1_comp_size $((vol1_comp_size * vol1_num_comps)) $vol1_offset $vol1_chunk
> +    testdev $member1 $vol1_num_comps $vol1_comp_size $vol1_chunk
> +fi
> +
> +# Add extra disks to container if operation requires spares in container.
> +for i in $spare_list
> +do
> +    mdadm --add $container $i
> +    wait
> +    num_disks=$((num_disks + 1))
> +done
> +
> +imsm_check container $num_disks
> +num_disks=$((num_disks + add_to_num_disks))
> +
> +# Grow each member or a container depending on the type of an operation
> +if [ $migration_test -ne 0 ]; then
> +	if [ -z $new_num_disks ]; then
> +		new_num_disks=$num_disks
> +	fi
> +	grow_member $member0 $new_num_disks $vol0_new_num_comps $vol0_new_level $vol0_comp_size $vol0_offset $vol0_new_chunk
> +	if [ $vol1_new_chunk -ne 0 ]; then
> +		grow_member $member1 $new_num_disks $vol1_new_num_comps $vol1_new_level $vol1_comp_size $vol1_offset $vol1_new_chunk
> +	fi
> +else
> +	( set -x; mdadm --grow $container --raid-disks=$num_disks --backup-file=/tmp/backup_imsm )
> +	grow_status=$?
> +	if [ $negative_test -ne 0 ]; then
> +		if [ $grow_status -eq 0 ]; then
> +			echo >&2 "**Error**: $container: --grow should failed, but it completed successfuly"
> +			exit 1
> +		fi
> +	else
> +		check wait
> +		sleep 5
> +		imsm_check member $member0 $num_disks $vol0_level $vol0_comp_size $((vol0_comp_size * vol0_new_num_comps)) $vol0_offset $vol0_chunk
> +		testdev $member0 $vol0_new_num_comps $vol0_comp_size $vol0_chunk
> +		if [ $vol1_new_num_comps -ne 0 ]; then
> +			imsm_check member $member1 $num_disks $vol1_level $vol1_comp_size $((vol1_comp_size * vol1_new_num_comps)) $vol1_offset $vol1_chunk
> +			testdev $member1 $vol1_new_num_comps $vol1_comp_size $vol1_chunk
> +		fi
> +	fi
> +fi
> +
> +exit 0


From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/2] tests: use $config to store test config path
Date: Mon, 28 Mar 2011 10:42:44 +1100
Message-ID: <20110328104244.5204624e@notabene.brown>
References: <A9DE54D0CD747C4CB06DCE5B6FA2246F012A774355@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A9DE54D0CD747C4CB06DCE5B6FA2246F012A774355@irsmsx504.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids

On Thu, 24 Mar 2011 21:43:44 +0000 "Czarnowska, Anna"
<anna.czarnowska@intel.com> wrote:

> >From da9aaa4cf9422ace05584f942844be95c12db9f4 Mon Sep 17 00:00:00 2001
> From: Anna Czarnowska <anna.czarnowska@intel.com>
> Date: Thu, 24 Mar 2011 16:22:28 +0100
> Subject: [PATCH 1/2] tests: use $config to store test config path
> Cc: linux-raid@vger.kernel.org, Williams, Dan J <dan.j.williams@intel.com>, Ciechanowski, Ed <ed.ciechanowski@intel.com>
> 
> We also need to tell Monitor where to look for Policy in 11spare-migration tests
> 
> Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>

Applied, thanks.

NeilBrown





> ---
>  test                    |    2 ++
>  tests/11spare-migration |    6 +++---
>  tests/utils             |   11 +++++------
>  3 files changed, 10 insertions(+), 9 deletions(-)
> 
> diff --git a/test b/test
> index ca7643f..1aaf3c1 100755
> --- a/test
> +++ b/test
> @@ -48,6 +48,8 @@ mdsize12=19988
>  # ddf needs bigger devices as 32Meg is reserved!
>  ddfsize=65536
>  
> +config=/tmp/mdadm.conf
> +
>  cleanup() {
>  	udevadm settle
>  	$mdadm -Ssq 2> /dev/null
> diff --git a/tests/11spare-migration b/tests/11spare-migration
> index 3567883..58f1df9 100644
> --- a/tests/11spare-migration
> +++ b/tests/11spare-migration
> @@ -25,7 +25,7 @@ listfailed="yes"
>  monitor(){
>         [ -z $monitorpid ] || return
>         if [ "$scan" == "yes" ]; then
> -               $mdadm -F -d 1 --scan --mail root@localhost &
> +               $mdadm -F -d 1 --scan --mail root@localhost -c $config &
>                 monitorpid=$!
>                 return
>         fi
> @@ -44,10 +44,10 @@ monitor(){
>         done
>         if [ -n "$mddevs" ]; then
>                 if [ "$verbose" != "yes" ]; then
> -                       $mdadm -F -d 1 $mddevs >&2 &
> +                       $mdadm -F -d 1 $mddevs -c $config >&2 &
>                         monitorpid=$!
>                 else
> -                       $mdadm -F -t -d 1 $mddevs &
> +                       $mdadm -F -t -d 1 $mddevs -c $config &
>                         monitorpid=$!
>                 fi
>         fi
> diff --git a/tests/utils b/tests/utils
> index ef8be4f..3acebd7 100644
> --- a/tests/utils
> +++ b/tests/utils
> @@ -15,7 +15,7 @@ devices="/dev/loop[0-9] /dev/loop10 /dev/loop11 /dev/loop12"
>  # uses testdsc and platform global variables
>  err(){
>         echo >&2 "ERROR: $*"
> -       cat /tmp/mdadm.conf >&2 || true
> +       cat $config >&2 || true
>         cat /proc/mdstat >&2
>         [ -z "$testdsc" ] || { echo >&2 $platform: $testdsc "- failed"; }
>         ps -e | grep mdadm >&2 || true
> @@ -45,7 +45,7 @@ tidyup(){
>         mdadm -Ss
>         mdadm --zero-superblock $devices || true
>         udevadm settle
> -       rm -f /tmp/mdadm.conf
> +       rm -f $config
>  }
>  
>  trap tidyup 0 1 2 3 15
> @@ -167,7 +167,6 @@ chksparemoved(){
>  
>  # for domains defined through policy
>  createconfig(){
> -conf=/tmp/mdadm.conf
>  if [ "$1" != "a" ]; then
>  {
>         domain=$1
> @@ -181,12 +180,12 @@ if [ "$1" != "a" ]; then
>                 echo "$echo"
>                 shift
>         done
> -} >> $conf
> +} >> $config
>  else
>  {
>         echo "DEVICES $devlist /dev/md1*"
>         mdadm -Ebs
> -} >  $conf
> +} >  $config
>  fi
> -#[ "$verbose" != "yes" ] || cat /tmp/mdadm.conf | grep policy || true
> +#[ "$verbose" != "yes" ] || cat $config | grep policy || true
>  }


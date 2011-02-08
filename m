From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] Spare migration tests updated
Date: Tue, 8 Feb 2011 11:46:55 +1100
Message-ID: <20110208114655.47d2e9b2@notabene.brown>
References: <A9DE54D0CD747C4CB06DCE5B6FA2246F010ECF58D8@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A9DE54D0CD747C4CB06DCE5B6FA2246F010ECF58D8@irsmsx504.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids

On Mon, 7 Feb 2011 13:37:36 +0000 "Czarnowska, Anna"
<anna.czarnowska@intel.com> wrote:

> >From ba9f22404ed0df2273aebc0deccf82d490c7e913 Mon Sep 17 00:00:00 2001
> From: Anna Czarnowska <anna.czarnowska@intel.com>
> Date: Mon, 7 Feb 2011 14:30:34 +0100
> Subject: [PATCH] Spare migration tests updated
> Cc: linux-raid@vger.kernel.org, Williams, Dan J <dan.j.williams@intel.com>, Ciechanowski, Ed <ed.ciechanowski@intel.com>
> 
> Added tests for cases when:
> 0  - there is no config file at all
> 0a - config file has no domains defined
> 9a - spare is in global domain
> 15 - spare is in global domain for $platform metadata
> 
> Test 4 pass condition changed for imsm metadata.
> 
> disk_policy only adds controller domain for imsm
> when config_rules_has_path=1.
> If there are any domains in config then every disk will have also
> a controller domain.
> As a result the array needing spares has at least
> one controller domain even when it doesn't have any other
> domains specified explicitly. In this case any spare in the same
> controller domain matches when it has no other domains from config.
> (This behaviour is different from the case when there is no paths
> in config at all as array domain then is null and no spare matches)
> 
> Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>


Applied, thanks.


NeilBrown




> ---
>  tests/11spare-migration |   72 +++++++++++++++++++++++++++++++++++++++++++++--
>  1 files changed, 69 insertions(+), 3 deletions(-)
> 
> diff --git a/tests/11spare-migration b/tests/11spare-migration
> index c8ef362..3567883 100644
> --- a/tests/11spare-migration
> +++ b/tests/11spare-migration
> @@ -54,6 +54,33 @@ monitor(){
>         [ "$verbose" != "yes" ] || echo $mddevs $monitorpid
>  }
>  
> +test0()
> +{
> +dsc "Test 0: No config file, no spare should be moved"
> +setupdevs 0 0 1 $platform
> +setupdevs 1 3 4 $platform
> +monitor 0 1
> +mdadm -a /dev/$c1 $dev2
> +mdadm --fail /dev/$v0 $dev0
> +# check that spare loop2 was not moved from container c1 to container c0
> +chksparemoved $c1 $c0 $dev2 n
> +tidyup
> +}
> +
> +test0a()
> +{
> +dsc "Test 0a: No domains in config file, no spare should be moved"
> +setupdevs 0 0 1 $platform
> +setupdevs 1 3 4 $platform
> +createconfig a
> +monitor 0 1
> +mdadm -a /dev/$c1 $dev2
> +mdadm --fail /dev/$v0 $dev0
> +# check that spare loop2 was not moved from container c1 to container c0
> +chksparemoved $c1 $c0 $dev2 n
> +tidyup
> +}
> +
>  test1()
>  {
>  dsc "Test 1: Common domain, add disk to one container and fail first one in another container, spare should be moved"
> @@ -117,7 +144,7 @@ tidyup
>  
>  test4()
>  {
> -dsc "Test 4: One domain holds one container, fail a disk in domain, and add disk to a container not described by domain, spare loop5 should not be moved"
> +dsc "Test 4: One domain holds one container, fail a disk in domain, and add disk to a container not described by domain, move if metadata allows"
>  setupdevs 0 0 1 $platform
>  setupdevs 1 3 4 $platform
>  createconfig a
> @@ -125,7 +152,9 @@ createconfig domain-$platform $platform spare 0 1 2
>  monitor 0 1
>  mdadm --fail /dev/$v0 $dev1
>  mdadm -a /dev/$c1 $dev5
> -chksparemoved $c1 $c0 $dev5 n
> +unset shouldmove
> +[ "$platform" == "imsm" ] || shouldmove="n"
> +chksparemoved $c1 $c0 $dev5 $shouldmove
>  tidyup
>  }
>  
> @@ -236,7 +265,7 @@ tidyup
>  
>  test9()
>  {
> -dsc "Test 9: imsm and native 1.2 - spare should be shared"
> +dsc "Test 9: imsm and native 1.2 - one domain, no metadata specified, spare should be moved"
>  setupdevs 0 10 11 imsm
>  setupdevs 1 8 9 1.2
>  createconfig a
> @@ -248,6 +277,22 @@ chksparemoved $c1 $c0 $dev12
>  tidyup
>  }
>  
> +test9a()
> +{
> +dsc "Test 9a: imsm and native 1.2 - spare in global domain, should be moved"
> +setupdevs 0 10 11 imsm
> +setupdevs 1 8 9 1.2
> +createconfig a
> +createconfig domain-global noplatform spare 8 9 10 11 12
> +createconfig domain-1.2 1.2 spare 8 9
> +createconfig domain-imsm imsm spare 10 11
> +monitor 0 1
> +mdadm -a /dev/$c1 $dev12
> +mdadm --fail /dev/$v0 $dev10
> +chksparemoved $c1 $c0 $dev12
> +tidyup
> +}
> +
>  test10()
>  {
>  dsc "Test 10: Two arrays on the same devices in container"
> @@ -335,8 +380,27 @@ chksparemoved $c1 $c0 $d2
>  tidyup
>  }
>  
> +test15()
> +{
> +dsc "Test 15: spare in global domain for $platform metadata, should be moved"
> +# this is like 9a but only one metadata used
> +setupdevs 0 10 11 $platform
> +setupdevs 1 8 9 $platform
> +createconfig a
> +createconfig domain-global $platform spare 8 9 10 11 12
> +createconfig domain-1 $platform spare 8 9
> +createconfig domain-2 $platform spare 10 11
> +monitor 0 1
> +mdadm -a /dev/$c1 $dev12
> +mdadm --fail /dev/$v0 $dev10
> +chksparemoved $c1 $c0 $dev12
> +tidyup
> +}
> +
>  try()
>  {
> +test0
> +test0a
>  test1
>  test1a
>  test2
> @@ -351,6 +415,7 @@ if [ "$platform" != "1.2" ]; then
>  fi
>  test8
>  test9
> +test9a
>  if [ "$platform" != "1.2" ]; then
>  # we can't create two subarrays on the same devices for native (without
>  # partitions)
> @@ -360,6 +425,7 @@ test11
>  test12
>  test13
>  test14
> +test15
>  }
>  
>  try_failed()


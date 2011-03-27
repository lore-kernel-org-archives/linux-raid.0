From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 2/2] tests: backup default config before testing
Date: Mon, 28 Mar 2011 10:40:18 +1100
Message-ID: <20110328104018.42ed6657@notabene.brown>
References: <A9DE54D0CD747C4CB06DCE5B6FA2246F012A774356@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A9DE54D0CD747C4CB06DCE5B6FA2246F012A774356@irsmsx504.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids

On Thu, 24 Mar 2011 21:45:56 +0000 "Czarnowska, Anna"
<anna.czarnowska@intel.com> wrote:

> >From 4d7c70452ca8db359fef6a9f3a420d62e67ef3cd Mon Sep 17 00:00:00 2001
> From: Anna Czarnowska <anna.czarnowska@intel.com>
> Date: Thu, 24 Mar 2011 16:24:57 +0100
> Subject: [PATCH 2/2] tests: backup default config before testing
> Cc: linux-raid@vger.kernel.org, Williams, Dan J <dan.j.williams@intel.com>, Ciechanowski, Ed <ed.ciechanowski@intel.com>
> 
> We need to have no config at all for this test so if there is one in the
> system it must be renamed for the test duration.
> 

If you want to have no config at all, then you can
   --config=none
or
   --config=/tmp/mdadm.conf
and make /tmp/mdadm.conf an empty file.

There is really no need to move /etc/mdadm.conf.

I have changed this patch to simple make /tmp/mdamd.conf an empty file.

NeilBrown



> Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>
> ---
>  tests/11spare-migration |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/tests/11spare-migration b/tests/11spare-migration
> index 58f1df9..6c2dc6d 100644
> --- a/tests/11spare-migration
> +++ b/tests/11spare-migration
> @@ -57,6 +57,8 @@ monitor(){
>  test0()
>  {
>  dsc "Test 0: No config file, no spare should be moved"
> +[ -f /etc/mdadm.conf ] && mv /etc/mdadm.conf /etc/_mdadm.conf
> +[ -f $config ] && rm -f $config
>  setupdevs 0 0 1 $platform
>  setupdevs 1 3 4 $platform
>  monitor 0 1
> @@ -64,6 +66,7 @@ mdadm -a /dev/$c1 $dev2
>  mdadm --fail /dev/$v0 $dev0
>  # check that spare loop2 was not moved from container c1 to container c0
>  chksparemoved $c1 $c0 $dev2 n
> +[ -f /etc/_mdadm.conf ] && mv /etc/_mdadm.conf /etc/mdadm.conf
>  tidyup
>  }
>  


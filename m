From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: ANNOUNCE: mdadm 3.2.4 - A tool for managing Soft RAID under Linux
Date: Thu, 10 May 2012 16:59:02 +0200
Message-ID: <4FABD7B6.1060901@redhat.com>
References: <20120509112937.040f11e9@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120509112937.040f11e9@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 05/09/12 03:29, NeilBrown wrote:
> 
> I am pleased to announce the availability of
>    mdadm version 3.2.4
> 
> It is available at the usual places, now including github:
>    countrycode=xx.
>    http://www.${countrycode}kernel.org/pub/linux/utils/raid/mdadm/
> and via git at
>    git://github.com/neilbrown/mdadm
>    git://neil.brown.name/mdadm
>    http://neil.brown.name/git/mdadm
> 
> This release is largely a bugfix release for the 3.2 series with many
> minor fixes with little or no impact.
> 
> "--oneline" log of changes is below.  Some notable ones are:
> 
>  - --offroot argument to improve interactions between mdmon and initrd
>  - --prefer argument to select which /dev names to display in some
>    circumstances.
>  - relax restructions on when "--add" will be allowed
>  - Fix bug with adding write-intent-bitmap to active array
>  - Now defaults to "/run/mdadm" for storing run-time files.
> 
> Upgrading is encouraged.

I can only second this!

For those who are running Fedora and would like to help testing. I just
pushed mdadm-3.2.4 to Fedora 15/16/17/rawhide. you should be able to get
it from updates-testing shortly.

Please upgrade and test!

Cheers,
Jes

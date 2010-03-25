From: "Labun, Marcin" <Marcin.Labun@intel.com>
Subject: RE: Auto Rebuild on hot-plug
Date: Thu, 25 Mar 2010 15:04:58 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D11C510278@irsmsx503.ger.corp.intel.com>
References: <20100325113543.0e2124c5@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100325113543.0e2124c5@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>, Doug Ledford <dledford@redhat.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, Bill Davidsen <davidsen@tmr.com>
List-Id: linux-raid.ids

Thank you for bringing-up this design.

> 
>   Probably the most important first step is to determine a configuration
>   syntax and be sure it is broad enough to cover all needs.
> 
>   I'm thinking:
>     DOMAIN path=glob-pattern metadata=type  hotplug=mode  spare-group=name
> 
>   I explicitly have "path=" in case we find there is a need to identify
>   devices some other way - maybe by control vendor:device or some other
>   content-based approach
>   The spare-group name is inherited by any array with devices in this
>   domain as long as that doesn't result it in having two different
>   spare-group names.
>   I'm not sure if "metadata=" is really needed.  If all the arrays that
> use
>   these devices have the same metadata, it would be redundant to list it
> here.

I think that metadata keyword can be used to identify scope of devices to which the DOMAIN line applies.
For instance we could have:
DOMAIN path=glob-pattern metadata=imsm hotplug=mode1  spare-group=name1
DOMAIN path=glob-pattern metadata=0.90 hotplug=mode2  spare-group=name2

Keywords: 
Path, metadata and spare-group shall define to which arrays the hotplug definition (or other definition of action) applies. User could define any subset of it.
For instance to define that all imsm arrays shall use hotplug mode2 user shall define:
DOMAIN metadata=imsm hotplug=mode2

In above example user need not define spare-group in his/her configuration file for each array.

I also assume that each metadata handler can additionally sets its own rules of accepting the spare in the container. Rules can be derived from platform dependencies or metadata. Notice that user can disable platform specific constrains by defining IMSM_NO_PLATFORM environment variable. 


>   If they use different metadata ... then what?
>   I guess two different DOMAIN lines could identify the same devices and
>   list different metadata types and given them different spare-group
>   names.  However you cannot support hotplug of bare devices into both ...
> 
>   If it possible for multiple DOMAIN lines to identify the same device,
>   e.g. by having more or less specific patterns. In this case the spare-
> group
>   names are ignored if they conflict, and the hotplug mode used is the
> most
>   permissive.
Maybe use the most specific match?

> 
>   hotplug modes are:
>     none  - ignore any hotplugged device
>     incr  - normal incremental assembly (the default).  If the device has
>          metadata that matches an array, try to add it to the array
>     replace - If above fails and a device was recently removed from this
>          same path, add this device to the same array(s) that the old
> devices
>          was part of
>     include - If the above fails and the device has not recognisable
> metadata
>          add it to any array/container that uses devices in this domain,
>          partitioning first if necessary.
>     force - as above but ignore any pre-existing metadata
> 
> 
>   I'm not sure that all those are needed, or are the best names.  Names
> like
>     ignore, reattach, rebuild, rebuild_spare
>   have also been suggested.

Please consider:
      spare_add - add any spare device that matches the metadata container/volume in case of native metadata regardless of array state, so later such a spare can be used in rebuild process.

Can we assume for all external metadata that spares added any container can be potentially moved between all container the same metadata?
I expect that this could be default behavior if no spare groups are defined for some metadata.
More over each metadata handler could impose build-in rules on spares assignment to specific container.

Thanks,
Marcin Labun

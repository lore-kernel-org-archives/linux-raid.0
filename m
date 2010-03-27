From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: Auto Rebuild on hot-plug
Date: Fri, 26 Mar 2010 17:37:57 -0700
Message-ID: <e9c3a7c21003261737k1e753b08xc6f8eb45d0320be9@mail.gmail.com>
References: <20100325113543.0e2124c5@notabene.brown>
	 <905EDD02F158D948B186911EB64DB3D11C510278@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <905EDD02F158D948B186911EB64DB3D11C510278@irsmsx503.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Labun, Marcin" <Marcin.Labun@intel.com>
Cc: Neil Brown <neilb@suse.de>, Doug Ledford <dledford@redhat.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, Bill Davidsen <davidsen@tmr.com>
List-Id: linux-raid.ids

On Thu, Mar 25, 2010 at 8:04 AM, Labun, Marcin <Marcin.Labun@intel.com>=
 wrote:
> I think that metadata keyword can be used to identify scope of device=
s to which the DOMAIN line applies.
> For instance we could have:
> DOMAIN path=3Dglob-pattern metadata=3Dimsm hotplug=3Dmode1 =A0spare-g=
roup=3Dname1
> DOMAIN path=3Dglob-pattern metadata=3D0.90 hotplug=3Dmode2 =A0spare-g=
roup=3Dname2
>
> Keywords:
> Path, metadata and spare-group shall define to which arrays the hotpl=
ug definition (or other definition of action) applies. User could defin=
e any subset of it.
> For instance to define that all imsm arrays shall use hotplug mode2 u=
ser shall define:
> DOMAIN metadata=3Dimsm hotplug=3Dmode2
>
> In above example user need not define spare-group in his/her configur=
ation file for each array.
>
> I also assume that each metadata handler can additionally sets its ow=
n rules of accepting the spare in the container. Rules can be derived f=
rom platform dependencies or metadata. Notice that user can disable pla=
tform specific constrains by defining IMSM_NO_PLATFORM environment vari=
able.
>

=46or the 'platform' case we could automate some decisions, but I think
I would rather extend the --detail-platform option to dump the
recommended/compatible DOMAIN entries for the platform, perhaps via
the --brief modifier.  This mirrors what can be done with --examine
--brief to generate an initial configuration file that can be modified
to taste.

>>
>> =A0 hotplug modes are:
>> =A0 =A0 none =A0- ignore any hotplugged device
>> =A0 =A0 incr =A0- normal incremental assembly (the default). =A0If t=
he device has
>> =A0 =A0 =A0 =A0 =A0metadata that matches an array, try to add it to =
the array
>> =A0 =A0 replace - If above fails and a device was recently removed f=
rom this
>> =A0 =A0 =A0 =A0 =A0same path, add this device to the same array(s) t=
hat the old
>> devices
>> =A0 =A0 =A0 =A0 =A0was part of
>> =A0 =A0 include - If the above fails and the device has not recognis=
able
>> metadata
>> =A0 =A0 =A0 =A0 =A0add it to any array/container that uses devices i=
n this domain,
>> =A0 =A0 =A0 =A0 =A0partitioning first if necessary.
>> =A0 =A0 force - as above but ignore any pre-existing metadata
>>
>>
>> =A0 I'm not sure that all those are needed, or are the best names. =A0=
Names
>> like
>> =A0 =A0 ignore, reattach, rebuild, rebuild_spare
>> =A0 have also been suggested.
>
> Please consider:
> =A0 =A0 =A0spare_add - add any spare device that matches the metadata=
 container/volume in case of native metadata regardless of array state,=
 so later such a spare can be used in rebuild process.

This is the same as 'incr' above.  If the device has metadata and
hotplug is enabled, auto-incorporate the device.

> Can we assume for all external metadata that spares added any contain=
er can be potentially moved between all container the same metadata?

Yes, that can be the default action, and the spare-group keyword can
be specified to override.

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

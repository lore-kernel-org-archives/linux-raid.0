From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: Autorebuild, new dynamic udev rules for hot-plugs
Date: Mon, 22 Nov 2010 16:11:41 -0800
Message-ID: <4CEB06BD.9090407@intel.com>
References: <A9DE54D0CD747C4CB06DCE5B6FA2246F010BAF0FAF@irsmsx504.ger.corp.intel.com>	<20101117212242.5ad7b210@notabene.brown>	<A9DE54D0CD747C4CB06DCE5B6FA2246F010BE8FD35@irsmsx504.ger.corp.intel.com>	<66C59AD0932712458090B447266D638C0109E0E1E7@irsmsx504.ger.corp.intel.com> <20101122160201.24ad85f8@notabene.brown>  <66C59AD0932712458090B447266D638C0109E6AE6C@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <66C59AD0932712458090B447266D638C0109E6AE6C@irsmsx504.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>
Cc: Neil Brown <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Czarnowska, Anna" <anna.czarnowska@intel.com>
List-Id: linux-raid.ids

On 11/22/2010 3:50 PM, Hawrylewicz Czarnowski, Przemyslaw wrote:
>> Four comments.
>>
>> 1/ I wouldn't write a file in /lib/udev/rules.d/
>>    I think it should be written to "/dev/.udev/rules.d/"
>>    which is referred to as the "temporary rules directory"
>>    in the udev documentation.
> I am not sure if it is what we are looking for. Temporary means they disappear after reboot. It is OK as cold-plug does not need support for bare disks (or maybe I am wrong?). But in such case, one who wants to use autorebuild should invoke mdadm --activate-domains for example in /etc/init.d/local.boot or somewhere else. Second idea here is to use ActivateDomain() when one starts monitor with autorebuild enabled. Which one? I would prefer to leave it as it was written initially (considering comment #4). Then, if one removes policies from config, invoking --activate-domains should reset/remove rules (but see #3)

The intent was always to have this be something reinitialized at boot. 
Putting these in the temporary rule directory also precludes them from 
being added to the initramfs where they are not needed / potentially 
confusing.

The other intent was to only match the pci paths for the controllers we 
cared about.  That does not appear to be a part of this patch.

>
>>
>> 2/ I would be good to process the type=disk or type=part part of the
>>     policy into the rules file as well.
> OK
>
>>
>> 3/ I'm not very comfortable with hard-coding the name of the
>>     file to be created in the rules.d directory.  Maybe usage could be
>>        --activate-domains=63-md-whatever
> Good idea, but only if we store our rules in /dev/.udev/rules.d. Otherwise it would be difficult to maintain all generated rules and remove the old ones... I would leave default if not given by user, but one can pass any file name.

The issue is that this namespace belongs to the distro and since they 
need to modify initscripts to turn this feature on might as well dump 
the entirety of the naming responsibility to the user.

>> 4/ I don't think it is good to have an incomplete file in rules.d that udev
>>     might accidentally read.  We should create the file with a name with a
>>     leading '.' (assuming udev ignores those, I haven't checked) and then
>>     rename it after it has been completely written.
> You're right. In theory, such partial udev rules are excluded when udev can't interpret them properly. I have looked into udev's sources and found that it looks for "*.rules" files. All other file extensions are ignored. Files with leading dots are also omitted. I would prefer to create<name>.temp file and then rename it into<name>.rules.

There must be an existing convention for this sort of the thing, if so 
let's not invent another one.

--
Dan

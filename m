From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [AUTOREBUILD 0/8] Autorebuild monitor patches based on user defined
 policy
Date: Mon, 18 Oct 2010 23:54:06 -0700
Message-ID: <4CBD408E.9030707@intel.com>
References: <905EDD02F158D948B186911EB64DB3D171D09950@irsmsx503.ger.corp.intel.com> <20101019114027.37d65a8c@notabene>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101019114027.37d65a8c@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "Labun, Marcin" <Marcin.Labun@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Czarnowska, Anna" <anna.czarnowska@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "dledford@redhat.com" <dledford@redhat.com>
List-Id: linux-raid.ids

On 10/18/2010 5:40 PM, Neil Brown wrote:
> On Fri, 1 Oct 2010 13:36:48 +0100
> "Labun, Marcin"<Marcin.Labun@intel.com>  wrote:
>
>> > From f423b226f10cfe3b416c5e0580dde45cd8ca887d Mon Sep 17 00:00:00 2001
>> From: Marcin Labun<marcin.labun@intel.com>
>> Date: Wed, 29 Sep 2010 06:12:38 +0200
>> Subject: [AUTOREBUILD 0/8] Autorebuild monitor patches based on user defined policy
>>
>> This is updated series of patches forming autorebuild functionality in mdadm
>> monitor based on new policy code.
>
> Hi Marcin,
>   thanks for this, and apologies for not replying sooner.
>   I've had a bit of a look and some of it seems good.
>   I haven't had a thorough look yet as I am in the middle of doing some fairly
>   serious refactoring of mdadm (the supertype, and mdinfo structures are going
>   to be heavily changed and largely merged - some super_switch methods will
>   disappear (e.g. getinfo_super) and others will appear (load_container)).
>   Once I have finished that I will review your code more thoroughly and merge
>   it into the new code base.
>
>   One concern I do have is patch 0002 which removes the spare-group based
>   spare migration.  That functionality needs to stay, though obviously the
>   implementation can change.  I imagine the 'spare-group' information would be
>   added to each member device as a 'domain' name.
>
>   Also it is best not to remove functionality and then re-add it a different
>   way, but rather to make sure the functionality works after every change, but
>   just gets extended at various points.

Hi Neil,

I made a similar comment on this patch during our internal review.  We 
also talked about the need for superswitch methods that can be used to 
1/ determine which devices in a container are spares versus stale disks 
2/ what the minimum size a bare disk needs to be to join a container. 
I'll wait to see if these items will be easier to determine with the new 
mdinfo/supertype refactoring.

Other notes:
The --activate-domains option [1] to validate the configuration file and 
install custom/filtered udev rules for the ports we care about, seemed 
like a good idea at the time.  Now that things are a bit further along 
do you have a better solution in mind or is this still the approach we 
want to take?  Przemek currently has a patch to filter all block device 
events through mdadm to query the configuration file for domain events 
which seems like overkill if not a performance problem for large disk 
count environments.

We also talked about migration, but I'll put those details in a separate 
thread.

Thanks,
Dan

[1]: http://marc.info/?l=linux-raid&m=127001124615043&w=2

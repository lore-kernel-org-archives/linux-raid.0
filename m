From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: More Hot Unplug/Plug work
Date: Fri, 30 Apr 2010 12:14:09 +0100
Message-ID: <4BDABB81.5080208@anonymous.org.uk>
References: <4BD714A3.9020801@redhat.com>	<905EDD02F158D948B186911EB64DB3D11C954788@irsmsx503.ger.corp.intel.com>	<4BD874CB.5040803@redhat.com>	<905EDD02F158D948B186911EB64DB3D11C95485F@irsmsx503.ger.corp.intel.com>	<4BD8A336.7080309@redhat.com> <20100429110153.7148bb9b@notabene.brown> <4BD8DEB1.40801@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BD8DEB1.40801@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Neil Brown <neilb@suse.de>, Doug Ledford <dledford@redhat.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>
List-Id: linux-raid.ids

On 29/04/2010 02:19, Dan Williams wrote:
> Neil Brown wrote:
>> I'm not sure how this fits with imposing platform constraints.
>> As platform constraints are closely tied to metadata types, it might 
>> be OK
>> to have a metadata-specific tags (imsm=???) and leave to details to the
>> metadata handler???
>>
>> Dan: help me understand these platform constraints: what is the most 
>> complex
>>   constraint that you can think of that you might want to impose?
> 
> At this point we really only need one constraint: prevent controller 
> spanning.  If for example I take an existing imsm member off of ahci and 
> reattach it via a usb-to-sata enclosure mdadm needs a policy to prevent 
> associating that drive with anything on ahci.
> 
> In a pinch this policy can be disabled, but you wouldn't want to rebuild 
> across usb or any other controller because the option-rom only talks 
> ahci and will mark the drive missing.
> 
> So something like DOMAIN spanning=imsm, to tell mdadm to follow imsm 
> rules for this domain.  Where 'spanning' is policy tag??

Why isn't DOMAIN path=pci-0000:00:1f.2-scsi-[012345]* enough? Can't 
arrays span multiple Intel/imsm controllers? And if I start off my array 
on one Intel/imsm controller, and I add another JBOD controller, 
shouldn't I be allowed to grow my array to span the two controllers
without rebuilding the array with new metadata? I know I can't expect 
the option ROM to cope with or boot off this array but would the option 
ROM in some manner damage such an array?

Cheers,

John.

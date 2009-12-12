From: Asdo <asdo@shiftmail.org>
Subject: Re: [patch 1/1] [mdadm] Add partition checks when creating a new array
Date: Sat, 12 Dec 2009 23:50:16 +0100
Message-ID: <4B241E28.8060706@shiftmail.org>
References: <EB332302649177439359CE520D92A0AF9F559760@irsmsx503.ger.corp.intel.com>
 <19196.51508.947560.851117@notabene.brown>
 <20091120170350.GA20882@maude.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <20091120170350.GA20882@maude.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>, "Trela, Maciej" <Maciej.Trela@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, Ciecha
List-Id: linux-raid.ids

Luca Berra wrote:
> On Fri, Nov 13, 2009 at 01:49:24PM +1100, Neil Brown wrote:
>> Is there a good library that we could use?
>> libparted might be a possibility, but it seems rather over-weight.
>> /lib/libparted-1.9.so.12.0.0 is larger than /sbin/mdadm !!!
>>
>> Are there any other libraries for reading different partition tables?
>> I guess we can open-code it if we have to but I'd be happy if another
>> solution could be found.
>
> i don't think so,
> but there are two tools
> partx from util-linux
> kpartix from multipath-tools (which is based on the former)
>
> so we could either grab code from those or just invoke
> partx -l (i believe every distro installs util-linux by default)
>
> L.

I'm probably missing something obvious but...
why don't you use the kernel directly to detect if there are partitions
on the device?

Like if the user wants to make a raid on /dev/sdg but the device
/dev/sdg1 exists, that's a problem, you fail the creation. (*)

This would support all the partition types that the kernel supports.

Probing the partitions on the disks and adding them to /dev/sd?N is done
automatically in all recent distributions even for hotpluggable devices 
so it's quite guaranteed that it would work

(*) Are there other situations that would overwrite a partition?


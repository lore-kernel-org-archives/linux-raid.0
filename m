From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: md extension to support booting from raid whole disks.
Date: Tue, 05 May 2009 01:26:11 +0100
Message-ID: <49FF87A3.4000707@anonymous.org.uk>
References: <49F68CE0.2010906@zytor.com>	 <e9c3a7c20904281124g4682d70cp22760176e7a8cfbc@mail.gmail.com>	 <1240957153.18303.689.camel@ezra>	 <18935.35747.471257.202356@notabene.brown> <49F78F26.2040909@zytor.com>	 <1240963225.18303.858.camel@ezra> <49F7997C.2070808@zytor.com>	 <1240964410.18303.895.camel@ezra> <49F79F26.9060309@zytor.com>	 <1240965831.18303.944.camel@ezra>	 <20090429064333.GB9372@boogie.lpds.sztaki.hu>	 <87hc04leau.fsf@frosties.localdomain>	 <1241217394.4418.4.camel@poledra.romunt.nl>	 <87presxwu4.fsf@frosties.localdomain>	 <1241219902.9516.6.camel@poledra.romunt.nl>	 <87bpq8n6ym.fsf@frosties.localdomain>	 <1241470631.25901.130.camel@poledra.romunt.nl> <1241476412.11754.118.camel@ezra>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1241476412.11754.118.camel@ezra>
Sender: linux-raid-owner@vger.kernel.org
To: Daniel Reurich <daniel@centurion.net.nz>
Cc: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 04/05/2009 23:33, Daniel Reurich wrote:
> I'd like to someone tell me how to get a partitioned scenario where the
> partition that starts right at the start of the disk and includes the
> bootsector, so that we raid1 that partition and have the bootsector
> replicated as well?

I'm sure there are hooks to allow automatic rebuilding of arrays when 
drives fail and are replaced. I don't know what they are (hotplug?), or 
whether they're used in any current distros. I do know some people have 
this automatic rebuilding; for example Netgear (ex Infrant) ReadyNAS 
devices, which are Linux based and use md RAID, do this. It can't be 
such a big leap to use such a hook to reinstate the boot sector at the 
same time as reinstating RAID metadata amd resyncing the array(s). Maybe 
current distros don't automatically do this because it only works if the 
user/OEM understands the particular case.

I don't believe it can't be done using the existing partition table and 
md RAID-1 /boot arrangements, and it would be great if we (and more 
distros) had suitable scripts available, but I suspect it's impossible 
to generalise for all RAID'ed installations.

Cheers,

John.


From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: md extension to support booting from raid whole disks.
Date: Tue, 5 May 2009 11:03:55 +0200
Message-ID: <20090505090355.GB26772@rap.rap.dk>
References: <1240965831.18303.944.camel@ezra> <20090429064333.GB9372@boogie.lpds.sztaki.hu> <87hc04leau.fsf@frosties.localdomain> <1241217394.4418.4.camel@poledra.romunt.nl> <87presxwu4.fsf@frosties.localdomain> <1241219902.9516.6.camel@poledra.romunt.nl> <87bpq8n6ym.fsf@frosties.localdomain> <1241470631.25901.130.camel@poledra.romunt.nl> <1241476412.11754.118.camel@ezra> <49FF87A3.4000707@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <49FF87A3.4000707@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: Daniel Reurich <daniel@centurion.net.nz>, Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, May 05, 2009 at 01:26:11AM +0100, John Robinson wrote:
> On 04/05/2009 23:33, Daniel Reurich wrote:
>> I'd like to someone tell me how to get a partitioned scenario where the
>> partition that starts right at the start of the disk and includes the
>> bootsector, so that we raid1 that partition and have the bootsector
>> replicated as well?
>
> I'm sure there are hooks to allow automatic rebuilding of arrays when  
> drives fail and are replaced. I don't know what they are (hotplug?), or  
> whether they're used in any current distros. I do know some people have  
> this automatic rebuilding; for example Netgear (ex Infrant) ReadyNAS  
> devices, which are Linux based and use md RAID, do this. It can't be  
> such a big leap to use such a hook to reinstate the boot sector at the  
> same time as reinstating RAID metadata amd resyncing the array(s). Maybe  
> current distros don't automatically do this because it only works if the  
> user/OEM understands the particular case.
>
> I don't believe it can't be done using the existing partition table and  
> md RAID-1 /boot arrangements, and it would be great if we (and more  
> distros) had suitable scripts available, but I suspect it's impossible  
> to generalise for all RAID'ed installations.

Hmm, what are you motivation for this?

I think that you can make a much automated disk partitioning scheme,
in the tune of the following:

You want to have multiple partitions on your disks.
Like /boot, /root, /home etc.

This is because you can only boot off a raid1, and raid1 is relatively
slow, so you want to minimize the use of raid1, eg to just the boot
partition. The rest of the partitions can then be the more io-effective
raid10,f2, or space effective raid5 (or raid6). 

You do not boot from MBR, but rather from the partition marked as
active.

Then make your partition scheme, and copy the whole scheme via eg

  sfdisk -d /dev/sda | sfdisk /dev/sdb

Then when you update your system, either by lilo or grub, you only need
to make the change once, and it will apply to all of the raids that
/boot and /root are located on.

This is further described in
http://linux-raid.osdl.org/index.php/Preventing_against_a_failing_disk

best regards
keld

From: G <garboge@shaw.ca>
Subject: Re: Setup Recommendation on UEFI/GRUB/RAID1/LVM
Date: Thu, 16 Apr 2020 11:00:45 -0600
Message-ID: <1142669d-1cda-b637-86d5-ddc0bee1497a@shaw.ca>
References: <fc12df3c-aac9-4aa8-a596-f13225161e22@peter-speer.de>
 <f9f2f479-2899-6774-eb20-bf81ed24bc7b@shaw.ca>
 <f857fc03-d18b-a489-54c9-49c22ad19c39@thelounge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f857fc03-d18b-a489-54c9-49c22ad19c39@thelounge.net>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Reindl Harald <h.reindl@thelounge.net>, Stefanie Leisestreichler <stefanie.leisestreichler@peter-speer.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2020-04-14 10:20 a.m., Reindl Harald wrote:
>
> Am 14.04.20 um 18:00 schrieb G:
>> Since you are running disks less than 2TB I would suggest a more
>> rudimentary setup using legacy bios booting. This setup will not allow
>> disks greater than 2TB because they would not be partitioned GPT. There
>> would still be an ability to increase total storage using more disks.
>> There would be raid redundancy with the ability for grub to boot off
>> either disk.
> terrible idea in 2020
>
> Intel announced yeas ago that they itend to remove legacy bios booting
> in 2020 and even if it#s just in 2022: RAID machines are supposed to
> live many many years and you just move the disks to your next machine
> and boot as yesterday
>
> i argued like you in 2011 and now i have a 4x2 TB RAID10 and need to
> deal with EFI-partition on a USB stick with the replacement as soon as
> there are icelake or never serious desktop machines because there is no
> single reason to reinstall from scratch when you survived already 17
> fedora dist-upgrades
>
I guess my assumptions were that in using 2TB disks this was or would be 
a relatively short-lived/limited situation possibly using an older 
motherboard. ;-)

Since the setup will be grub/UEFI on the 2TB disks what would be the 
process in upgrading to larger disks?

Thanks

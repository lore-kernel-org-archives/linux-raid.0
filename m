From: "Joe Landman" <joe.landman@gmail.com>
Subject: Re: question on how to (correctly) build an initrd for a root disk on a RAID1
Date: Sun, 26 Oct 2008 23:26:09 -0400
Message-ID: <9f5edc120810262026q4a7bd9f7ra1dd845522a0f766@mail.gmail.com>
References: <9f5edc120810261937w339f2919p4f7ce82fbcaf2149@mail.gmail.com>
	 <49053400.5080704@maine.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49053400.5080704@maine.edu>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Steve Cousins <steve.cousins@maine.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Oct 26, 2008 at 11:22 PM, Steve Cousins <steve.cousins@maine.edu> wrote:
> Joe Landman wrote:
>>
>> Hi folks:
>>
>>  We have been trying to build an operational initrd for a root drive
>> on  software RAID1.
>>
>>  Basic specs:   2.6.23.14 kernel (though same issues with 2.6.27.2
>> kernel), on Centos 5.2, pair of SATA drives using libata and other
>> drivers, x86_64 architecture.
>>
>>  Using mkinitrd --with=raid1 --with=libata --with=sd_mod ...
>>
>>  I am getting a kernel panic on switchroot, it can't find the root
>> file system.
>
> Hi Joe,
>
> What does the "root=" kernel parameter look like in your grub.conf (are you
> using grub?)? Mine looks like root=/dev/md2. My md0 is the boot partition

Hi Steve:

  root=/dev/md2

and the boot device is (hd0,0).



Joe

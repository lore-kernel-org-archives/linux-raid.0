From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: kernel panic (2.6.23.1-fc7) in drivers/md/raid5.c:144
Date: Tue, 13 Nov 2007 12:44:47 -0700
Message-ID: <e9c3a7c20711131144jc809b29y38a9bba9cfa2cc07@mail.gmail.com>
References: <880130.25278.qm@web52803.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <880130.25278.qm@web52803.mail.re2.yahoo.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Peter <thenephilim13@yahoo.com>
Cc: linux-raid@vger.kernel.org, stable@vger.kernel.org, gregkh@suse.de, Neil Brown <neilb@suse.de>, davej@redhat.com
List-Id: linux-raid.ids

[ Adding Neil, stable@, DaveJ, and GregKH to the cc ]

On Nov 13, 2007 11:20 AM, Peter <thenephilim13@yahoo.com> wrote:
> Hi
>
> I had a 3 disc raid5 array running fine with Fedora 7 (32bit) kernel 2.6.23.1-fc7 on an old Athlon XP using a two sata_sil cards.
>
> I replaced the hardware with an Athlon64 X2 and using the onboard sata_nv, after I modified the initrd I was able to boot up from my old system drive. However when it brought up the raid array it died with a kernel panic. I used a rescue CD, commented out the array in mdadm.conf and booted up. I could assemble the array manually (it kicked out one of the three drives for some reason?) but when I used mdadm --examine /dev/md0 I got the kernel panic again. I don't have remote debugging but I managed to take some pictures:
>
> http://img132.imageshack.us/img132/1697/kernel1sh3.jpg
> http://img132.imageshack.us/img132/3538/kernel2eu2.jpg
>
> From what I understand it should be possible to do this hardware upgrade with using software raid? Any ideas?
>
> Thanks
> Peter
>

There are two bug fix patches pending for 2.6.23.2:
"raid5: fix clearing of biofill operations"
http://marc.info/?l=linux-raid&m=119303750132068&w=2
"raid5: fix unending write sequence"
http://marc.info/?l=linux-raid&m=119453934805607&w=2

You are hitting the bug that was fixed by: "raid5: fix clearing of
biofill operations"

Heads up for the stable@ team "raid5: fix clearing of biofill
operations" was originally misapplied for 2.6.24-rc:
"md: Fix misapplied patch in raid5.c"
http://marc.info/?l=linux-raid&m=119396783332081&w=2

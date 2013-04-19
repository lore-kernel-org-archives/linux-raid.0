From: Alexander Zvyagin <zvyagin.alexander@gmail.com>
Subject: Re: RAID50 boot problems
Date: Fri, 19 Apr 2013 11:40:23 +0200
Message-ID: <CAGqvA+v8UUYGwzbnrra8bM3UncReH9vtdRwUbcGJRBX_vvFRyA@mail.gmail.com>
References: <CAGqvA+t8Nr7D6h35ZKVi5Wa0tF46TQHK_Af_mXO2=ByRjWRQag@mail.gmail.com>
 <CAGqvA+sui=5R7+agbrJgHTQpm+1e9PVZ_MskjO3RTWq+LcAdnQ@mail.gmail.com> <CAGA4a+GQp1RV_1pA6PBP=dbXV3MHhU74=Mo24xqqjKfWfoWXJA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGA4a+GQp1RV_1pA6PBP=dbXV3MHhU74=Mo24xqqjKfWfoWXJA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tommy Apel <tommyapeldk@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

yes, I can do that. But I thought that mdadm should be able to
assemble my raid50 without any help from my side.

Let me rephrase the question. My raid50 system does not boot because ....
- I miss something in mdadm configuration
- mdadm cannot assemble (by itself) raid50 arrays (which is hard to believe)
- there is a bug somewhere

With best wishes,
Alexander Zvyagin.


On 17 April 2013 21:08, Tommy Apel <tommyapeldk@gmail.com> wrote:
> unpack you initfs and make the changes to the init file and pack it again.
>
> /Tommy
>
>
> 2013/4/17 Alexander Zvyagin <zvyagin.alexander@gmail.com>
>>
>> Hi,
>>
>> I have almost working RAID50 (two RAID5 forms RAID0) in my
>> Linux-mint13. When booting the system always ends up in initramfs
>> shell, saying it cannot find the "root". When I type "cat
>> /proc/mdstat" I see that both RAID5 are available, but they did not
>> form RAID0. So I do "mdadm -A --scan" to finish the raid creation.
>> After that I can exit the initramfs shell and system finishes booting
>> (and works later) without any problems. Of course initramfs image is
>> in sync with root (/etc/mdadm/mdadm.conf file is the same in initramfs
>> and rootfs).
>> This is what my system is using:
>> kernel 3.5.0-26-generic
>> mdadm - v3.2.5 - 18th May 2012
>>
>> To summarize, I have  RAID50 which _almost_ works. It just needs to be
>> pushed/kicked during the boot. Could you advise my how can I
>> automatize the process, so I do not need to type "mdadm -A
>> --scan;exit" every time I switch on my computer?
>>
>> Thanks a lot in advance,
>> Alexander.
>
>

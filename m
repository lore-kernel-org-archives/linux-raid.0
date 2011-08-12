From: mark delfman <markdelfman@googlemail.com>
Subject: Re: single cpu thread performance limit?
Date: Fri, 12 Aug 2011 14:23:06 +0100
Message-ID: <CAACGR8v87iw9qmtfsQTiUP8QWQEZPyryBc_zZwuD_DyUxgzN8Q@mail.gmail.com>
References: <CAACGR8sSieD1MLCEnY0Wv24pHd9xpcJ=mhduwGMCqo5A5ttZpw@mail.gmail.com>
	<4E44265D.3050809@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E44265D.3050809@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

Hi

Quick update with the XFS tests suggested (although a FS is still
probably not a real option at teh moment for me)

This rig only has 4 x Flash (2 MLC and 2 SLC).....  125K IOPS each for
MLC - 165K each for SLC.

Create linear RAID and XFS with ag=3D4

Mount as suggested and create 4 test folders.....

If i test individually - we get 99.9% of the IOPS (ie. 125 for first 2
AG's and 165 for last 2).  which is great news and means that the AG
does what it should.

But if a run the test over all 4, then we see it peak at aroudn 320K
IOPS.  Interstingly each AG =3D 80K IOPS and as we can see above this i=
s
need not be the case, as the CPU load is not having any issues - i am
presuming that this could be a simple XFS limit maybe.


More testing with many R1's and R0's on top seem to suggest that R0 is
losing around 20-25% of the IOPS.  (R1 around 5%).  I have tried with
LVM strip and much the same.






On Thu, Aug 11, 2011 at 7:58 PM, Stan Hoeppner <stan@hardwarefreak.com>=
 wrote:
> On 8/11/2011 10:58 AM, mark delfman wrote:
>> I seem to have hit a significant hard stop in MD RAID1/10 performanc=
e
>> which seems to be linked to a single CPU thread.
>
> What is the name of the kernel thread that is peaking your cores? =A0=
Could
> the device driver be eating the CPU and not the md kernel threads? =A0=
Is
> it both? =A0Is it a different thread? =A0How much CPU is the IO gener=
ator
> app eating?
>
> What Linux kernel version are you running? =A0Which Linux distributio=
n?
> What application are you using to generate the IO load? =A0Does it wo=
rk at
> the raw device/partition level or at the file level?
>
>> I am using extremely high speed (IOPS) internal block devices =96 8 =
in
>> total. =A0They are capable of achieving > 1million iops.
>
> 8 solid state drives of one model or another, probably occupying 8 PC=
Ie
> slots. =A0IBIS, VeloDrive, the LSI SSD, or other PCIe based SSD? =A0O=
r are
> these plain SATA II SSDs that *claim* to have 125K 4KB random IOPS
> performance?
>
>> However if I use RAID1 / 10 then MD seems to use a single thread whi=
ch
>> will reach 100% CPU utilisation (single core) at around 200K IOPS.
>> Limiting the entire performance to around 200K.
>
> CPU frequency? =A0How many sockets? =A0Total cores? =A0Whose box? =A0=
HP, Dell,
> IBM, whitebox, self built? =A0If the latter two, whose motherboard? =A0=
How
> many PCIe slots are occupied by the SSD cards?
>
>> If I use say 4 x RAID1 / 10=92s and a RAID0 on top =96 I see not muc=
h
>> greater results. (although the theory seems to say I should and ther=
e
>> are now 4 CPU threads running, it still seems to hit 4 x 100% at may=
be
>> 350K).
>
> Assuming you have 4 processors (cores), then yes, you should see bett=
er
> scaling. =A0If you have less cores than threads, then no. =A0Do you s=
ee more
> IOPS before running out of CPU when writing vs reading? =A0You should=
 as
> you're doing half the IOs when reading.
>
>> Is there any way to increase the number of threads per RAID set? Or
>> any other suggestions on configurations? =A0(I have tried every
>> permutation of R0+R1/10=92s)
>
> The answer to the first question AFAIK is no. =A0Do you have the same
> problem with a single --linear array? =A0What is the result when putt=
ing a
> filesystem on each individual drive? =A0Do you get your 1 million IOP=
S?
>
> Is MSI enabled and verified to be working for each PCIe SSD device? =A0=
See:
>
> http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.git;a=3D=
blob;f=3DDocumentation/PCI/MSI-HOWTO.txt;hb=3DHEAD
>
> --
> Stan
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

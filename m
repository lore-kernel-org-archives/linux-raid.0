From: mark delfman <markdelfman@googlemail.com>
Subject: Re: single cpu thread performance limit?
Date: Thu, 11 Aug 2011 20:37:46 +0100
Message-ID: <CAACGR8to9iybX+fJ_CGYBFgR6XtgPoqCt8kFA4mpqo4d1jEMqw@mail.gmail.com>
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

Hi... sorry for the lack of initial info and your question  made me
realise how much i had missed off! hopefully this adds some color

PCIe based Flash - SLC based
Multuiple XEON 5640's  (total 16 cores)
MSI ints all set (and affinity / pinned tried)
SLES 11 (2.6.32.43-0.5)
tried on both a Supermicro and and Dell R server

the thread is MD0_RAID10 (or something simular as i am not near it now)=
=2E
This thread is easily linked to the MD(s)
Create 4 x RAID1's and you have 4 x MD threads etc.

So, a single RAID10 creates a single thread - which will max at maybe 2=
00K IOPS.
Create 4 x RAID10's seems OK, but they will not scale so great with a
RAID0 on top :(
Ideal would be a few threads per RAIDx


Using basic fio for IOPS (4 workers - 128 QD) - this usess hardly any
CPU resource.
Reads are maybe 50% faster as you would expect.

The issue seems to be the fact a single thread will only deliver X
before 100% CPU... with emerging flash, this is not reaching the
capability

=46S:  An FS is not really an option for this solution, so we have not
tried this on this rig, but in the past the FS has degreaded the IOPS

Whilst a R0 on top of the R1/10's does offer some increase in
performance, linear does not :(
LVM R0 on top of the MD R1/10's does much the same results.
The limiter seems fixes on the single thread per R1/10


Thank you for any feedback!

Mark



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

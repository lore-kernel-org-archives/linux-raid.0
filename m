From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: single cpu thread performance limit?
Date: Thu, 11 Aug 2011 13:58:37 -0500
Message-ID: <4E44265D.3050809@hardwarefreak.com>
References: <CAACGR8sSieD1MLCEnY0Wv24pHd9xpcJ=mhduwGMCqo5A5ttZpw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAACGR8sSieD1MLCEnY0Wv24pHd9xpcJ=mhduwGMCqo5A5ttZpw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: mark delfman <markdelfman@googlemail.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

On 8/11/2011 10:58 AM, mark delfman wrote:
> I seem to have hit a significant hard stop in MD RAID1/10 performance
> which seems to be linked to a single CPU thread.

What is the name of the kernel thread that is peaking your cores?  Coul=
d
the device driver be eating the CPU and not the md kernel threads?  Is
it both?  Is it a different thread?  How much CPU is the IO generator
app eating?

What Linux kernel version are you running?  Which Linux distribution?
What application are you using to generate the IO load?  Does it work a=
t
the raw device/partition level or at the file level?

> I am using extremely high speed (IOPS) internal block devices =96 8 i=
n
> total.  They are capable of achieving > 1million iops.

8 solid state drives of one model or another, probably occupying 8 PCIe
slots.  IBIS, VeloDrive, the LSI SSD, or other PCIe based SSD?  Or are
these plain SATA II SSDs that *claim* to have 125K 4KB random IOPS
performance?

> However if I use RAID1 / 10 then MD seems to use a single thread whic=
h
> will reach 100% CPU utilisation (single core) at around 200K IOPS.
> Limiting the entire performance to around 200K.

CPU frequency?  How many sockets?  Total cores?  Whose box?  HP, Dell,
IBM, whitebox, self built?  If the latter two, whose motherboard?  How
many PCIe slots are occupied by the SSD cards?

> If I use say 4 x RAID1 / 10=92s and a RAID0 on top =96 I see not much
> greater results. (although the theory seems to say I should and there
> are now 4 CPU threads running, it still seems to hit 4 x 100% at mayb=
e
> 350K).

Assuming you have 4 processors (cores), then yes, you should see better
scaling.  If you have less cores than threads, then no.  Do you see mor=
e
IOPS before running out of CPU when writing vs reading?  You should as
you're doing half the IOs when reading.

> Is there any way to increase the number of threads per RAID set? Or
> any other suggestions on configurations?  (I have tried every
> permutation of R0+R1/10=92s)

The answer to the first question AFAIK is no.  Do you have the same
problem with a single --linear array?  What is the result when putting =
a
filesystem on each individual drive?  Do you get your 1 million IOPS?

Is MSI enabled and verified to be working for each PCIe SSD device?  Se=
e:

http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.git;a=3D=
blob;f=3DDocumentation/PCI/MSI-HOWTO.txt;hb=3DHEAD

--=20
Stan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

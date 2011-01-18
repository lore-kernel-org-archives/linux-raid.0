From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: Optimize RAID0 for max IOPS?
Date: Tue, 18 Jan 2011 20:18:50 -0200
Message-ID: <AANLkTimzwgg_Htj4rMxjdjhMQHExeWOqzd5Puu9KbXug@mail.gmail.com>
References: <20110118210112.D13A236C@gemini.denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110118210112.D13A236C@gemini.denx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Wolfgang Denk <wd@denx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

it=B4s a interesting question, i don=B4t know what the best too
but...
i didn=B4t create a partition of a /dev/mdxxx device yet (linux 2.6.29)=
,
maybe it=B4s not possible

try partitioning all hard drives and make many paritions and make raid
on each one
another way could be a lvm over mdxxx and try to partition it (can lvm
be partitioned?)

another optimization is per disk elevator (at linux level) at /sys/
you can find it (try find -iname elevator, or find -iname scheduler, i
don=B4t remember the file name)

linux raid0 have a nice read/write algorithm for hard disks (i think)
test it
the best solution is no partition (since md will be made in disk, and
not on partition, this make disk head position more real than by
partition, making read_balance algorithm better)

2011/1/18 Wolfgang Denk <wd@denx.de>:
> Hi,
>
> I'm going to replace a h/w based RAID system (3ware 9650SE) by a plai=
n
> s/w RAID0, because the existing system appears to be seriously limite=
d
> in terms of numbers of I/O operations per second.
>
> Our workload is mixed read / write (something between 80% read / 20%
> write and 50% / 50%), consisting of a very large number of usually
> very small files.
>
> There may be 20...50 millions of files, or more. 65% of the files are
> smaller than 4 kB; 80% are smaller than 8 kB; 90% are smaller than 16
> kB; 98.4% are smaller than 64 kB.
>
> I will have 4 x 1 TB disks for this setup.
>
> The plan is to build a RAID0 from the 4 devices, create a physical
> volume and a volume group on the resulting /dev/md?, then create 2 or
> 3 logical volumes that will be used as XFS file systems.
>
> My goal is to optimize for maximum number of I/O operations per
> second. [I am aware that using SSDs would be a nice thing, but that
> would be too expensive.]
>
> Is this a reasonable approach for such a task?
>
> Should I do anything different to acchive maximum performance?
>
> What are the tunables in this setup? =A0[It seems the usual recipies =
are
> more oriented in maximizing the data troughput for large, mostly
> sequential accesses - I figure that things like increasing read-ahead
> etc. will not help me much here?]
>
> Thanks in advance.
>
> Best regards,
>
> Wolfgang Denk
>
> --
> DENX Software Engineering GmbH, =A0 =A0 MD: Wolfgang Denk & Detlev Zu=
ndel
> HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
> Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
> Quote from a recent meeting: =A0 "We are going to continue having the=
se
> meetings everyday until I find out why no work is getting done."
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

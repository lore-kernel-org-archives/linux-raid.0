From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: Optimize RAID0 for max IOPS?
Date: Tue, 18 Jan 2011 22:05:59 -0200
Message-ID: <AANLkTi=v6yA_0OOfi2ymA67X0x+KsvV9VC5OgG+0DvKq@mail.gmail.com>
References: <20110118210112.D13A236C@gemini.denx.de>
	<4D361F26.3060507@stud.tu-ilmenau.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D361F26.3060507@stud.tu-ilmenau.de>
Sender: linux-raid-owner@vger.kernel.org
To: stefan.huebner@stud.tu-ilmenau.de
Cc: Wolfgang Denk <wd@denx.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

maybe removing hwraid and using swraid may reduce speed (depend how
much cpu you use with hw and with sw)
what we can optimize? less I/O per seconds making as much useful
read/write data on array, how? good read/write algorithms for raid.
(for each device type, ssd, hd) but... like stefan, disks are your
bottleneck

2011/1/18 Stefan /*St0fF*/ H=FCbner <stefan.huebner@stud.tu-ilmenau.de>=
:
> Hi,
>
> [in German:] Sch=E4tzelein, Dein Problem sind die Platten, nicht der
> Controller.
>
> [in English:] Dude, the disks are your bottleneck.
>
> On a 4-disk RAID0 software RAID can only outspeed this 3ware Controll=
er
> with a really really fast processor. =A0The limiting factor is the di=
sk's
> access time. =A0If SSDs are too expensive, then your actual performan=
ce is
> the max you'll get (maybe to replace the HWRAID controller might give=
 a
> little speed-up, but not very much).
>
> All the best,
> Stefan
>
> Am 18.01.2011 22:01, schrieb Wolfgang Denk:
>> Hi,
>>
>> I'm going to replace a h/w based RAID system (3ware 9650SE) by a pla=
in
>> s/w RAID0, because the existing system appears to be seriously limit=
ed
>> in terms of numbers of I/O operations per second.
>>
>> Our workload is mixed read / write (something between 80% read / 20%
>> write and 50% / 50%), consisting of a very large number of usually
>> very small files.
>>
>> There may be 20...50 millions of files, or more. 65% of the files ar=
e
>> smaller than 4 kB; 80% are smaller than 8 kB; 90% are smaller than 1=
6
>> kB; 98.4% are smaller than 64 kB.
>>
>> I will have 4 x 1 TB disks for this setup.
>>
>> The plan is to build a RAID0 from the 4 devices, create a physical
>> volume and a volume group on the resulting /dev/md?, then create 2 o=
r
>> 3 logical volumes that will be used as XFS file systems.
>>
>> My goal is to optimize for maximum number of I/O operations per
>> second. [I am aware that using SSDs would be a nice thing, but that
>> would be too expensive.]
>>
>> Is this a reasonable approach for such a task?
>>
>> Should I do anything different to acchive maximum performance?
>>
>> What are the tunables in this setup? =A0[It seems the usual recipies=
 are
>> more oriented in maximizing the data troughput for large, mostly
>> sequential accesses - I figure that things like increasing read-ahea=
d
>> etc. will not help me much here?]
>>
>> Thanks in advance.
>>
>> Best regards,
>>
>> Wolfgang Denk
>>
>
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

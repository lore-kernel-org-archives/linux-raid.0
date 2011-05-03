From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: Mirrored volume peformance questions
Date: Tue, 3 May 2011 16:52:07 -0300
Message-ID: <BANLkTikcVPQwFEancNbOkKvdHTwdHDb=XA@mail.gmail.com>
References: <96B30EF4F3E17749BCFF7F1816090EDA02DCE41A87@EX-SEA31-B.ant.amazon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <96B30EF4F3E17749BCFF7F1816090EDA02DCE41A87@EX-SEA31-B.ant.amazon.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Morad, Steve" <morad@amazon.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

2011/5/3 Morad, Steve <morad@amazon.com>:
> I have a few questions about volume mirroring performance implication=
s.
>
> 1. I'm looking for an optimal configuration to maximize read speed wh=
ile protecting the data from a disk failure (e.g. for an application th=
at primarily does reads). =A0For RAID 1, does the linux raid driver per=
form parallel read requests across all available disks? =A0If, for exam=
ple, I set up a RAID 1 volume with 4 disks, would the OS handle concurr=
ently reading (different) data from all 4 disks at the same time?

today read_balance algorithm is optimized for multi-thread
read algorithm preffer disk with minimal head distance (current block
- block that will be read)

you can unselect disks setting they as write-mostly

optimizations at raid1 aren=B4t for bigger sequencial read, they are fo=
r
multi-thread



> 2. Similarly, would a RAID10 configuration give me the same (or bette=
r) read behavior across these same disks, while providing twice the sto=
rage capacity of the above configuration?

in md world
raid1+ raid0 !=3D raid10

raid10 can use layouts
raid1 can=B4t

raid10 have diferent read_balance algorithms than raid1
raid10 with far layout is better optimized for sequencial read (it=B4s
like raid0 stripe)
raid10 with near/offset layoute are better optimized for multthread


> 3. Is the raid driver smart enough to keep track of underlying volume=
 performance history or queue lengths and make read requests appropriat=
ely? For example, if for some crazy reason a 10K disk was mirrored with=
 a 7K disk, would the OS make more read requests to the 10K disk than t=
o the 7K disk, or would read requests be equally distributed across bot=
h disks?

no
i made a new raid1.c algorithm for kernel 2.6.37, that you can change
this options, you will have 1% of speed improvement in a very high
workload of read (ok it=B4s not a lot but i tested three times (1 hour
non sequencial test) and 1% are seeing, it=B4s not a error of
benchmark), you can mix SSD and HD too

code is here:
http://www.spadim.com.br/raid1/


it=B4s not a md-team solution
it=B4s a patch, more information inside the file
to compile you must compile like anyother kernel module
make drivers/md/raid1 ....

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

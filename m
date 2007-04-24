From: "Leon Woestenberg" <leon.woestenberg@gmail.com>
Subject: Re: Multiple disk failure, but slot numbers are corrupt and preventing assembly.
Date: Tue, 24 Apr 2007 09:04:49 +0200
Message-ID: <c384c5ea0704240004r176372e1nb384c06e558dd1f@mail.gmail.com>
References: <c384c5ea0704231017i2fd01aceva845a2f61f0aae3@mail.gmail.com>
	 <462CF303.6030004@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <462CF303.6030004@dgreaves.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

On 4/23/07, David Greaves <david@dgreaves.com> wrote:
> There is some odd stuff in there:
>
> /dev/sda1:
> Active Devices : 4
> Working Devices : 4
> Failed Devices : 0
> Events : 0.115909229
>
> /dev/sdb1:
> Active Devices : 5
> Working Devices : 4
> Failed Devices : 1
> Events : 0.115909230
>
> /dev/sdc1:
> Active Devices : 8
> Working Devices : 8
> Failed Devices : 1
> Events : 0.115909230
>
> /dev/sdd1:
> Active Devices : 4
> Working Devices : 4
> Failed Devices : 0
> Events : 0.115909230
>
> but your event counts are consistent. It looks like corruption on 2 disks :(

Exactly.

> Or did you try some things?
>
We tried updating the superblocks. It did not help, there remains
corrupt data somehow:

[root@localhost ~]# mdadm --examine /dev/sdb1
/dev/sdb1:
[...]
     Number   Major   Minor   RaidDevice State
this -11221199   -1288577935    -1551230943    2035285809      faulty
active removed
[...]

[root@localhost ~]# mdadm --examine /dev/sdc1
/dev/sdc1:
[...]
     Number   Major   Minor   RaidDevice State
this 1038288281   293191225    29538921    -2128142983      faulty
active write-mostly
[...]

That seems exactly what mdadm barfs on:

[root@localhost ~]# mdadm -v --assemble --scan --config=/tmp/mdadm.conf --force
[...]
mdadm: no uptodate device for slot 1 of /dev/md0
mdadm: no uptodate device for slot 2 of /dev/md0
[...]

Regards,

Leon.

From: Sean Caron <scaron@umich.edu>
Subject: Re: Automatically start two-level mdadm RAID arrays (i.e. RAID 60) on boot?
Date: Thu, 15 Feb 2018 21:17:30 -0500
Message-ID: <CAA43vkW82nJXmwo7=HAhO+shx_Obak_tm7Vy0EKWW+HWW6brnw@mail.gmail.com>
References: <CAA43vkUG8LrMUjazeYFtGVKVuTvrYRPe-UcPb21r=xeYpctpmg@mail.gmail.com>
 <20180216020217.2a9c7690@natsu> <4ebbb6bf-70a9-fb85-1b9f-82850a187e47@turmel.org>
 <39e0bf6b-4280-590c-9d96-013c70d4e0a4@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <39e0bf6b-4280-590c-9d96-013c70d4e0a4@fnarfbargle.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <lists2009@fnarfbargle.com>, Sean Caron <scaron@umich.edu>
Cc: Phil Turmel <philip@turmel.org>, Roman Mamedov <rm@romanrm.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Feb 15, 2018 at 8:41 PM, Brad Campbell
<lists2009@fnarfbargle.com> wrote:
> On 16/02/18 05:51, Phil Turmel wrote:
>>
>>
>> No, it sounds like an old distro that isn't using udev and incremental
>> assembly.  I don't know of a solution.
>
>
> I use several of those (old distros that is). In the initramfs mdadm waits
> for the devices to become available, the starts the arrays in order as
> listed in the mdadm.conf. I've never had an issue failing to start a stacked
> array and I don't use incremental assembly.
>
> You do need to make sure they are listed in the correct order in the config
> file, but even mdadm --detail --scan seems to spit out the arrays in the
> correct order (or maybe I just get lucky).
>
> Brad
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Hi all,

Thanks for the responses. I should say I'm on Ubuntu 14.04 LTS right
now, mdadm 3.2.5ubuntu4.4, with a 3.13 Ubuntu kernel, but I've
observed this behavior since we started using nested mdadm arrays at
this site back in 2011 on kernel 2.6.X and some long-since-forgotten
older version of mdadm on Ubuntu 12. It's been a little while and my
experience is not as extensive as with Ubuntu but IIRC, I have had the
same problem on CentOS 6 and CentOS 7 with stock kernels on those
distros.

As it is now, we just populate /etc/mdadm/mdadm.conf ARRAY lines with
the output of mdadm --examine --scan after building all the RAID 6
strings and the top level RAID 0 container. This gives the result
where the RAID 0 containers are the last lines in the file, after all
the RAID 6 strings. For example, on a machine with RAID 6 strings
md0...4 and RAID 0 string md5 (containing md0...md4), we have
mdadm.conf contents like:

ARRAY /dev/md/3 metadata=1.2 UUID=4a3cf66a:68cf425a:e139582e:c5c2f782
name=nodename:3
ARRAY /dev/md/2 metadata=1.2 UUID=84def8a0:d866133b:fbb473f5:72230b88
name=nodename:2
ARRAY /dev/md/1 metadata=1.2 UUID=3f3a1b81:c38a008a:331eebd9:22fceef4
name=nodename:1
ARRAY /dev/md/0 metadata=1.2 UUID=02d98ae0:e03f1424:8fc7c8d6:9f8d65ef
name=nodename:0
ARRAY /dev/md/4 metadata=1.2 UUID=b0079313:e6837042:53743e3e:c0cbfc17
name=nodename:4
ARRAY /dev/md/5 metadata=1.2 UUID=daffa41a:5198c27c:e76bd140:95054619
name=nodename:5

It works in the sense that, all RAID 6 strings start automatically on
boot, and the RAID 0 string starts with no problems given manual
operator intervention, but the RAID 0 string will not start
automatically on boot after all the RAID 6 strings have come up. This
has been persistent behavior across many kernel revisions, mdadm
revisions, udev revisions and so on.

It's interesting that everyone has reported nested mdadm arrays
starting automatically. Is there something special in mdadm.conf to
enable this? I was starting to suspect mdadm only does a single pass
when trying to auto-start arrays, but everyone's reports make me
wonder if I'm just not configuring something quite right.

Best,

Sean

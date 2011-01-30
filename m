From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: Performance question, RAID5
Date: Sun, 30 Jan 2011 19:41:47 +0000
Message-ID: <AANLkTi=6UnGjDXdrM76-8_iW+1D6MC5fkGB-vhhYxUXu@mail.gmail.com>
References: <AANLkTimXp-vGP8fb2Y-2EiaGxj+H6UJ9DfjtYMVDhDri@mail.gmail.com>
	<AANLkTi=SbAM3BXxjH6Mvcn-Tw4b0FYyLjLFqSGuxY1fk@mail.gmail.com>
	<AANLkTik4MGS7V7ePBgbk+KW-FcBBV7MuYgB7n29RRXF=@mail.gmail.com>
	<20110130094444.68288b0e@natsu>
	<AANLkTi=jXwcEgRquKgsf5HQUA+AQdt8nHeHCUJYqdSbX@mail.gmail.com>
	<20110130171533.4c9e236b@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110130171533.4c9e236b@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: CoolCold <coolthecold@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 30 January 2011 12:15, Roman Mamedov <rm@romanrm.ru> wrote:
> On Sun, 30 Jan 2011 12:09:02 +0000
> Mathias Bur=C3=A9n <mathias.buren@gmail.com> wrote:
>
>> Right, it's just that I don't want to destroy my data. I've ran a fe=
w
>> bonnie++ benchmarks with different mount options though. You can fin=
d
>> them here: http://stuff.dyndns.org/logs/bonnie_results.html
>> It actually looks like stripe=3D384 helped performance a bit. Curren=
tly
>> retrying the same mount options but with 32MB stripe cache instead o=
f
>> 8MB.
>
> Be aware that it's not just 32MB of RAM, it's
>
> =C2=A0"stripe_cache_size * 4096 (page size) * number of disks".
>
> In other words on 6 disks this stripe cache will consume 768 MB of RA=
M.
>
> --
> With respect,
> Roman
>

Thanks. New results up for those interested:
http://stuff.dyndns.org/logs/bonnie_results.html

It looks like the best performance (for me) is gained using
rw,noatime,nouser_xattr,data=3Dwriteback,stripe=3D384 , 8192
stripe_cache_size, NCQ turned on (31), md0 readahead of 65536. I did
switch place between the SSD and a HDD so there's only 2 HDDs on the
PCI-E controller now, that are part of the RAID. The other 4 are on
the internal SATA controller.

csv format:

"Host","Chunk size","Sequential Output",,,,,,"Sequential
Input",,,,"Random Seeks",,"Files","Sequential Create",,,,,,"Random
Create",,,,,,"Mount options","stripe_cache_size","NCQ","md0
readahead","Comment"
,,"Per Chr",,"Block",,"Rewrite",,"Per
Chr",,"Block",,"Seeks",,,"Create",,"Read",,"Delete",,"Create",,"Read",,=
"Delete",,,,,,
,,"K/sec","CPU","K/sec","CPU","K/sec","CPU","K/sec","CPU","K/sec","CPU"=
,"/sec","CPU",,"/sec","CPU","/sec","CPU","/sec","CPU","/sec","CPU","/se=
c","CPU","/sec","CPU",,,,,
"ion","7G",13916,98,158905,91,71718,39,14539,99,295079,57,482.8,3,16,20=
747,99,"+++++","+++",24077,93,21249,99,"+++++","+++",25854,99,"rw,noati=
me,nouser_xattr,data=3Dwriteback,stripe=3D384",8192,31,65536,"4
on host 2 on pci-e"

A bit messy.

I did find another PCI-E SATA controller that is generation 2.0, and
looks like it may do the trick. This one:
http://www.newegg.com/Product/Product.aspx?Item=3DN82E16816115053
"HighPoint RocketRAID 2640x1 PCI-Express x1 Four-Port SATA and SAS
RAID Controller Card".

It's ~=E2=82=AC110 on eBay, a bit hefty. I might just save up and build=
 a NAS
box from scratch, with some mainboard which has 8 SATA from the start
etc.

// Mathias
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

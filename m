From: =?ISO-8859-15?Q?Stefan_/*St0fF*/_H=FCbner?=
	<stefan.huebner@stud.tu-ilmenau.de>
Subject: Re: How to boost performance
Date: Thu, 17 Jun 2010 18:44:42 +0200
Message-ID: <4C1A50FA.50504@stud.tu-ilmenau.de>
References: <ea83c7a1ddca01e0a1535f130502a0f2.squirrel@www.dcsnow.com>	<20100617100109.32a20ffa@natsu>	<d98b7022efc6988e47f7e4114aa83f62.squirrel@www.dcsnow.com> <20100617221300.3e30afe0@natsu>
Reply-To: st0ff@npl.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100617221300.3e30afe0@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <roman@rm.pp.ru>
Cc: aragonx@dcsnow.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Actually, you have not said a word about which controllers you use (for
the drives).  Using the wrong controller can drain speed a lot.  As from
the kernel benchmarks it seems like neither RAM nor computing power are
the bottlenecks.

Some SATA-controllers handle "nearly parallel" writes to multiple drives
better than others.  SiI products for example have a noticeable drop-off
for each disk you add.  Pretty late Intels nearly show no impact of many
disks in parallel.  So maybe that could be the topic you should be
after.  (And maybe a lspci could help :)

Stefan

Am 17.06.2010 18:13, schrieb Roman Mamedov:
> On Thu, 17 Jun 2010 09:49:42 -0400
> aragonx@dcsnow.com wrote:
> 
>> Prior to the change above, on a 2GB file, I would start off the write (to
>> the server) at 70MB/sec and end at about 35MB/sec.  CPU usage was at 100%
>> with the md0 using about 70% CPU and smb using 30% with flush sometimes
>> jumping in at 30%.  Wait states remained below 10%.  After the change, on
>> a 2GB file I would start the write at 70MB/sec and end about 55MB/sec
>> (nice improvement!).
> 
> A more consistent way to test would be to cd into a directory on the array,
> and repeatedly run something like:
> 
> dd if=/dev/zero of=zerofile bs=1M count=2048 conv=fdatasync,notrunc
> 
> ...and implement various tweaks you are trying out between the runs, to see
> their effect.
> 
> Also, the reason you see the write speed dropping off in the end, is because
> your server first fills up its write cache almost at the maximum
> attainable sender's (and network) speed, then, as the space in RAM for that
> cache runs out, starts flushing it to disk, reducing the rate at which it
> receives new data from the network. So you see that the 70 MB/sec figure is
> totally unrelated to the RAID's performance. The dd test described above,
> thanks to these "conv" flags (see the dd man page) will have much more sense
> as a benchmark.
> 


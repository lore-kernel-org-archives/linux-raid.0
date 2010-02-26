From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: Pushing desktop boards to the MAX: Intel 10GbE AT2 Server
	Adapters!
Date: Thu, 25 Feb 2010 20:03:41 -0800
Message-ID: <4877c76c1002252003h615a8931iad9f8031fdf7c8a0@mail.gmail.com>
References: <alpine.DEB.2.00.1002251610060.8769@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1002251610060.8769@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-net@vger.kernel.org, Alan Piszcz <ap@solarrain.com>
List-Id: linux-raid.ids

On Thu, Feb 25, 2010 at 1:33 PM, Justin Piszcz <jpiszcz@lucidpixels.com=
> wrote:
> Hello,
>
> Both are running 2.6.33 x86_64:
>
> I have two desktop motheboards:
> 1. Intel DP55KG
> 2. A Gigabyte P35-DS4
>
> I have two 10GbE AT2 server adapters, configuration:
> 1. Intel DP55KG (15 Drive RAID-6) w/3ware 9650SE-16PML
> 2. Gigabyte P35-DS4 (softare RAID-5 across 8 disks)
>
> When I use iperf, I get ~9-10Gbps:
>
> Device eth3 [10.0.0.253] (1/1):
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
> Incoming: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 Outgoing:
> Curr: 1.10 MByte/s =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Curr: 1=
120.57 MByte/s
> Avg: 0.07 MByte/s =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 Avg: 66=
=2E20 MByte/s
> Min: 0.66 MByte/s =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 Min: 66=
6.95 MByte/s
> Max: 1.10 MByte/s =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 Max: 11=
20.57 MByte/s
> Ttl: 4.40 MByte =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 Ttl: =
4474.84 MByte
>
> p34:~# iperf -c 10.0.0.254
> ------------------------------------------------------------
> Client connecting to 10.0.0.254, TCP port 5001
> TCP window size: 27.4 KByte (default)
> ------------------------------------------------------------
> [ =A03] local 10.0.0.253 port 52791 connected with 10.0.0.254 port 50=
01
> [ ID] Interval =A0 =A0 =A0 Transfer =A0 =A0 Bandwidth
> [ =A03] =A00.0-10.0 sec =A010.9 GBytes =A09.39 Gbits/sec
> p34:~#
>
> When I copy a large file over NFS from Gigabyte (SW) raid to the Inte=
l
> motherboard, I get what the SW raid can read at, approximately: 560Mi=
B/s.
>
> Here is the file: (49GB)
> -rw-r--r-- 1 abc users 52046502432 2010-02-25 16:01 data.bkf
>
> From Gigabyte/SW RAID-5 =3D> Intel/HW RAID-6 (9650SE-16PML):
> $ /usr/bin/time cp /nfs/data.bkf .
> 0.04user 45.51system 1:47.07elapsed 42%CPU (0avgtext+0avgdata
> 7008maxresident)k
> 0inputs+0outputs (1major+489minor)pagefaults 0swaps
> =3D> Downloading 49000MB for 1.47 minutes is: 568889KB/s.
>
> However, from Intel/HW RAID-6 (9650SE-16PML) =3D> Gigabyte/SW RAID-5
> $ /usr/bin/time cp data.bkf /nfs
> 0.02user 31.54system 4:33.29elapsed 11%CPU (0avgtext+0avgdata
> 7008maxresident)k
> 0inputs+0outputs (0major+490minor)pagefaults 0swaps
> =3D> Downloading 49000MB for 4.33 minutes is: 193133KB/s.
>
> When running top, I could see md raid 5 and pdflush at or near 100% C=
PU.
> Is the problem scaling with mdadm/raid-5 on the Gigabyte motherboard?
>
> Gigabyte: 8GB Memory & Q6600
> Intel DP55KG: 8GB Memory & Core i7 870
>
> From the kernel:
> [ =A0 80.291618] ixgbe: eth3 NIC Link is Up 10 Gbps, Flow Control: RX=
/TX
>
> With XFS, it used to get > 400MiB/s for writes.
> With EXT4, only 200-300MiB/s:
>
> (On Gigabyte board)
> $ dd if=3D/dev/zero of=3Dbigfile bs=3D1M count=3D10240
> 10240+0 records in
> 10240+0 records out
> 10737418240 bytes (11 GB) copied, 38.6415 s, 278 MB/s
>
> Some more benchmarks (Gigabyte->Intel)
>
> ---- Connecting data socket to (10.0.0.254) port 51421
> ---- Data connection established
> ---> RETR CentOS-5.1-x86_64-bin-DVD.iso
> <--- 150-Accepted data connection
> <--- 150 4338530.0 kbytes to download
> ---- Got EOF on data connection
> ---- Closing data socket
> 4442654720 bytes transferred in 8 seconds (502.77M/s)
> lftp abc@10.0.0.254:/r/1/iso>
>
> CentOS DVD image in 8 seconds!
>
> rsync is much slower:
> $ rsync -avu --stats --progress /nfs/CentOS-5.1-x86_64-bin-DVD.iso =A0=
=2E
> sending incremental file list
> CentOS-5.1-x86_64-bin-DVD.iso
> =A04442654720 100% =A0234.90MB/s =A0 =A00:00:18 (xfer#1, to-check=3D0=
/1)
>
> I am using nobarrier, guess some more tweaking is required on the Gig=
abyte
> motherboard with software raid.
>
> For the future if anyone is wondering, the only tweak for the network
> configuration is setting the MTU to 9000 (jumbo frames, here is my en=
try for
> /etc/network/interfaces)
>
> # Intel 10GbE (PCI-e)
> auto eth3
> iface eth3 inet static
> address 10.0.0.253
> network 10.0.0.0
> netmask 255.255.255.0
> mtu 9000
>
> Congrats Intel for making a nice 10GbE CAT6a card without a fan!
>
> Thank you!
>
> Justin.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

On the system experiencing slower writing you might try altering the
stripe_cache_size value in to the corresponding sysfs directory.
/sys/block/md*/md/stripe_* There are various files in there which can
be used to tune the array.  You might also want to benchmark writing
to the array raw instead of via a filesystem, your mount options and
placement of any filesystem log could be forcing you to wait for flush
to disk; where the system with the hardware controller may be set to
wait for it to hit the card's buffer alone.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

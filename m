From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: md-RAID5/6 stripe_cache_size default value vs performance vs memory
 footprint
Date: Sat, 21 Dec 2013 05:18:42 -0600
Message-ID: <52B57912.5080000@hardwarefreak.com>
References: <52B102FF.8040404@pzystorm.de> <52B2FE9E.50307@hardwarefreak.com>	<52B41B67.9030308@pzystorm.de> <201312202343.47895.arekm@maven.pl>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201312202343.47895.arekm@maven.pl>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?QXJrYWRpdXN6IE1pxZtraWV3aWN6?= <arekm@maven.pl>
Cc: linux-raid@vger.kernel.org, "xfs@oss.sgi.com" <xfs@oss.sgi.com>
List-Id: linux-raid.ids

I renamed the subject as your question doesn't really apply to XFS, or
the OP, but to md-RAID.

On 12/20/2013 4:43 PM, Arkadiusz Mi=C5=9Bkiewicz wrote:

> I wonder why kernel is giving defaults that everyone repeatly recomme=
nds to=20
> change/increase? Has anyone tried to bugreport that for stripe_cache_=
size=20
> case?

The answer is balancing default md-RAID5/6 write performance against
kernel RAM consumption, with more weight given to the latter.  The form=
ula:

((4096*stripe_cache_size)*num_drives)=3D RAM consumed for stripe cache

High stripe_cache_size values will cause the kernel to eat non trivial
amounts of RAM for the stripe cache buffer.  This table demonstrates th=
e
effect today for typical RAID5/6 disk counts.

stripe_cache_size	drives	RAM consumed
256			 4	  4 MB
			 8	  8 MB
			16	 16 MB
512			 4	  8 MB
			 8	 16 MB
			16	 32 MB
1024			 4	 16 MB
			 8	 32 MB
			16	 64 MB
2048			 4	 32 MB
			 8	 64 MB
			16	128 MB
4096			 4	 64 MB
			 8	128 MB
			16	256 MB

The powers that be, Linus in particular, are not fond of default
settings that create a lot of kernel memory structures.  The default
md-RAID5/6 stripe_cache-size yields 1MB consumed per member device.

With SSDs becoming mainstream, and becoming ever faster, at some point
the md-RAID5/6 architecture will have to be redesigned because of the
memory footprint required for performance.  Currently the required size
of the stripe cache appears directly proportional to the aggregate writ=
e
throughput of the RAID devices.  Thus the optimal value will vary
greatly from one system to another depending on the throughput of the
drives.

=46or example, I assisted a user with 5x Intel SSDs back in January and
his system required 4096, or 80MB of RAM for stripe cache, to reach
maximum write throughput of the devices.  This yielded 600MB/s or 60%
greater throughput than 2048, or 40MB RAM for cache.  In his case 60MB
more RAM than the default was well worth the increase as the machine wa=
s
an iSCSI target server with 8GB RAM.

In the previous case with 5x rust RAID6 the 2048 value seemed optimal
(though not yet verified), requiring 40MB less RAM than the 5x Intel
SSDs.  For a 3 modern rust RAID5 the default of 256, or 3MB, is close t=
o
optimal but maybe a little low.  Consider that 256 has been the default
for a very long time, and was selected back when average drive
throughput was much much lower, as in 50MB/s or less, SSDs hadn't yet
been invented, and system memories were much smaller.

Due to the massive difference in throughput between rust and SSD, any
meaningful change in the default really requires new code to sniff out
what type of devices constitute the array, if that's possible, and it
probably isn't, and set a lowish default accordingly.  Again, SSDs
didn't exist when md-RAID was coded, nor when this default was set, and
this throws a big monkey wrench into these spokes.

--=20
Stan

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

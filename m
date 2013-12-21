From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: md-RAID5/6 stripe_cache_size default value vs performance vs
 memory footprint
Date: Sat, 21 Dec 2013 13:20:14 +0100
Message-ID: <20131221122014.GA3909@lazy.lzy>
References: <52B102FF.8040404@pzystorm.de>
 <52B2FE9E.50307@hardwarefreak.com>
 <52B41B67.9030308@pzystorm.de>
 <201312202343.47895.arekm@maven.pl>
 <52B57912.5080000@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <52B57912.5080000@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Arkadiusz =?utf-8?Q?Mi=C5=9Bkiewicz?= <arekm@maven.pl>, linux-raid@vger.kernel.org, "xfs@oss.sgi.com" <xfs@oss.sgi.com>
List-Id: linux-raid.ids

On Sat, Dec 21, 2013 at 05:18:42AM -0600, Stan Hoeppner wrote:
> I renamed the subject as your question doesn't really apply to XFS, o=
r
> the OP, but to md-RAID.
>=20
> On 12/20/2013 4:43 PM, Arkadiusz Mi=C5=9Bkiewicz wrote:
>=20
> > I wonder why kernel is giving defaults that everyone repeatly recom=
mends to=20
> > change/increase? Has anyone tried to bugreport that for stripe_cach=
e_size=20
> > case?
>=20
> The answer is balancing default md-RAID5/6 write performance against
> kernel RAM consumption, with more weight given to the latter.  The fo=
rmula:
>=20
> ((4096*stripe_cache_size)*num_drives)=3D RAM consumed for stripe cach=
e
>=20
> High stripe_cache_size values will cause the kernel to eat non trivia=
l
> amounts of RAM for the stripe cache buffer.  This table demonstrates =
the
> effect today for typical RAID5/6 disk counts.
>=20
> stripe_cache_size	drives	RAM consumed
> 256			 4	  4 MB
> 			 8	  8 MB
> 			16	 16 MB
> 512			 4	  8 MB
> 			 8	 16 MB
> 			16	 32 MB
> 1024			 4	 16 MB
> 			 8	 32 MB
> 			16	 64 MB
> 2048			 4	 32 MB
> 			 8	 64 MB
> 			16	128 MB
> 4096			 4	 64 MB
> 			 8	128 MB
> 			16	256 MB
>=20
> The powers that be, Linus in particular, are not fond of default
> settings that create a lot of kernel memory structures.  The default
> md-RAID5/6 stripe_cache-size yields 1MB consumed per member device.
>=20
> With SSDs becoming mainstream, and becoming ever faster, at some poin=
t
> the md-RAID5/6 architecture will have to be redesigned because of the
> memory footprint required for performance.  Currently the required si=
ze
> of the stripe cache appears directly proportional to the aggregate wr=
ite
> throughput of the RAID devices.  Thus the optimal value will vary
> greatly from one system to another depending on the throughput of the
> drives.
>=20
> For example, I assisted a user with 5x Intel SSDs back in January and
> his system required 4096, or 80MB of RAM for stripe cache, to reach
> maximum write throughput of the devices.  This yielded 600MB/s or 60%
> greater throughput than 2048, or 40MB RAM for cache.  In his case 60M=
B
> more RAM than the default was well worth the increase as the machine =
was
> an iSCSI target server with 8GB RAM.
>=20
> In the previous case with 5x rust RAID6 the 2048 value seemed optimal
> (though not yet verified), requiring 40MB less RAM than the 5x Intel
> SSDs.  For a 3 modern rust RAID5 the default of 256, or 3MB, is close=
 to
> optimal but maybe a little low.  Consider that 256 has been the defau=
lt
> for a very long time, and was selected back when average drive
> throughput was much much lower, as in 50MB/s or less, SSDs hadn't yet
> been invented, and system memories were much smaller.
>=20
> Due to the massive difference in throughput between rust and SSD, any
> meaningful change in the default really requires new code to sniff ou=
t
> what type of devices constitute the array, if that's possible, and it
> probably isn't, and set a lowish default accordingly.  Again, SSDs
> didn't exist when md-RAID was coded, nor when this default was set, a=
nd
> this throws a big monkey wrench into these spokes.

Hi Stan,

nice analytical report, as usual...

My dumb suggestion would be to simply use udev to
setup the drives.
Everything, stripe_cache, read_ahead, stcerr, etc.
can be configured, I suppose, by udev rules.

bye,

--=20

piergiorgio
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: SSD - TRIM command
Date: Wed, 9 Feb 2011 17:22:19 -0200
Message-ID: <AANLkTimDWW-n7a9VR-GnCbb4g+QXy_ZmZtoRoWWGCGr9@mail.gmail.com>
References: <AANLkTikfeH_n04iJ=5e=_G4a_GrxiWyZNJ1oCYyiBhNO@mail.gmail.com>
	<4D517F4F.4060003@gmail.com>
	<4D5245DF.4020401@hardwarefreak.com>
	<iiu4rc$9ju$1@dough.gmane.org>
	<AANLkTi=WNk3=3Jwm-YJeujcrdh-OQ4W4mJrq+YJ5Xv4k@mail.gmail.com>
	<AANLkTik6D-r1ZbgxEACHZK9760pcUBB+3e7wVX3oqrKP@mail.gmail.com>
	<AANLkTim-S0nTC8-r1U2xQ9Gw3EVAZHDjSxT=tnNnHmCT@mail.gmail.com>
	<AANLkTi=+w-q8s-y-K-24ZwSLsLrJ44Oh9LiF3ReeyYdP@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=+w-q8s-y-K-24ZwSLsLrJ44Oh9LiF3ReeyYdP@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: doug@easyco.com
Cc: Chris Worley <worleys@gmail.com>, "Scott E. Armitage" <launchpad@scott.armitage.name>, David Brown <david@westcontrol.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

i agree with ppps
that=B4s why ecc, checksum and parity is usefull (raid5,6) (raid1 if yo=
u
read from all mirror to check difference and select the 'right disk')

2011/2/9 Doug Dumitru <doug@easyco.com>:
> I work with SSDs arrays all the time, so I have a couple of thoughts
> about trim and md.
>
> 'trim' is still necessary. =A0SandForce controllers are "better" at
> this, but still need free space to do their work. =A0I had a set of S=
=46
> drives drop to 22 MB/sec writes because they were full and scrambled.
> It takes a lot of effort to get them that messed up, but it can still
> happen. =A0Trim brings them back.
>
> The bottom line is that SSDs do block re-organization on the fly and
> free space makes the re-org more efficient. =A0More efficient means
> faster, and as importantly less wear amplification.
>
> Most SSDs (and I think the latest trim spec) are deterministic on
> trim'd sectors. =A0If you trim a sector, they read that sector as zer=
os.
> =A0This makes raid much "safer".
>
> raid/0,1,10 should be fine to echo discard commands down to the
> downstream drives in the bio request. =A0It is then up to the physica=
l
> device driver to turn the discard bio request into an ATA (or SCSI)
> trim. =A0Most block devices don't seem to understand discard requests
> yet, but this will get better over time.
>
> raid/4,5,6 is a lot more complicated. =A0With raid/4,5 with an even
> number of drives, you can trim whole stripes safely. =A0Pieces of
> stripes get interesting because you have to treat a trim as a write o=
f
> zeros and re-calc parity. =A0raid/6 will always have parity issues
> regardless of how many drives there are. =A0Even worse is that
> raid/4,5,6 parity read/modify/write operations tend to chatter the FT=
L
> (Flash Translation Layer) logic and make matters worse (often much
> worse). =A0If you are not streaming long linear writes, raid/4,5,6 in=
 a
> heavy write environment is a probably a very bad idea for most SSDs.
>
> Another issue with trim is how "async" it behaves. =A0You can trim a =
lot
> of data to a drive, but it is hard to tell when the drive actually is
> ready afterwards. =A0Some drives also choke on trim requests that com=
e
> at them too fast or requests that are too long. =A0The behavior can b=
e
> quite random. =A0So then comes the issue of how many "user knobs" to
> supply to tune what trims where. =A0Again, raid/0,1,10 are pretty eas=
y.
> Raid/4,5,6 really requires that you know the precise geometry and
> control the IO. =A0Way beyond what ext4 understands at this point.
>
> Trim can also be "faked" with some drives. =A0Again, looking at the
> SandForce based drives, these drive internally de-dupe so you can fak=
e
> write data and help the drives get free space. =A0Do this by filling =
the
> drive with zeros (ie, dd if=3D/dev/zero of=3Dbig.file bs=3D1M), do a =
sync,
> and then delete the big.file. =A0This works through md, across SANs,
> from XEN virtuals, or wherever. =A0With SandForce drives, this is not=
 as
> effective as a trim, but better than nothing. =A0Unfortunately, only
> SandForce drives and Flash Supercharger understand zero's this way. =A0=
A
> filesystem option that "zeros discarded sectors" would actually make
> as much sense in some deployment settings as the discard option (not
> sure, but ext# might already have this). =A0NTFS has actually support=
ed
> this since XP as a security enhancement.
>
> Doug Dumitru
> EasyCo LLC
>
> ps: =A0My background with this has been the development of Flash
> SuperCharger. =A0I am not trying to run an advert here, but the care =
and
> feeding of SSDs can be interesting. =A0Flash SuperCharger breaks most=
 of
> these rules, but it does know the exact geometry of what it is drivin=
g
> and plays excessive games to drives SSDs at their exact "sweet spot".
> One of our licensees just sent me some benchmarks at > 500,000 4K
> random writes/sec for a moderate sized array running raid/5.
>
> pps: =A0Failures of SSDs are different than HDDs. =A0SSDs can and do =
fail
> and need raid for many applications. =A0If you need high write IOPS, =
it
> pretty much has to be raid/1,10 (unless you run our Flash SuperCharge=
r
> layer).
>
> ppps: =A0I have seen SSDs silently return corrupted data. =A0Disks do=
 this
> as well. =A0A paper from 2 years ago quoted disk silent error rates a=
s
> high as 1 bad block every 73TB read. =A0Very scary stuff, but probabl=
y
> beyond the scope of what md can address.
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

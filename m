From: NeilBrown <neilb@suse.com>
Subject: Re: RAID 6 "Failed to restore critical section for reshape, sorry." - recovery advice?
Date: Mon, 04 Jan 2016 13:16:14 +1100
Message-ID: <87r3hyxf69.fsf@notabene.neil.brown.name>
References: <CAF-Kpgb57-LoNy=-jy76ZcE=YPABmARzfsHNitJNZyw3v2AShw@mail.gmail.com> <alpine.DEB.2.02.1512100918520.20919@uplift.swm.pp.se> <CAF-KpgaLr-qA_RJiDYstFv-=EoHH-Ea3o1q3G3tXC4nX=Wt2XA@mail.gmail.com> <CAF-KpgYe9Vxgcy2E5T1_9HdEM0YMfATMzN7WcjHra_EE+sOOTg@mail.gmail.com> <87d1u060sv.fsf@notabene.neil.brown.name> <CAF-Kpga8toqetF+g6wYbUVHKngkRB8QMTyRy39Jnxn0P6w8ouQ@mail.gmail.com> <871tad3o2q.fsf@notabene.neil.brown.name> <CAF-KpgZ=HY_HKvj5buFOKseUV0GLeOLR1m3B0EYxrYcD3R5ieA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAF-KpgZ=HY_HKvj5buFOKseUV0GLeOLR1m3B0EYxrYcD3R5ieA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: George Rapp <george.rapp@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Sun, Dec 27 2015, George Rapp wrote:

> Please find attached the output of the following command:
>
> # tar -c -v -z --sparse -f dev-md4-mdadm-dump.tar.gz dev-md4-mdadm-dump
>
> Thanks again for your help!

Thanks.

If you apply the following patch to mdadm (
   git clone git://neil.brown.name/mdadm
   apply patch
   make
) and then try to assemble with --update=revert-reshape, it should
assemble as a 5-device array with no reshape happening.

I probably want more safety checks before this goes upstream, but it
is safe enough for you.

NeilBrown

diff --git a/super1.c b/super1.c
index 10e00652c4ee..efc0491fc94d 100644
--- a/super1.c
+++ b/super1.c
@@ -1317,6 +1317,17 @@ static int update_super1(struct supertype *st, struct mdinfo *info,
 			unsigned long long reshape_sectors;
 			long reshape_chunk;
 			rv = 0;
+			/* If the reshape hasn't started, just stop it */
+			if (sb->reshape_position == 0 &&
+			    (__le32_to_cpu(sb->delta_disks) > 0 ||
+			     (__le32_to_cpu(sb->delta_disks) == 0 &&
+			      !(sb->feature_map & __cpu_to_le32(MD_FEATURE_RESHAPE_BACKWARDS))))) {
+				sb->feature_map &= ~__cpu_to_le32(MD_FEATURE_RESHAPE_ACTIVE);
+				sb->raid_disks = __cpu_to_le32(__le32_to_cpu(sb->raid_disks) -
+							       __le32_to_cpu(sb->delta_disks));
+				sb->delta_disks = 0;
+				goto done;
+			}
 			/* reshape_position is a little messy.
 			 * Its value must be a multiple of the larger
 			 * chunk size, and of the "after" data disks.
@@ -1363,6 +1374,7 @@ static int update_super1(struct supertype *st, struct mdinfo *info,
 				sb->new_offset = __cpu_to_le32(-offset_delta);
 				sb->data_size = __cpu_to_le64(__le64_to_cpu(sb->data_size) - offset_delta);
 			}
+		done:;
 		}
 	} else if (strcmp(update, "_reshape_progress")==0)
 		sb->reshape_position = __cpu_to_le64(info->reshape_progress);


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWidXuAAoJEDnsnt1WYoG5ou0P/iHwsuqAiyM1RrEE2NhqSaY+
s2YmjvQIdVuTisPxXY8JT8ypUm2neg2vgFJt7XoO2UaCi6M7HMDex7dBhQZzwzXR
zjrcNmvh52XYxz7FGqjErJx9yiYlFVYu5yBP4hOGUKLQvpkcZy95RyepJ6UVQChf
oguCJUv/SACLrTlRVFyhHHKjtLYgvkAEfulIgaXeKhKBuq72pZ/gyvQDNdTQj3rG
HNgRuXBhzlU88bOn83QDFfF4ynUHRBrCBA3NyUqUWXqaR+1weQwcymt3doe5EK8M
18+lGe1cvA3OhCrroWUDwl7tAD9UzhisXE14NLK9n/TLbxLBF1In5fJf9LLZoBLN
jDQFiVFUixJH1ieXVwIbl3k1IoNskhYlioaRRE4GpteGsxfp3Ku+q+R2RTL3oAnP
sTELAZkPwOA6E+u5q0c+vgrm7IOvGC/Yv7+kbMLiyhgNTExYwbqmGkuFtOCG+m65
cWWe7PzB7XLMmITs2+2N8SiQTBuGfJHtPmTprFOqQgkU0p8IjwbNdvDewH6dy9G6
xtjdTzSXTlarcm4RJvH/KCX50r+swaK2WE+ow0FLMUH99jsF/UZ/pEgTH36n/5v2
iFOY0F+NUCz4XHT1UbXB4yEpGA9+854k9g4k6YXhbD7dFz9ajVHUxdu4mYnSQP4B
CUoMeOBwFKd63GLkm3BJ
=k6p+
-----END PGP SIGNATURE-----
--=-=-=--

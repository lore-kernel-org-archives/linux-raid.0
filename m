From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm raid6 recovery status
Date: Wed, 28 Mar 2012 15:11:48 +1100
Message-ID: <20120328151148.035bd737@notabene.brown>
References: <B2B36B3006DB4C47A56D6BA19443F5D12DCEB542@IU-MSSG-MBX110.ads.iu.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/F4dWqGtF1OOAPdHxV4I/XHZ"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <B2B36B3006DB4C47A56D6BA19443F5D12DCEB542@IU-MSSG-MBX110.ads.iu.edu>
Sender: linux-raid-owner@vger.kernel.org
To: "Paramasivam, Meenakshisundaram" <mparamas@iupui.edu>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/F4dWqGtF1OOAPdHxV4I/XHZ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 28 Mar 2012 02:22:33 +0000 "Paramasivam, Meenakshisundaram"
<mparamas@iupui.edu> wrote:


> #mount   /dev/md2   /myarray
> mounts fine, however, I now see only 2TB instead of 7 TB for /myarray. I =
need to get all of the data back and I am stuck here.

What exactly do you mean by "see only 2TB"??
The md array is reporting that it is 12TB in size (12000 GB).

What reports 2TB?  /proc/partitions? df? du? ?/

NeilBrown

--Sig_/F4dWqGtF1OOAPdHxV4I/XHZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT3KPhDnsnt1WYoG5AQIfWxAAvmZ+HrYBRPelavr9EVQduW/0ISvniRtc
Iv+hJU5MPOhe/Gr9cgS3DXNxwt+5GYEs2vO6MIIinb7CsnXY2VUqNAHlsPFGDZWY
CpT4b0L7DpaTcMOSt2d7SqPiom99fZr+L8tOlvt+17jk8/pUWCxsandvq91qOaoy
0E71hiKfVSRMj+q4ufOQHZVTaoqPK/KuknpU6em9iAQnKkb8PDdbqRbNQtwonI6h
vDN8ahGoxhVmF6NIhK96H88DhLhP2vlfmbYios797PSVNah5Mzo52s9U3IKP52DG
5HbrMmqEHBbNRl2Demt9e6UdQJ1taLRCRgJNIiLPKxa2ZOsWNdPT8ftzHYPNv2I5
5OOlvbQaZHJaNjgrh3k4zXH9f7RbHl/HpjV/j2HSvP2nrpsNMpjYJ/vROAd4pl5a
OiR6+xdPkuXprYUi6MdTdFVPAqgwqcFnVWkXxGq7hkWJz4530k3/A8hvupDoYydt
LmmRAEa82ROnXyDV3kL8eowU+xIjUqf40sGJ+lmwYhzu40WWqA8GKGfp9z7e+2jd
mMVlw78xhy+78bWYX6n/8SGni0efWaUojm34CkXzJn3MUqgdKp3n72n+cjMuPQDi
Nw4Jspf6mzUFzaQIeWATUx4gcUbzqyjA1yvv0sNntHYfA92U2irUfoTGnGjUgPEf
hLe16A1M4uc=
=pJ42
-----END PGP SIGNATURE-----

--Sig_/F4dWqGtF1OOAPdHxV4I/XHZ--

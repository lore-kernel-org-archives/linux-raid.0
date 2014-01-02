From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: The chunk size paradox
Date: Thu, 02 Jan 2014 10:24:06 -0500
Message-ID: <52C58496.5030200@ubuntu.com>
References: <52C1C01A.7010407@ubuntu.com> <52C57C7B.80400@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52C57C7B.80400@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: joystick <joystick@shiftmail.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 1/2/2014 9:49 AM, joystick wrote:
> lot of them together since it knows how much data it has to read
> (via readahead, most of the times). The disk reorders read/write
> requests

That's the problem; if you want a 1 GB stripe size then you need 2 GB
of readahead to keep the disks spinning.  That's not really
reasonable.  The idea is to get back to ~128k being enough readahead
to keep the disks busy, without causing loads of seeking.  Reordering
doesn't come into play here since I'm talking sequential reads.

> Secondly, for writes, I suspect you are assuming that a whole stipe
> has to be read and rewritten in order for one small write to be
> performed, but it is not so. For a 4k write in raid5, two 4k
> sectors are read, then two 4k sectors are written, and this is
> completely independent from chunk size. It already behaves mostly
> like your "groups", which are the stripes actually.

I don't believe this is correct.  raid5 caches an entire stripe at a
time in the stripe cache.  Even if it were so, it still wouldn't be
related to what I'm talking about, which is the fact that when doing
large streaming reads, the disk head has to seek to skip the redundant
data.  How often it has to do that is related to the chunk size, and
is something you want to minimize since it is bad for throughput.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJSxYSWAAoJEI5FoCIzSKrwvdoH/3/181+FZ1O40NJ1BuDan1Hc
oHwvqt+B+ow2H042l0gduVM8ZkgsGaLXF2R4/g2dYF4p77OvCPiHmY5R47WdUJzI
M6phlZlkCgKK3uyUCaCPAxJ2OKdzZxvlM9SDtywfH3H6aFYmAOWJTUD9EdkztRfZ
XM6CGpRly3/sCx+P3RTb4X/5F2VOJlbzEar5mp1TYIlYyR4hdeDeaci32Xgtmkcv
HBVAXnNMfQew4fTEQzD+hE1/ILIVB0xZt5E/O5368pidcTU7ndPVjXywWA9FF/CL
ckQSnNE2DpLXEb/2uT3VsAqEcJjMXYspGs1qocGw7VOMirM7ZstREX/kphJdPAU=
=eVT+
-----END PGP SIGNATURE-----

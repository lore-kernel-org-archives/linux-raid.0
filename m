From: Phil Turmel <philip@turmel.org>
Subject: Re: broken raid level 5 array caused by user error
Date: Mon, 9 Nov 2015 16:13:11 -0500
Message-ID: <56410C67.2090202@turmel.org>
References: <15194c2e14b9a7c3431853dea9dc8b5e@pingofdeath.de>
 <alpine.DEB.2.02.1511091254290.24520@uplift.swm.pp.se>
 <5640A4B1.4050207@turmel.org>
 <07de4cd96f39ecb6154794d072ca12e7@pingofdeath.de>
 <5640B8AD.3030800@turmel.org>
 <ed5f0f3cde3f017eae97bab65c792983@pingofdeath.de>
 <d764bf541381927fa4183c9266fb3f5a@pingofdeath.de>
 <5640C38B.4060503@turmel.org>
 <a3a91665c4b7cdd70dacc7d8815cc365@pingofdeath.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <a3a91665c4b7cdd70dacc7d8815cc365@pingofdeath.de>
Sender: linux-raid-owner@vger.kernel.org
To: Mathias Mueller <raidfail@gmx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

{Resend with list address corrected -- ignore the duplicate, Mathias }

Hi Matthias,

On 11/09/2015 02:36 PM, Mathias Mueller wrote:
>> for x in /dev/sd[b-e]1 ; do echo $x ; dd if=$x bs=4k count=2 |hexdump
>> -C ; done
> 
> /dev/sdb1
> 00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> *
> 00000400  00 20 47 07 16 10 1c 1d  67 9a 74 01 8b 5d a6 1c  |. G.....g.t..]..|
> 00000410  f5 1f 47 07 00 00 00 00  02 00 00 00 02 00 00 00  |..G.............|
> 00000420  00 80 00 00 00 80 00 00  00 20 00 00 00 00 00 00  |......... ......|
> 00000430  d9 45 8b 4c 00 00 27 00  53 ef 01 00 01 00 00 00  |.E.L..'.S.......|
> 00000440  2e 44 8b 4c 00 4e ed 00  00 00 00 00 01 00 00 00  |.D.L.N..........|
> 00000450  00 00 00 00 0b 00 00 00  00 01 00 00 3c 00 00 00  |............<...|

False positive. (Not an ext4 signature).

> /dev/sdc1
> 00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> *
> 00000400  00 20 47 07 16 10 1c 1d  67 9a 74 01 8b 5d a6 1c  |. G.....g.t..]..|
> 00000410  f5 1f 47 07 00 00 00 00  02 00 00 00 02 00 00 00  |..G.............|
> 00000420  00 80 00 00 00 80 00 00  00 20 00 00 00 00 00 00  |......... ......|
> 00000430  d9 45 8b 4c 00 00 27 00  53 ef 01 00 01 00 00 00  |.E.L..'.S.......|
> 00000440  2e 44 8b 4c 00 4e ed 00  00 00 00 00 01 00 00 00  |.D.L.N..........|

Also a false positive.

> /dev/sdd1
> 00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> *
> 00000400  00 20 47 07 90 0e 1c 1d  54 9a 74 01 75 aa c1 08  |. G.....T.t.u...|
> 00000410  35 47 33 07 00 00 00 00  02 00 00 00 02 00 00 00  |5G3.............|
> 00000420  00 80 00 00 00 80 00 00  00 20 00 00 0b b2 ca 4d  |......... .....M|
> 00000430  7b f0 ca 4d 15 00 21 00  53 ef 01 00 01 00 00 00  |{..M..!.S.......|
> 00000440  9d 7f 3b 4d 00 4e ed 00  00 00 00 00 01 00 00 00  |..;M.N..........|
> 00000450  00 00 00 00 0b 00 00 00  00 01 00 00 3c 00 00 00  |............<...|
> 00000460  42 02 00 00 7b 00 00 00  4f a7 6a c3 f8 12 42 1c  |B...{...O.j...B.|
> 00000470  8f d2 5b ec 1a e9 fb 4c  64 61 74 61 00 00 00 00  |..[....Ldata....|
> 00000480  00 00 00 00 00 00 00 00  2f 6d 65 64 69 61 2f 64  |......../media/d|
> 00000490  61 74 61 00 d8 dc 83 00  02 88 ff ff 38 da 59 4c  |ata.........8.YL|
> 000004a0  00 00 00 00 00 c6 70 c3  01 88 ff ff 00 96 56 23  |......p.......V#|
> 000004b0  02 88 ff ff 40 7b 21 1d  02 88 ff ff dd 75 18 81  |....@{!......u..|

This really is an ext4 signature.  Volume label 'data' last
mounted at '/media/data' on Wed, 11 May 2011 15:58:03 GMT.

Given that date and your certainty that your array was v1.2,
this must be garbage left over from a previous filesystem.

> /dev/sde1
> 00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> *
> 00000400  00 20 47 07 16 10 1c 1d  67 9a 74 01 8b 5d a6 1c  |. G.....g.t..]..|
> 00000410  f5 1f 47 07 00 00 00 00  02 00 00 00 02 00 00 00  |..G.............|
> 00000420  00 80 00 00 00 80 00 00  00 20 00 00 0a 88 62 51  |......... ....bQ|
> 00000430  d5 cb 62 51 05 00 24 00  53 ef 01 00 01 00 00 00  |..bQ..$.S.......|
> 00000440  54 d4 81 50 00 4e ed 00  00 00 00 00 01 00 00 00  |T..P.N..........|
> 00000450  00 00 00 00 0b 00 00 00  00 01 00 00 3c 00 00 00  |............<...|

Another false positive.

>> Also show the following more picky signature search for each drive:
>> dd if=/dev/sdd1 bs=1M count=1M |hexdump -C |grep -E '[048c]30  .+  53 ef'
> 
> I will provide this as soon as the processes are finished, seems to take
> some more hours.

We'll just have to wait for this.  Your ext4 superblock should be in
there somewhere.

> there is also one more thing I remember, maybe it's helpful: when I was
> starting the reshape, there was this message:
> 
> mdadm: Need to backup 8192K of critical section..

If this was an actual error message, it may not have proceeded.  We just
don't know yet.

Phil

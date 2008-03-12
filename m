From: Michael Guntsche <mike@it-loops.com>
Subject: Re: LVM performance
Date: Wed, 12 Mar 2008 15:03:48 +0100
Message-ID: <5e44228294f0aabe036fd15b051d2e57@localhost>
References: <18389.41592.494811.875055@tree.ty.sabi.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18389.41592.494811.875055@tree.ty.sabi.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



On Mon, 10 Mar 2008 21:04:56 +0000, pg_lxra@lxra.for.sabi.co.UK (Peter
Grandi) wrote:
<snip>
> Uhm, usually I would say that in such a case the stripe size is
> 192KiB, of which 128KiB are the data capacity/payload.
> 
> I usually think of the stripe as it is recorded on the array,
> from the point of view of the RAID software. As you say here:
> 
>> I assume if you tell the file system about this stripe size
>> (or it figures it out itself, as xfs does), it tries to align
>> its structures such that whole-stripe writes are more likely
>> than partial writes. This means that md only has to write
>> 3*64KB (2x data + parity).
> 
> Indeed, indeed the application above the filesystem has to write
> carefully in 128KiB long, 128KiB aligned (to the start of the
> array, not the start of the overlaying volume, as you point out)
> transactions to avoid the high costs you describe here and
> elsewhere.

Ok by now the the horse of this thread has been beaten to death several
times.
But there has to be a logical reason why my RAID-5 which has been running
in test mode for the last weeks has not been put into production yet.
Thinking about all the alignment talks I read about on this list I did one
final test.

Right now I have my trusty 4 DISK RAID-5 with a CHUNKSIZE of 256KB, thus
having a stripe-size of 1MB.

Below you will find the bonnie results. 
The first one is plain XFS on the MD device, do not ask me why the numbers
are so low for the file tests but right now I do not care. :)
The next entry is with a CHUNKSIZE aligned LVM volume.

I did:

   pvcreate --metadatasize 192k /dev/md1 <--- 192=256-64 where 256 is the
chunksize and 64 is the PV headear

The final entry is a STRIPESIZE aligned LVM volume

  pvcreate --metadatasize 960K /dev/md1 <-- 960=1024-64 where 1024 is the
stripesize and ......

Version  1.03c      ------Sequential Output------ --Sequential Input-
--Random-
                    -Per Chr- --Block-- -Rewrite- -Per Chr- --Block--
--Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec
%CP
xfs              8G           49398  43 26252  21           116564  45
177.8   2
lvm-chunkaligned 8G           45937  42 23711  24           102184  50
154.3   2
lvm-stripealigne 8G           49271  43 24401  25           116136  50
167.9   2
                    ------Sequential Create------ --------Random
Create--------
                    -Create-- --Read--- -Delete-- -Create-- --Read---
-Delete--
files:max:min        /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec
%CP
xfs 16:100000:16/64   196  13   211  10  1531  49   205  13    45   2  1532
 46
lvm 16:100000:16/64   634  25   389  25  2307  56   695  26    74   4   514
 34
lvm 16:100000:16/64   712  27   383  25  2346  52   769  27    59   3  1303
 46

As you can see it apparently does make a difference if you stripe align or
not, like everyone else said.
My main mistake was that I always confused CHUNK and STRIPE size when
talking and testing.

Hopefully this will help someone, who is searching the archives for some
answers.

Kind regards,
Michael

PS: This list has given me a lot of valuable information and I want to
thank everyone for their support, especially the guys who never got tired
answering my sometimes stupid questions during the last weeks.







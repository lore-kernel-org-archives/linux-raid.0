From: "John Stoffel" <john@stoffel.org>
Subject: Re: Recovery on new 2TB disk: finish=7248.4min (raid1)
Date: Thu, 27 Apr 2017 15:03:40 -0400
Message-ID: <22786.16524.435313.304834@quad.stoffel.home>
References: <590117CD.1000009@tesco.net>
        <22785.65375.947842.648174@quad.stoffel.home>
        <5492628.c8B43Z4h0G@matkor-lenovo>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5492628.c8B43Z4h0G@matkor-lenovo>
Sender: linux-raid-owner@vger.kernel.org
To: Mateusz Korniak <mateusz-lists@ant.gliwice.pl>
Cc: John Stoffel <john@stoffel.org>, Ron Leach <ronleach@tesco.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "Mateusz" == Mateusz Korniak <mateusz-lists@ant.gliwice.pl> writes:

Mateusz> On Thursday 27 of April 2017 10:25:35 John Stoffel wrote:
Ron> issued these commands one after the other:
>> 
Ron> # mdadm --manage -a /dev/mdo /dev/sdb1
Ron> # mdadm --manage -a /dev/md1 /dev/sdb2
Ron> # mdadm --manage -a /dev/md2 /dev/sdb3
Ron> # mdadm --manage -a /dev/md3 /dev/sdb5
Ron> # mdadm --manage -a /dev/md4 /dev/sdb6
Ron> # mdadm --manage -a /dev/md5 /dev/sdb7
Ron> # mdadm --manage -a /dev/md6 /dev/sdb8
Ron> # mdadm --manage -a /dev/md7 /dev/sdb9
>> 
>> Ugh!  You're setting yourself up for a true seek storm here, and way
>> too much pain down the road, IMHO.  Just mirror the entire disk and
>> put LVM volumes on top.  

Mateusz> Why having several md devices leads to "seek storm"?

It might if MD isn't being smart enough, which might happen.  

Mateusz> They will be synced one by one, just like one big md device.

No, big MD devices are sync'd in parallel assuming MD thinks they're
on seperate devices.  Now in this case I admit I might have jumped the
gun, but I'm mostly commenting on the use of multiple MD RAID setups
on a single pair of disks.

It's inefficient.  It's a pain to manage.  You lose flexibility to
resize.

Just create a single MD device across the entire disk (or possibly two
if you want to boot off one mirrored pair) and then use LVM on top to
carve out storage.  More flexible.

John

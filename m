From: Ronny Plattner <ronny_p@gmx.net>
Subject: Re: sw_raid5-failed_disc(s)-2
Date: Sun, 13 Mar 2005 23:15:02 +0100
Message-ID: <d12dql$hge$1@sea.gmane.org>
References: <d0vdln$h8s$1@sea.gmane.org> <200503122215.j2CMFE530626@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
In-Reply-To: <200503122215.j2CMFE530626@www.watkins-home.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi !

Guy schrieb:

>> I guess I need to know more history.  Before your problems, was hdi1
>> a spare?


I created the arry with following raidtab

-snip-
# jetzt die 4 Maxtor Platten im Raid 5
raiddev                 /dev/md2
raid-level              5
nr-raid-disks           4
# von 32 auf 64 konvertiert mit raidreconf - ronny,juni2004
chunk-size              64
nr-spare-disks          0
persistent-superblock   1
parity-algorithm        left-symmetric
device                  /dev/hdi1
raid-disk               0
device                  /dev/hdk1
raid-disk               1
device                  /dev/hdm1
raid-disk               2
device                  /dev/hdo1
raid-disk               3
-snap-


>> Describe the array before you had problems.  Then what went wrong.


hdi showed 3 reallocated sectors. I decided to send it back to maxtor,
so we shutdown the server, built the disc out of the tower and turned
the server on. After some hours, people told us, that there were some
problems. I saw, that hdm was marked as faulty ...and smartctl showed
some errors.
We built hdi back to the server and tried to add it back in the array.
But -> Troubles....it wasnt possible (after some power offs hdm was
"active" in the array and not marked as faulty) to readd hdi to the
raid. After a while i solved it (dmsetup status was the solution) by
remove hdi (dmsetup remove hdi) ..then it was possible to readd hdi back
to the array via mdadm /dev/md2 -a /dev/hdi1.
I was able to mount one partition (lvm) of the raid and i copied the
data to other harddiscs (hde, hdg,...). It was also able to mount the
second partition of the raid (data), but i got always "I/O Errors", when
i tried to copy files. And it was able to read the directory structure.
But while trying to backup the data-partition, the rebuild prozess (this
was started after i readded hdi1 to the array) of the raid filled our
logs (some entrys per second) so we powered of the server and built hdm
out (and AFAIK its still on my colleges table).
There we are now...you rod the postings, i think.

Do you know how to solve our problem or is the data lost?

Regards
Ronny


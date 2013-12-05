From: Wilson Jonathan <piercing_male@hotmail.com>
Subject: Re: accidently pulled to many devices, raid6 wont start.
Date: Thu, 5 Dec 2013 14:20:30 +0000
Message-ID: <BLU0-SMTP2081DE3677BA1FD887C35BC98D70@phx.gbl>
References: <BLU0-SMTP16236357B62A13D8FFAC14198D70@phx.gbl>
	 <52A08162.3080706@fastmail.fm>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52A08162.3080706@fastmail.fm>
Sender: linux-raid-owner@vger.kernel.org
To: Bernd Schubert <bernd.schubert@fastmail.fm>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 2013-12-05 at 14:36 +0100, Bernd Schubert wrote:
> On 12/05/2013 01:30 AM, Wilson Jonathan wrote:
> > mdadm: /dev/sdf6 is identified as a member of /dev/md5, slot 2.
> > mdadm: /dev/sde6 is identified as a member of /dev/md5, slot 1.
> > mdadm: /dev/sdd6 is identified as a member of /dev/md5, slot 0.
> > mdadm: /dev/sdb6 is identified as a member of /dev/md5, slot 4.
> > mdadm: /dev/sda6 is identified as a member of /dev/md5, slot 3.
> > mdadm: ignoring /dev/sde6 as it reports /dev/sdf6 as failed
> 
> [...]
> 
> > So tried again, with a different (valid) chunk...
> >
> >
> > root@BorgCUBE:/mnt/datastore/wilsonjonathan# mdadm --create
> > --assume-clean --level=6 --raid-devices=6
> > --chunk=64 /dev/md5 /dev/sdd6 /dev/sde6
> > missing /dev/sdf6 /dev/sda6 /dev/sdb6
> 
> Why are you using this order? Missing seems to be at the wrong place?
> 
> 
> Cheers,
> Bernd

Arr yes, I seem to have got the order wrong... before I continue and do
further damage; I put the original pulled drive (sdc) back in and re-ran
examine. Obviously I have corrupted the raid layout data on the other
disks (a,b,d,e,f) but here is the sdc examine output.

/dev/sdc6:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 9ff95b8b:ba34ad95:aa7cb806:169246f2
           Name : PartedMagic:6
  Creation Time : Fri Nov 25 16:30:19 2011
     Raid Level : raid6
   Raid Devices : 6

 Avail Dev Size : 1833569679 (874.31 GiB 938.79 GB)
     Array Size : 3667138560 (3497.26 GiB 3755.15 GB)
  Used Dev Size : 1833569280 (874.31 GiB 938.79 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : 4ce632fb:d506da60:120cac8e:4433efc4

Internal Bitmap : 8 sectors from superblock
    Update Time : Wed Dec  4 23:04:40 2013
       Checksum : fe4e7b1f - correct
         Events : 260243

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 5
   Array State : AAAAAA ('A' == active, '.' == missing)


> 
> 

I mistook the order (a-b-c-d-) with the position number in the array.

If I'm reading this correctly, Active device 5 means it should be at
position 5, or the sixth disk in the array.

I also note it has a bitmap on it, something the other drives now lack
as it was not stated in the original forced create, so not sure how that
will affect things and the event count is lower, 260243, than the other
devices, 260321, before the array became corrupted (that said I know
exactly which files were being updated on the file system, so if I can
get it back I will just delete them and re-create).

Hopefully I have not totally killed the array by my mistakes.




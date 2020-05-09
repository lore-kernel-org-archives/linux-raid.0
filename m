From: Michal Soltys <msoltyspl@yandex.pl>
Subject: Re: Assemblin journaled array fails
Date: Sat, 9 May 2020 15:32:15 +0200
Message-ID: <e8ac7b5a-3d06-403a-4a92-aabd29266ca9@yandex.pl>
References: <f8c61278-1758-66cd-cf25-8a118cb12f58@yandex.pl>
 <9591809e-583d-ebd5-ea0f-a342868a7728@youngman.org.uk>
 <1615c45f-8f7c-fae2-ef74-a23a29857316@yandex.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1615c45f-8f7c-fae2-ef74-a23a29857316@yandex.pl>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: antlists <antlists@youngman.org.uk>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 20/05/09 15:20, Michal Soltys wrote:
> On 20/05/09 15:15, antlists wrote:
>> On 09/05/2020 11:54, Michal Soltys wrote:
>>> After the reboot I'm in the situation as outlined above. Any 
>>> suggestion how to assemble this array now ?
>>
>> mdadm -v ?
> 
> mdadm - v4.1 - 2018-10-01
> 
>>
>> uname -a ?
> 
> Linux xs22 5.4.0-0.bpo.4-amd64 #1 SMP Debian 5.4.19-1~bpo10+1 
> (2020-03-09) x86_64 GNU/Linux
> 
>>
>> https://raid.wiki.kernel.org/index.php/Asking_for_help
>>
>> Dunno what the problem is, and I'm hesitant to recommend it, but 
>> re-assembling the array without a journal might work.
> 
> I would - if possible - want to avoid this, as the journal is 
> write-back. So as a last resort only.
> 

Looking at the around-reboot logs, the machine might have eaten hard 
power loss (despite all ups processes working, but I'll be checking that 
later)

The things that so far are really weird:

1) the size reported via mdadm -D:

mdadm -D /dev/md126
/dev/md126:
            Version : 1.1
      Creation Time : Tue Mar  5 19:28:58 2019
         Raid Level : raid5
      Used Dev Size : 18446744073709551615

This is clearly incorrect.

2) the mdadm --incremental is in R state eating all 1 cpu, but otherwise 
cannot be terminated or killed (so sitting on some lock ?)

root       403     1  0  2744  3392  33 15:05 ?        S      0:01 
/lib/systemd/systemd-udevd --daemon --resolve-names=never
root       571   403 98   740  1976  13 15:05 ?        R     19:07  \_ 
/sbin/mdadm --incremental --export /dev/md125 --offroot 
/dev/disk/by-id/md-name-xs22:r1_journal_big 
/dev/disk/by-id/md-uuid-c18b3996:49b21f49:3ee18e92:a8240f7f 
/dev/md/r1_journal_big

This is probably the same case as with manual mdadm -A that I tried from 
initramfs before udevd.

3) The 4 removed lines in mdadm -D output

     Number   Major   Minor   RaidDevice State
        -       0        0        0      removed
        -       0        0        1      removed
        -       0        0        2      removed
        -       0        0        3      removed

No device was removed from this array besides the old journal what I 
wrote in the first mail.

4) The journal device is listed as actual spare instead of journal

        -       8      145        3      sync   /dev/sdj1
        -       8      129        2      sync   /dev/sdi1
        -       8      113        1      sync   /dev/sdh1
        -       8       97        0      sync   /dev/sdg1
        -       9      125        -      spare   /dev/md/r1_journal_big


All mdadm -Ev of each component device looks fine though:

/dev/sdj1:
           Magic : a92b4efc
         Version : 1.1
     Feature Map : 0x200
      Array UUID : d5995d76:67d7fabd:05392f87:25a91a97
            Name : xs22:r5_big  (local to host xs22)
   Creation Time : Tue Mar  5 19:28:58 2019
      Raid Level : raid5
    Raid Devices : 4

  Avail Dev Size : 7812237856 (3725.17 GiB 3999.87 GB)
      Array Size : 11718355968 (11175.50 GiB 11999.60 GB)
   Used Dev Size : 7812237312 (3725.17 GiB 3999.87 GB)
     Data Offset : 262144 sectors
    Super Offset : 0 sectors
    Unused Space : before=262064 sectors, after=544 sectors
           State : clean
     Device UUID : 5a73a457:b16dd591:90eceb56:2f8e1cb3

     Update Time : Sat May  9 15:05:22 2020
   Bad Block Log : 512 entries available at offset 72 sectors
        Checksum : dfa92cad - correct
          Events : 56289

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 3
    Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)

/dev/sdi1:
           Magic : a92b4efc
         Version : 1.1
     Feature Map : 0x200
      Array UUID : d5995d76:67d7fabd:05392f87:25a91a97
            Name : xs22:r5_big  (local to host xs22)
   Creation Time : Tue Mar  5 19:28:58 2019
      Raid Level : raid5
    Raid Devices : 4

  Avail Dev Size : 7812237856 (3725.17 GiB 3999.87 GB)
      Array Size : 11718355968 (11175.50 GiB 11999.60 GB)
   Used Dev Size : 7812237312 (3725.17 GiB 3999.87 GB)
     Data Offset : 262144 sectors
    Super Offset : 0 sectors
    Unused Space : before=262064 sectors, after=544 sectors
           State : clean
     Device UUID : f933e8b6:5411d560:0467cb10:95971e4b

     Update Time : Sat May  9 15:05:22 2020
   Bad Block Log : 512 entries available at offset 72 sectors
        Checksum : 5fce14c7 - correct
          Events : 56289

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 2
    Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)

/dev/sdh1:
           Magic : a92b4efc
         Version : 1.1
     Feature Map : 0x200
      Array UUID : d5995d76:67d7fabd:05392f87:25a91a97
            Name : xs22:r5_big  (local to host xs22)
   Creation Time : Tue Mar  5 19:28:58 2019
      Raid Level : raid5
    Raid Devices : 4

  Avail Dev Size : 7812237856 (3725.17 GiB 3999.87 GB)
      Array Size : 11718355968 (11175.50 GiB 11999.60 GB)
   Used Dev Size : 7812237312 (3725.17 GiB 3999.87 GB)
     Data Offset : 262144 sectors
    Super Offset : 0 sectors
    Unused Space : before=262064 sectors, after=544 sectors
           State : clean
     Device UUID : 8ea58384:43683121:d1017eed:1f565786

     Update Time : Sat May  9 15:05:22 2020
   Bad Block Log : 512 entries available at offset 72 sectors
        Checksum : 5b136a2 - correct
          Events : 56289

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 1
    Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)

/dev/sdg1:
           Magic : a92b4efc
         Version : 1.1
     Feature Map : 0x200
      Array UUID : d5995d76:67d7fabd:05392f87:25a91a97
            Name : xs22:r5_big  (local to host xs22)
   Creation Time : Tue Mar  5 19:28:58 2019
      Raid Level : raid5
    Raid Devices : 4

  Avail Dev Size : 7812237856 (3725.17 GiB 3999.87 GB)
      Array Size : 11718355968 (11175.50 GiB 11999.60 GB)
   Used Dev Size : 7812237312 (3725.17 GiB 3999.87 GB)
     Data Offset : 262144 sectors
    Super Offset : 0 sectors
    Unused Space : before=262064 sectors, after=544 sectors
           State : clean
     Device UUID : e38f2cd0:b9716e4e:b7fc0631:0a4e352d

     Update Time : Sat May  9 15:05:22 2020
   Bad Block Log : 512 entries available at offset 72 sectors
        Checksum : 68fe1d3c - correct
          Events : 56289

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 0
    Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)


And finally journal seems fine as well:

/dev/md/r1_journal_big:
           Magic : a92b4efc
         Version : 1.1
     Feature Map : 0x200
      Array UUID : d5995d76:67d7fabd:05392f87:25a91a97
            Name : xs22:r5_big  (local to host xs22)
   Creation Time : Tue Mar  5 19:28:58 2019
      Raid Level : raid5
    Raid Devices : 4

  Avail Dev Size : 536344576 (255.75 GiB 274.61 GB)
      Array Size : 11718355968 (11175.50 GiB 11999.60 GB)
   Used Dev Size : 7812237312 (3725.17 GiB 3999.87 GB)
     Data Offset : 262144 sectors
    Super Offset : 0 sectors
    Unused Space : before=261872 sectors, after=0 sectors
           State : clean
     Device UUID : c3a6f2f6:7dd26b0c:08a31ad7:cc8ed2a9

     Update Time : Sat May  9 15:05:22 2020
   Bad Block Log : 512 entries available at offset 264 sectors
        Checksum : c854904f - correct
          Events : 56289

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Journal
    Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)

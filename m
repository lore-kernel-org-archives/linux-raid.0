From: Rickard Svensson <myhex2020@gmail.com>
Subject: Re: Debian Squeeze raid 1 0
Date: Tue, 28 Jan 2020 22:57:00 +0100
Message-ID: <CAC4UdkZkjGOhHK1LCNKn9pwQCq-bfcixJkjMWAZs0t-RU-hyug@mail.gmail.com>
References: <CAC4UdkbjUVSpkBM88HB0UJMqXh+Pd7CRLaya=s81xMGs-9+m_Q@mail.gmail.com>
 <5E1D6C8E.8030607@youngman.org.uk> <CAC4UdkbwYvPHgufBPjNTWzcZW0FcGgGrbmFD_k_mc-Z7NVH9Pw@mail.gmail.com>
 <5E1E5798.60406@youngman.org.uk> <CAC4UdkazYkOq=Bj4BzU=amnQZJvWcA6KtySr424BOWPABhnQGA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAC4UdkazYkOq=Bj4BzU=amnQZJvWcA6KtySr424BOWPABhnQGA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi again Wol and more :)

Now I have succeeded, I hope.
This has taken some time, and the disk that was broken I had to make
different attempts with ddrescue.

I have only copied 3 of the 4 disks, not the one who got the wrong
three days before.
Because I assumed it contained old data.
Or am I think wrong, Is it better to add it to?

Otherwise, I guess I need to start the raid, or something.
Do I need a --forece maybe. I just don't want to do anything wrong
after all this :)


Debian 10   --  mdadm - v4.1 - 2018-10-01

# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]
md0 : inactive sda1[2](S) sdb1[0](S) sdb2[1](S)
      8761499679 blocks super 1.2
unused devices: <none>


# mdadm --detail /dev/md0
/dev/md0:
           Version : 1.2
        Raid Level : raid0
     Total Devices : 3
       Persistence : Superblock is persistent

             State : inactive
   Working Devices : 3

              Name : ttserv:0
              UUID : cb5bfe7a:3806324c:3c1e7030:e6267102
            Events : 2719

    Number   Major   Minor   RaidDevice

       -       8        1        -        /dev/sda1
       -       8       18        -        /dev/sdb2
       -       8       17        -        /dev/sdb1


# mdadm --examine /dev/sda1
/dev/sda1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : cb5bfe7a:3806324c:3c1e7030:e6267102
           Name : ttserv:0
  Creation Time : Tue Oct  9 23:30:23 2012
     Raid Level : raid10
   Raid Devices : 4

 Avail Dev Size : 5840999786 (2785.21 GiB 2990.59 GB)
     Array Size : 5840999424 (5570.41 GiB 5981.18 GB)
  Used Dev Size : 5840999424 (2785.21 GiB 2990.59 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
   Unused Space : before=1968 sectors, after=20538368 sectors
          State : active
    Device UUID : 23079ae3:c67969c2:13299e27:8ca3cf7f

    Update Time : Sun Jan 12 00:11:05 2020
       Checksum : ed375eb5 - correct
         Events : 2719

         Layout : near=2
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : AAA. ('A' == active, '.' == missing, 'R' == replacing)



# mdadm --examine /dev/sdb1
/dev/sdb1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : cb5bfe7a:3806324c:3c1e7030:e6267102
           Name : ttserv:0
  Creation Time : Tue Oct  9 23:30:23 2012
     Raid Level : raid10
   Raid Devices : 4

 Avail Dev Size : 5840999786 (2785.21 GiB 2990.59 GB)
     Array Size : 5840999424 (5570.41 GiB 5981.18 GB)
  Used Dev Size : 5840999424 (2785.21 GiB 2990.59 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
   Unused Space : before=1968 sectors, after=19520512 sectors
          State : clean
    Device UUID : f474ad64:6bb236d3:9f69f55c:eb9b8c27

    Update Time : Tue Jan 14 22:49:49 2020
       Checksum : 5c312015 - correct
         Events : 2864

         Layout : near=2
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AA.. ('A' == active, '.' == missing, 'R' == replacing)


# mdadm --examine /dev/sdb2
/dev/sdb2:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : cb5bfe7a:3806324c:3c1e7030:e6267102
           Name : ttserv:0
  Creation Time : Tue Oct  9 23:30:23 2012
     Raid Level : raid10
   Raid Devices : 4

 Avail Dev Size : 5840999786 (2785.21 GiB 2990.59 GB)
     Array Size : 5840999424 (5570.41 GiB 5981.18 GB)
  Used Dev Size : 5840999424 (2785.21 GiB 2990.59 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
   Unused Space : before=1968 sectors, after=19519631 sectors
          State : clean
    Device UUID : 1a67153d:8d15019a:349926d5:e22dd321

    Update Time : Tue Jan 14 22:49:49 2020
       Checksum : 6ddb36ea - correct
         Events : 2864

         Layout : near=2
     Chunk Size : 512K

   Device Role : Active device 1
   Array State : AA.. ('A' == active, '.' == missing, 'R' == replacing)



Cheers Rickard


Den tors 16 jan. 2020 kl 11:41 skrev Rickard Svensson <myhex2020@gmail.com>:
>
> Hi, thanks again :)
>
> The server is shut down, will copy the two broken disks.
> I think (and hope) there has been a small amount of writing since the
> problems occurred.
>
> Unexpected problem with the names of ddrescue, but the apt-get package
> in Debian called gddrescue, the program is called ddrescue.
> I became uncertain because you mention that it works like dd, but it
> doesn't use  if=foo of=bar  like regular dd?
> Anyway the program  ddrescue --help  refers to the homepage
> http://www.gnu.org/software/ddrescue/ddrescue.html  which I assume is
> right one..?
> And there are a lot of options, any tips on some special ones I should use?
>
> I also wonder if it is right to let mdadm try to recover from all four
> disks, the first one to stop working where three days before I
> discovered it.
> Isn't it better to just use three disks, the two disks that are ok,
> and the last disk that got too many write errors the night before I
> discovered everything?
>
> Otherwise, you have confirmed/clarified that everything seems to work
> the way I hoped.
> And I will read up on all the news in mdadm, and dm-integrity sounds
> interesting. Thanks!
>
> Cheers Rickard

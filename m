From: Bernd <berndman80@gmx.de>
Subject: Fwd: Re: Fwd: Please Help! Degraded Raid6
Date: Thu, 04 May 2017 09:58:11 +0200
Message-ID: <2092E0FF-27C8-41C8-BC73-A3222FB9214C@gmx.de>
References: <05DCE993-EEA8-420F-BB41-63612E361394@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <05DCE993-EEA8-420F-BB41-63612E361394@gmx.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Andreas.Klauer@metamorpher.de
List-Id: linux-raid.ids




-------- Ursprüngliche Nachricht --------
Von: Bernd <berndman80@gmx.de>
Gesendet: 3. Mai 2017 00:53:04 MESZ
An: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Betreff: Re: Fwd: Please Help! Degraded Raid6

Hello, do this help?

berndman@berndman:~$ sudo mdadm --examine /dev/sd[a-z]1
[sudo] password for berndman: 
/dev/sda1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 26f8d8f1:530a3a85:31e4df5e:adc64cb8                                                                                                                                                                                                                          
           Name : berndman:0  (local to host berndman)                                                                                                                                                                                                                         
  Creation Time : Wed Dec 19 20:39:11 2012                                                                                                                                                                                                                                     
     Raid Level : raid6                                                                                                                                                                                                                                                        
   Raid Devices : 8                                                                                                                                                                                                                                                            
                                                                                                                                                                                                                                                                               
 Avail Dev Size : 3907025072 (1863.01 GiB 2000.40 GB)                                                                                                                                                                                                                          
     Array Size : 23442112512 (11178.07 GiB 12002.36 GB)                                                                                                                                                                                                                       
  Used Dev Size : 3907018752 (1863.01 GiB 2000.39 GB)                                                                                                                                                                                                                          
    Data Offset : 2048 sectors                                                                                                                                                                                                                                                 
   Super Offset : 8 sectors                                                                                                                                                                                                                                                    
          State : active                                                                                                                                                                                                                                                       
    Device UUID : 529d3611:a91ea3d1:5a643bf9:2c66715c                                                                                                                                                                                                                          
                                                                                                                                                                                                                                                                               
    Update Time : Fri Mar 31 14:56:50 2017                                                                                                                                                                                                                                     
       Checksum : c781f805 - correct                                                                                                                                                                                                                                           
         Events : 1686                                                                                                                                                                                                                                                         
                                                                                                                                                                                                                                                                               
         Layout : left-symmetric                                                                                                                                                                                                                                               
     Chunk Size : 4096K                                                                                                                                                                                                                                                        
                                                                                                                                                                                                                                                                               
   Device Role : Active device 2                                                                                                                                                                                                                                               
   Array State : AAAAAAA. ('A' == active, '.' == missing)                                                                                                                                                                                                                      
/dev/sdb1:                                                                                                                                                                                                                                                                     
          Magic : a92b4efc                                                                                                                                                                                                                                                     
        Version : 1.2                                                                                                                                                                                                                                                          
    Feature Map : 0x0                                                                                                                                                                                                                                                          
     Array UUID : 26f8d8f1:530a3a85:31e4df5e:adc64cb8                                                                                                                                                                                                                          
           Name : berndman:0  (local to host berndman)                                                                                                                                                                                                                         
  Creation Time : Wed Dec 19 20:39:11 2012
     Raid Level : raid6
   Raid Devices : 8

 Avail Dev Size : 3907025072 (1863.01 GiB 2000.40 GB)
     Array Size : 23442112512 (11178.07 GiB 12002.36 GB)
  Used Dev Size : 3907018752 (1863.01 GiB 2000.39 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : bb3dc649:52726bf3:5512b2c1:f0a7605e

    Update Time : Fri Mar 31 14:56:50 2017
       Checksum : ec3fdbec - correct
         Events : 1686

         Layout : left-symmetric
     Chunk Size : 4096K

   Device Role : Active device 6
   Array State : AAAAAAA. ('A' == active, '.' == missing)
/dev/sdc1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 26f8d8f1:530a3a85:31e4df5e:adc64cb8
           Name : berndman:0  (local to host berndman)
  Creation Time : Wed Dec 19 20:39:11 2012
     Raid Level : raid6
   Raid Devices : 8

 Avail Dev Size : 3907025072 (1863.01 GiB 2000.40 GB)
     Array Size : 23442112512 (11178.07 GiB 12002.36 GB)
  Used Dev Size : 3907018752 (1863.01 GiB 2000.39 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : cb730c6a:eb14ee35:4f1b3480:63e037c8

    Update Time : Fri Mar 31 14:56:50 2017
       Checksum : 7761f5e9 - correct
         Events : 1686

         Layout : left-symmetric
     Chunk Size : 4096K

   Device Role : Active device 5
   Array State : AAAAAAA. ('A' == active, '.' == missing)
/dev/sdd1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 26f8d8f1:530a3a85:31e4df5e:adc64cb8
           Name : berndman:0  (local to host berndman)
  Creation Time : Wed Dec 19 20:39:11 2012
     Raid Level : raid6
   Raid Devices : 8

 Avail Dev Size : 3907025072 (1863.01 GiB 2000.40 GB)
     Array Size : 23442112512 (11178.07 GiB 12002.36 GB)
  Used Dev Size : 3907018752 (1863.01 GiB 2000.39 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : 61ef95f8:b5d2477b:e4a454f1:34f2b27b

    Update Time : Fri Mar 31 14:56:50 2017
       Checksum : 6fe0caac - correct
         Events : 1686

         Layout : left-symmetric
     Chunk Size : 4096K

   Device Role : Active device 1
   Array State : AAAAAAA. ('A' == active, '.' == missing)
/dev/sde1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 26f8d8f1:530a3a85:31e4df5e:adc64cb8
           Name : berndman:0  (local to host berndman)
  Creation Time : Wed Dec 19 20:39:11 2012
     Raid Level : raid6
   Raid Devices : 8

 Avail Dev Size : 3907025072 (1863.01 GiB 2000.40 GB)
     Array Size : 23442112512 (11178.07 GiB 12002.36 GB)
  Used Dev Size : 3907018752 (1863.01 GiB 2000.39 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : 7c16aad2:99309271:a8805e9a:f8be7e51

    Update Time : Fri Mar 31 14:56:50 2017
       Checksum : bf14f834 - correct
         Events : 1686

         Layout : left-symmetric
     Chunk Size : 4096K

   Device Role : Active device 3
   Array State : AAAAAAA. ('A' == active, '.' == missing)
/dev/sdf1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 26f8d8f1:530a3a85:31e4df5e:adc64cb8
           Name : berndman:0  (local to host berndman)
  Creation Time : Wed Dec 19 20:39:11 2012
     Raid Level : raid6
   Raid Devices : 8

 Avail Dev Size : 3907025072 (1863.01 GiB 2000.40 GB)
     Array Size : 23442112512 (11178.07 GiB 12002.36 GB)
  Used Dev Size : 3907018752 (1863.01 GiB 2000.39 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : 5c3a8490:3b33d565:4fb9c177:859e3155

    Update Time : Fri Mar 31 14:56:50 2017
       Checksum : 524836e7 - correct
         Events : 1686

         Layout : left-symmetric
     Chunk Size : 4096K

   Device Role : Active device 0
   Array State : AAAAAAA. ('A' == active, '.' == missing)
mdadm: No md superblock detected on /dev/sdg1.
/dev/sdh1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x2
     Array UUID : 26f8d8f1:530a3a85:31e4df5e:adc64cb8
           Name : berndman:0  (local to host berndman)
  Creation Time : Wed Dec 19 20:39:11 2012
     Raid Level : raid6
   Raid Devices : 8

 Avail Dev Size : 3907025072 (1863.01 GiB 2000.40 GB)
     Array Size : 23442112512 (11178.07 GiB 12002.36 GB)
  Used Dev Size : 3907018752 (1863.01 GiB 2000.39 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
Recovery Offset : 0 sectors
          State : clean
    Device UUID : 2283bdef:86a7c96b:d8ef0a1b:3651dd62

    Update Time : Tue Sep 29 15:46:56 2015
       Checksum : 65a01e2f - correct
         Events : 843

         Layout : left-symmetric
     Chunk Size : 4096K

   Device Role : Active device 7
   Array State : AAAAAAAA ('A' == active, '.' == missing)
/dev/sdi1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 26f8d8f1:530a3a85:31e4df5e:adc64cb8
           Name : berndman:0  (local to host berndman)
  Creation Time : Wed Dec 19 20:39:11 2012
     Raid Level : raid6
   Raid Devices : 8

 Avail Dev Size : 3907025072 (1863.01 GiB 2000.40 GB)
     Array Size : 23442112512 (11178.07 GiB 12002.36 GB)
  Used Dev Size : 3907018752 (1863.01 GiB 2000.39 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : bade4a58:bce5a0a2:121368d5:f6ad5857

    Update Time : Fri Mar 31 14:55:06 2017
       Checksum : b6a7f695 - correct
         Events : 1685

         Layout : left-symmetric
     Chunk Size : 4096K

   Device Role : Active device 4
   Array State : AAAAAAA. ('A' == active, '.' == missing)
berndman@berndman:~$ 

Am 3. Mai 2017 00:01:54 MESZ schrieb Andreas Klauer <Andreas.Klauer@metamorpher.de>:
>On Tue, May 02, 2017 at 11:11:10PM +0200, Bernd wrote:
>> berndman@berndman:~$ sudo mdadm --examine /dev/sd[a-z]
>
>You're using the wrong devices in your commands 
>so the output is not the least bit interesting.
>
>> /dev/sda:
>>    MBR Magic : aa55
>> Partition[0] :   3907027120 sectors at         2048 (type fd)
>> /dev/sdb:
>>    MBR Magic : aa55
>> Partition[0] :   3907027120 sectors at         2048 (type fd)
>
>> /dev/sdh:
>>           Magic : a92b4efc
>>         Version : 1.2
>>     Feature Map : 0x2
>>      Array UUID : 26f8d8f1:530a3a85:31e4df5e:adc64cb8
>
>Well except for this but need all of them.
>
>>     Update Time : Fri Jul 10 22:32:34 2015
>
>I hope it's not yet another case of a drive dropped out back 
>in 2015 and you never doing anything about it in two years... 
>Monitoring and instant email notification, is it that difficult?
>
>Regards
>Andreas Klauer

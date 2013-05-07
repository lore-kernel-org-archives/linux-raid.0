From: Andreas Boman <aboman@midgaard.us>
Subject: Re: Failed during rebuild (raid5)
Date: Mon, 06 May 2013 22:08:11 -0400
Message-ID: <5188620B.4050206@midgaard.us>
References: <51839E4F.7050102@midgaard.us> <CANU9nTneT2CRWJhdN=d87Hb7W9M+apQH+fRE-S+sieZ-W6+hjg@mail.gmail.com> <51866602.8000704@midgaard.us> <518693EF.6090802@midgaard.us> <518721CD.2040108@turmel.org> <51878BD0.9010809@midgaard.us> <5187A3D2.6060109@turmel.org> <5188189D.1060806@midgaard.us> <51884D49.3090602@turmel.org> <5188556A.7050605@midgaard.us> <51885CDB.8040508@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51885CDB.8040508@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 05/06/2013 09:46 PM, Phil Turmel wrote:
> Fortunately, these new drives are bigger than the originals, so you 
> can put the partition at sector 2048 and still have it the same size 
> as the originals. Warning: v0.90 has problems with partitions greater 
> than 2GB in some kernel versions. When you are ready to fix your 
> overall partition alignment issues, you probably want to switch to 
> v1.1 or v1.2 metadata as well. [trim /] 
Ok, this is not great news.. I'll have to fix that. Later.

My ddrescue problem remains however, I'm still unable to get my degraded 
array online with the ddrescued disk since I'm missing the md superblock 
on that disk.

/Andreas

mdadm -E /dev/sdf1
mdadm: No md superblock detected on /dev/sdf1.


./ddrescue -f -d /dev/sdb /dev/sdf /root/rescue.log


GNU ddrescue 1.17-rc3
Press Ctrl-C to interrupt
Initial status (read from logfile)
rescued:     1493 GB,  errsize:       0 B,  errors:       0
Current status
rescued:     1493 GB,  errsize:       0 B,  current rate:      512 B/s
    ipos:   942774 MB,   errors:       0,    average rate:      579 B/s
    opos:   942774 MB,    time since last successful read:       0 s
Copying non-tried blocks..

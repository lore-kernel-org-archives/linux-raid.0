From: Andreas Boman <aboman@midgaard.us>
Subject: Re: Failed during rebuild (raid5)
Date: Sun, 05 May 2013 10:00:34 -0400
Message-ID: <51866602.8000704@midgaard.us>
References: <51839E4F.7050102@midgaard.us> <CANU9nTneT2CRWJhdN=d87Hb7W9M+apQH+fRE-S+sieZ-W6+hjg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CANU9nTneT2CRWJhdN=d87Hb7W9M+apQH+fRE-S+sieZ-W6+hjg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ole Tange <tange@binf.ku.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 05/03/2013 08:26 AM, Ole Tange wrote:
> On Fri, May 3, 2013 at 1:23 PM, Andreas Boman<aboman@midgaard.us>  wrote:
>
>> This morning I came up to see the array degraded with two missing drives,
>> another failed during the rebuild.
> I just started this page for dealing with situations like yours:
> https://raid.wiki.kernel.org/index.php/Recovering_a_failed_software_RAID
>
>
> /Ole

After having ddrescue running all night, it dropped to copying at a rate 
of 512B/s. I interrupted it and restarted, it stays at that speed. shows 
no errors:

    Press Ctrl-C to interrupt
           Initial status (read from logfile)
     rescued:   557052 MB,  errsize:       0 B,  errors:       0
     Current status
     rescued:     1493 GB,  errsize:       0 B,  current rate:      512 B/s
        ipos:   937316 MB,   errors:       0,    average rate:   16431 kB/s
           opos:   937316 MB,     time from last successful read:       0 s
           Copying non-tried blocks...


However that is much too slow...

Then, I decided to take a look at the superblocks and to my horror 
discovered this:

# mdadm --examine /dev/sd[b-g] >>raid.status
mdadm: No md superblock detected on /dev/sdb.
mdadm: No md superblock detected on /dev/sdc.
mdadm: No md superblock detected on /dev/sdd.
mdadm: No md superblock detected on /dev/sde.
mdadm: No md superblock detected on /dev/sdf.
mdadm: No md superblock detected on /dev/sdg.

Can I recover still? What is going on here?

Thanks,
Andreas


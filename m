From: "Scott Bolander" <scott@bolanderhome.com>
Subject: Re: Software RAID crash > /dev/md0: Invalid argument
Date: Thu, 16 Sep 2004 21:07:18 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1417.10.0.0.1.1095383238.squirrel@10.0.0.1>
References: <52074.10.0.0.151.1095334249.squirrel@10.0.0.151>
    <20040916130214.GA21249@percy.comedia.it>
    <Pine.LNX.4.56.0409161432180.32100@lion.drogon.net>
    <16714.12766.81435.53105@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16714.12766.81435.53105@cse.unsw.edu.au>
To: Tech Linux <tech@cglug.org>, Linux Raid <linux-raid@vger.kernel.org>
Cc: tom@dentar.com
List-Id: linux-raid.ids

Hey guys - it's been fixed.  Your help and some good work by a Tom
Glascock (www.dentar.com) got it fixed.  It is regenerating now. 
Basically mdadm and a custom kernel was involved.

Scott Bolander
Computer Services of Cincinnati
http://www.cincysystems.com
scott@bolanderhome.com
513-266-6656
"I said, 'government is powerless to protect you,' not powerless to punish
you." --Chief Wiggum, The Simpsons

Neil Brown said:
> On Thursday September 16, gordon@drogon.net wrote:
>> On Thu, 16 Sep 2004, Luca Berra wrote:
>>
>> > On Thu, Sep 16, 2004 at 07:30:49AM -0400, Scott Bolander wrote:
>> > >I have a Mandrake 10 server with a 40gb boot drive and a three 200gb
>> disk
>> > >software raid 5 array using reiserfs.  A disk went bad; so i have
>> replaced
>> > >it.
>> > >
>> > >Doing the normal things to get it back up don't work:
>> > >
>> > >[root@server root]#raidhotadd /dev/md0 /dev/hdg
>> > ....
>> > ># cat /etc/raidtab
>> > >raiddev       /dev/md0
>> > >raid-level    5
>> > >chunk-size    128k
>> > >persistent-superblock 1
>> > >nr-raid-disks 3
>> > >    device    /dev/hdg1
>> > >    raid-disk 0
>> > >    device    /dev/hdi1
>> > >    raid-disk 1
>> > >    device    /dev/hdk1
>> > >    raid-disk 2
>> > >
>> > so you replaced the first disk in the array?
>> > raidtools are not capable of handling this.
>> > switch to mdadm
>>
>> Er - Maybe I'm missing something (like the original message in this
>> thread), but I've successfully used raidtools to raidhotremove and
>> raidhotadd the first drive (and others) in a raid5 set.., Once on a real
>> 'hot' system, a server with SCSI drives which I didn't power cycle, and
>> on
>> IDE systems where I've done a sequence of raidhotremove, power down,
>> change physical drive, boot up, cfdisk new drive, then raidhotadd...
>
> The problem is with "raidstart", not "raidhotremove".
> If you use auto-detect then you won't have a problem.
> If you use raidstart to start your arrays, you could have a problem.
>
> NeilBrown
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



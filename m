From: Luca Berra <bluca@comedia.it>
Subject: Re: Linear RAID (was Re: bad /proc/mdstat message)
Date: Mon, 12 Jan 2004 22:21:20 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040112212119.GA6697@percy.comedia.it>
References: <20040112193805.GB1174@percy.comedia.it> <Pine.GSO.4.31.0401121348500.10347-100000@staff2.cso.uiuc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.GSO.4.31.0401121348500.10347-100000@staff2.cso.uiuc.edu>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Jan 12, 2004 at 02:01:19PM -0600, Sharif Islam wrote:
>> ># cat /proc/mdstat
>> >Personalities : [linear] [raid0]
>> >read_ahead 1024 sectors
>> >Event: 1
>
>> where does this line come from?
>> are you running a vanilla or patched kernel? which version?
>
>No patching.
>
># uname -r
>2.4.21-4.ELsmp
>Red Hat Enterprise Linux AS release 3
heavily patched i would say.
complain to redhat since they seem to patch kernels and not userland
tools :)

>Few other things I noticed while playing with linear raid. I haven't
>seen much documentation online about it, so bare with me. It is a test
>machine so I am not worried about data loss or things like that.
>
>1. The raid creation process was very quick, unlike RAID 1 and RAID 5.
>2. Every time I reboot the raid partition doesn't get mounted. However,
>if I run
>mdadm -Cv  -llinear -n6 /dev/md0 /dev/hd{e,f,g,h,k,l}
>and
>mount /dev/md0 /raid
>it comes back again with all my data.

redhat by default used raidtab and raidtools to start raid devices, i
don't know if they changed this for AS3

>I included the partition in /etc/fstab, but that gives error. Also my
>rc.local has mdadm -As + mount command. That doesn't have any effect
>either.
i think you don't have a correct mdadm.conf file
to create one from scratch use
echo "DEVICE partitions" > /etc/mdadm.conf
mdadm  --examine  --scan --config=partitions | grep "^ARRAY" >> /etc/mdadm.conf

>3. I get the following warning message when I run
>the mdadm -Cv command, for all the disks.
>
>mdadm: /dev/hdi appears to contain an ext2fs file system
>    size=120103040K  mtime=Mon Jan 12 12:42:37 2004
>...
>Continue creating array?
>
>I hit yes, and my array is back. Here mtime is the last time my array
>was up.
you should mdadm -A to start arrays, not mdadm -C


-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \

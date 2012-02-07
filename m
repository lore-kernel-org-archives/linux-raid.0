From: Asdo <asdo@shiftmail.org>
Subject: Re: Some md/mdadm bugs
Date: Tue, 07 Feb 2012 18:13:05 +0100
Message-ID: <4F315BA1.9010300@shiftmail.org>
References: <4F2ADF45.4040103@shiftmail.org>
 <20120203081717.195bfec8@notabene.brown> <4F2B1519.5010500@shiftmail.org>
 <4F3008DA.8060402@shiftmail.org> <4F30204A.1060206@shiftmail.org>
 <20120207093156.290bd52b@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <20120207093156.290bd52b@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 02/06/12 23:31, NeilBrown wrote:
> On Mon, 06 Feb 2012 19:47:38 +0100 Asdo<asdo@shiftmail.org>  wrote:
>
>> One or two more bug(s) in 3.2.2
>> (note: my latest mail I am replying to is still valid)
>>
>> AUTO line in mdadm.conf does not appear to work any longer in 3.2.2
>> compared to mdadm 3.1.4
>> Now this line
>>
>> "AUTO -all"
>>
>> still autoassembles every array.
>> There are many arrays not declared in my mdadm.conf, and which are not
>> for this host (hostname is different)
>> but mdadm still autoassembles everything, e.g.:
>>
>> # mdadm -I /dev/sdr8
>> mdadm: /dev/sdr8 attached to /dev/md/perftest:r0d24, not enough to start
>> (1).
>>
>> (note: "perftest" is even not the hostname)
> Odd.. it works for me:
>
> # cat /etc/mdadm.conf
> AUTO -all
> # mdadm -Iv /dev/sda
> mdadm: /dev/sda has metadata type 1.x for which auto-assembly is disabled
> # mdadm -V
> mdadm - v3.2.2 - 17th June 2011
> #
>
> Can you show the complete output of the same commands (with sdr8 in place of sda of course :-)

I confirm the bug exists in 3.2.2
I compiled from source 3.2.2 from your git to make sure

("git checkout mdadm-3.2.2"  and then "make")

# ./mdadm -Iv /dev/sdat1
mdadm: /dev/sdat1 attached to /dev/md/perftest:sr50d12p1n1, not enough 
to start (1).
# ./mdadm --version
mdadm - v3.2.2 - 17th June 2011
# cat /etc/mdadm/mdadm.conf
AUTO -all


however the good news is that the bug is gone in 3.2.3 (still from your git)

# ./mdadm -Iv /dev/sdat1
mdadm: /dev/sdat1 has metadata type 1.x for which auto-assembly is disabled
# ./mdadm --version
mdadm - v3.2.3 - 23rd December 2011
# cat /etc/mdadm/mdadm.conf
AUTO -all






However in 3.2.3 there is another bug, or else I don't understand how 
AUTO works anymore:

# hostname perftest
# hostname
perftest
# cat /etc/mdadm/mdadm.conf
HOMEHOST <system>
AUTO +homehost -all
# ./mdadm -Iv /dev/sdat1
mdadm: /dev/sdat1 has metadata type 1.x for which auto-assembly is disabled
# ./mdadm --version
mdadm - v3.2.3 - 23rd December 2011


??
Admittedly perftest is not the original hostname for this machine but it 
shouldn't matter (does it go reading /etc/hostname directly?)...
Same result is if I make the mdadm.conf file like this

HOMEHOST perftest
AUTO +homehost -all


Else, If I create the file like this:

# cat /etc/mdadm/mdadm.conf
HOMEHOST <system>
AUTO +1.x homehost -all
# hostname
perftest
# ./mdadm -Iv /dev/sdat1
mdadm: /dev/sdat1 attached to /dev/md/sr50d12p1n1, not enough to start (1).
# ./mdadm --version
mdadm - v3.2.3 - 23rd December 2011


Now it works, BUT it works *too much*, look:

# hostname foo
# hostname
foo
# ./mdadm -Iv /dev/sdat1
mdadm: /dev/sdat1 attached to /dev/md/perftest:sr50d12p1n1, not enough 
to start (1).
# cat /etc/mdadm/mdadm.conf
HOMEHOST <system>
AUTO +1.x homehost -all
# ./mdadm --version
mdadm - v3.2.3 - 23rd December 2011


Same behaviour is if I make the mdadm.conf file with an explicit 
HOMEHOST name:
# hostname
foo
# cat /etc/mdadm/mdadm.conf
HOMEHOST foo
AUTO +1.x homehost -all
# ./mdadm -Iv /dev/sdat1
mdadm: /dev/sdat1 attached to /dev/md/perftest:sr50d12p1n1, not enough 
to start (1).
# ./mdadm --version
mdadm - v3.2.3 - 23rd December 2011



It does not seem correct behaviour to me.

If it is, could you explain how I should create the mdadm.conf file in 
order for mdadm to autoassemble *all* arrays for this host (matching 
`hostname` == array-hostname in 1.x) and never autoassemble arrays with 
different hostname?

Note I'm *not* using 0.90 metadata anywhere, so no special case is 
needed for that metadata version


I'm not sure if 3.1.4 had the "correct" behaviour... Yesterday it seemed 
to me it had, but today I can't seem to make it work anymore like I 
intended.





>
>> I have just regressed to mdadm 3.1.4 to confirm that it worked back
>> then, and yes, I confirm that 3.1.4 was not doing any action upon:
>> # mdadm -I /dev/sdr8
>> -->  nothing done
>> when the line in config was:
>> "AUTO -all"
>> or even
>> "AUTO +homehost -all"
>> which is the line I am normally using.
>>
>>
>> This is a problem in our fairly large system with 80+ HDDs and many
>> partitions which I am testing now which is full of every kind of arrays....
>> I am normally using : "AUTO +homehost -all"  to prevent assembling a
>> bagzillion of arrays at boot, also because doing that gives race
>> conditions at boot and drops me to initramfs shell (see below next bug).
>>
>>
>>
>>
>>
>> Another problem with 3.2.2:
>>
>> At boot, this is from a serial dump:
>>
>> udevd[218]: symlink '../../sdx13'
>> '/dev/disk/by-partlabel/Linux\x20RAID.udev-tmp' failed: File exists
>> udevd[189]: symlink '../../sdb1'
>> '/dev/disk/by-partlabel/Linux\x20RAID.udev-tmp' failed: File exists
>>
>> And sdb1 is not correctly inserted into array /dev/md0 which hence
>> starts degraded and so I am dropped into an initramfs shell.
>> This looks like a race condition... I don't know if this is fault of
>> udev, udev rules or mdadm...
>> This is with mdadm 3.2.2 and kernel 3.0.13 (called 3.0.0-15-server by
>> Ubuntu) on Ubuntu oneiric 11.10
>> Having also the above bug of nonworking AUTO line, this problem happens
>> a lot with 80+ disks and lots of partitions. If the auto line worked, I
>> would have postponed most of the assembly's at a very late stage in the
>> boot process, maybe after a significant "sleep".
>>
>>
>> Actually this race condition could be an ubuntu udev script bug :
>>
>> Here are the ubuntu udev rules files I could find, related to mdadm or
>> containing "by-partlabel":
> It does look like a udev thing more than an mdadm thing.
>
> What do
>     /dev/blkid -o udev -p /dev/sdb1
> and
>     /dev/blkid -o udev -p /dev/sdx12
>
> report?

Unfortunately I rebooted in the meanwhile.
Now sdb1 is assembled.

I am pretty sure sdb1 is really the same device of the old boot so here 
it goes:


# blkid -o udev -p /dev/sdb1
ID_FS_UUID=d6557fd5-0233-0ca1-8882-200cec91b3a3
ID_FS_UUID_ENC=d6557fd5-0233-0ca1-8882-200cec91b3a3
ID_FS_UUID_SUB=0ffdf74a-36f9-7a7a-9dbe-653bb37bdc8a
ID_FS_UUID_SUB_ENC=0ffdf74a-36f9-7a7a-9dbe-653bb37bdc8a
ID_FS_LABEL=hardstorage1:grubarr
ID_FS_LABEL_ENC=hardstorage1:grubarr
ID_FS_VERSION=1.0
ID_FS_TYPE=linux_raid_member
ID_FS_USAGE=raid
ID_PART_ENTRY_SCHEME=gpt
ID_PART_ENTRY_NAME=Linux\x20RAID
ID_PART_ENTRY_UUID=31c747e8-826f-48a3-ace0-c8063d489810
ID_PART_ENTRY_TYPE=a19d880f-05fc-4d3b-a006-743f0f84911e
ID_PART_ENTRY_NUMBER=1


regarding sdx13 (I suppose sdx12 was a typo) I don't guarantee it's the 
same device as in the previous boot, because it's in the SAS-expanders 
path...
However it will be something similar anyway

# blkid -o udev -p /dev/sdx13
ID_FS_UUID=527dd3b2-decf-4278-cb92-e47bcea21a39
ID_FS_UUID_ENC=527dd3b2-decf-4278-cb92-e47bcea21a39
ID_FS_UUID_SUB=c1751a32-0ef6-ff30-04ad-16322edfe9b1
ID_FS_UUID_SUB_ENC=c1751a32-0ef6-ff30-04ad-16322edfe9b1
ID_FS_LABEL=perftest:sr50d12p7n6
ID_FS_LABEL_ENC=perftest:sr50d12p7n6
ID_FS_VERSION=1.0
ID_FS_TYPE=linux_raid_member
ID_FS_USAGE=raid
ID_PART_ENTRY_SCHEME=gpt
ID_PART_ENTRY_NAME=Linux\x20RAID
ID_PART_ENTRY_UUID=7a355609-793e-442f-b668-4168d2474f89
ID_PART_ENTRY_TYPE=a19d880f-05fc-4d3b-a006-743f0f84911e
ID_PART_ENTRY_NUMBER=13


Ok now I understand that I have hundreds of partitions, all with the same
ID_PART_ENTRY_NAME=Linux\x20RAID
and I am actually surprised to see only 2 clashes reported in the serial 
console dump.
I confirm that once the system boots, only the last identically-named 
symlink survives (obviously)
---------
# ll /dev/disk/by-partlabel/
total 0
drwxr-xr-x 2 root root  60 Feb  7 16:54 ./
drwxr-xr-x 8 root root 160 Feb  7 10:59 ../
lrwxrwxrwx 1 root root  12 Feb  7 16:54 Linux\x20RAID -> ../../sdas16
---------
But strangely there were only 2 clashes reported by udev

It it also interesting that sdb1 was the only partition which failed to 
assemble among the 8 basic raid1 arrays I have at boot (which I know 
really well and I checked at last boot and confirmed all other 15 
partitions sd[ab][12345678] were present and correctly assembled in 
couples making /dev/md[01234567]) only sdb1 was missing, the same 
partition that reported the clash... that's a bit too much for a 
coincidence.

What do you think?

Thank you
A.

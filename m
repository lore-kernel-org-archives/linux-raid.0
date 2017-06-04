From: Paul Tonelli <paul@tonel.li>
Subject: Re: Recovery after accidental raid5 superblock rewrite
Date: Mon, 5 Jun 2017 00:58:03 +0200
Message-ID: <b8b6eb18-2952-86ee-5329-9e4f4c406c3d@tonel.li>
References: <2009e689-39b7-14fa-44bd-3288f96b9c91@tonel.li>
 <20170603212011.GA13271@metamorpher.de>
 <12fc0496-423a-bca6-ac57-ed40958645e7@tonel.li>
 <20170603232919.GA17108@metamorpher.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170603232919.GA17108@metamorpher.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello again, things are somewhat improving, I haven't got my data but I 
have got things to do:

On 06/04/2017 01:29 AM, Andreas Klauer wrote:
> Good catch. It would probably move the data offset.
>
> # truncate -s 3TB a b c
> # mdadm --create /dev/md42 --level=5 --raid-devices=2 /dev/loop[01]
> # mdadm --examine /dev/loop0
>      Data Offset : 262144 sectors
> # mdadm --grow /dev/md42 --raid-devices=3 --add /dev/loop2
> # mdadm --examine /dev/loop0
>      Data Offset : 262144 sectors
>       New Offset : 260096 sectors
>
> So on re-create you have to find and specify the correct --data-offset.
>
> How to determine the correct data offset? See if you can find LVM magic
> string "LABELONE" in the first 256MiB of the two disks you didn't
> dd-overwrite. That minus 512 bytes should be the correct offset.
>
> # hexdump -C /dev/some-pv
> 00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> *
> 00000200  4c 41 42 45 4c 4f 4e 45  01 00 00 00 00 00 00 00  |LABELONE........|
> 00000210  55 87 20 ff 20 00 00 00  4c 56 4d 32 20 30 30 31  |U. . ...LVM2 001|
>
> If unlucky it just happened to be in the drive you overwrite.
> In that case you have to xor the two others.
I  did find this one at that exact offset 26096 = (133169664 - 512)/512 
on the sdc drive (I rebuilt the xor by rebuilding  the raid, using 
overlays this time, it speeds up things a lot compared to my previous tests)

so this matches the commands. Now, after doing a pvcreate and a 
vgcfgrestore using the backup lvm file, e2fsck still refuses to run, but 
testdisk now finds a lot more superblocks:

    ext4                      267262 8729457661 8729190400
    ext4                      791550 8729981949 8729190400
    ext4                     1315838 8730506237 8729190400
    ext4                     1840126 8731030525 8729190400
    ext4                     6034430 8735224829 8729190400
    ext4                     6558718 8735749117 8729190400
    ext4                    12325886 8741516285 8729190400
    ext4                    20714494 8749904893 8729190400
    ext4                    32248830 8761439229 8729190400

  I also find the following backups superblocks when looping with e2fsck 
-b XXX:

using testdisk:

```
33408
98944
164480
230016
...
```

and they always have a +640 difference with what a new ext4 I would 
create on this volume doing:

```
mke2fs /dev/vg0/data -n:
Superblock backups stored on blocks:
         32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 
2654208,
         4096000, 7962624, 11239424, 20480000, 23887872, 71663616, 
78675968,
         102400000, 214990848, 512000000, 550731776, 644972544
```

So I believe I still have an offset issue of 640 sectors or something 
like this. Still digging this issue

I have tried to rebuild the ext4 superblock on top of the logical volume 
with the  "offset" option of mke2fs.ext4, but this did not work (e2fsck 
is still not running by itself):


```

mke2fs -E offset=640 -n -S /dev/vg0/data

```


I am still digging around to know where this 640 offset comes from, but 
as the last mail made me go forward significantly (thank you Andreas), I 
am trying again.

thanks again for reading me to this point.


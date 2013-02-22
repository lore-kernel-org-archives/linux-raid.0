From: "stone@heisl.org" <stone@heisl.org>
Subject: Re: Brocken Raid & LUKS
Date: Fri, 22 Feb 2013 11:31:22 +0100
Message-ID: <512748FA.2000709@heisl.org>
References: <5123A1CC.2000003@heisl.org> <5123FB71.3060509@heisl.org> <5124196F.6090000@turmel.org> <512516C2.3010105@heisl.org> <5125184A.6040707@turmel.org> <5125C6E9.4050802@heisl.org> <5125EBFD.3050802@heisl.org> <51262137.3040609@turmel.org> <51262CE0.3000809@heisl.org> <51263785.2010001@turmel.org> <51263D9D.1080002@heisl.org> <51263F7E.7040207@turmel.org> <5126421E.3040702@turmel.org> <51264C18.8000201@heisl.org> <51264E26.9050100@turmel.org> <51264EBF.9090000@heisl.org> <51264F7F.3020508@turmel.org> <512650A1.7070103@heisl.org> <51265132.7070706@turmel.org> <512656B5.4090505@heisl.org> <51265824.4030407@heisl.org> <51265B0B.9020108@turmel.org> <51265DA7.2030209@heisl.org> <512660B9.8090609@turmel.org> <5126629A.1090002@heisl.org> <51266360.9030402@turmel.org> <5126678D.9030101@heis
 l.org> <51266D73.5020700@turmel.org> <51267192.6090205@heisl.org> <51267467.9040603@turmel.org> <512675A6.1000801@heisl.org> <5126797C.8090105@heisl.org> <51269DE0.5070905@heisl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51269DE0.5070905@heisl.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

i have mdadm tested with this --chunk sizes: 64, 128 (no luks opned) 256,
> with 256 i get here this error ->
> fsck.ext4 -n -b 644972544 /dev/mapper/md2_nas
> e2fsck 1.41.14 (22-Dec-2010)
> Superblock has an invalid journal (inode 8).
> Clear? no
>
> fsck.ext4: Illegal inode number while checking ext3 journal for 
> /dev/mapper/md2_nas
>
> is this good? ;-)
>
> in the attachments is my hexdump for you...
>
>
to work on the live cd is very slow.
i will kick out my two system drives and take one new and install a old 
system (ubuntu 11.04, i think on this system i have created the first 
time the raid) to it.

do you have new infos from the hexdump or other news to try out some 
things the get the raid and the luks running?

thank you.

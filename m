From: Stone <stone@heisl.org>
Subject: Re: Brocken Raid & LUKS
Date: Thu, 21 Feb 2013 18:47:19 +0100
Message-ID: <51265DA7.2030209@heisl.org>
References: <5123A1CC.2000003@heisl.org> <5123BD1F.4060200@turmel.org> <5123E4E9.3020609@heisl.org> <5123EB92.5090505@turmel.org> <5123EF45.6080405@heisl.org> <5123F7C7.7000406@turmel.org> <5123FB71.3060509@heisl.org> <5124196F.6090000@turmel.org> <512516C2.3010105@heisl.org> <5125184A.6040707@turmel.org> <5125C6E9.4050802@heisl.org> <5125EBFD.3050802@heisl.org> <51262137.3040609@turmel.org> <51262CE0.3000809@heisl.org> <51263785.2010001@turmel.org> <51263D9D.1080002@heisl.org> <51263F7E.7040207@turmel.org> <5126421E.3040702@turmel.org> <51264C18.8000201@heisl.org> <51264E26.9050100@turmel.org> <51264EBF.9090000@heisl.org> <51264F7F.3020508@turmel.org> <512650A1.7070103@heisl.org> <51265132.7070706@turmel.org> <512656B5.4090505@heisl.org> <51265824.4030407@heisl.org> <51265B0B.9020108@turm
 el.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51265B0B.9020108@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Am 21.02.2013 18:36, schrieb Phil Turmel:
> On 02/21/2013 12:23 PM, Stone wrote:
>
>> i coud try to restore the superblock. the filesystem is ext4....
>> is this the right way?
>> mke2fs -n -j /dev/mapper/md2_nas
> Partly. (scary) Without the "-n", that will destroy everything!
>
>> mke2fs 1.41.14 (22-Dec-2010)
>> Filesystem label=
>> OS type: Linux
>> Block size=4096 (log=2)
>> Fragment size=4096 (log=2)
>> Stride=128 blocks, Stripe width=384 blocks
>> 366288896 inodes, 1465133568 blocks
>> 73256678 blocks (5.00%) reserved for the super user
>> First data block=0
>> Maximum filesystem blocks=0
>> 44713 block groups
>> 32768 blocks per group, 32768 fragments per group
>> 8192 inodes per group
>> Superblock backups stored on blocks:
>>          32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632,
>> 2654208,
>>          4096000, 7962624, 11239424, 20480000, 23887872, 71663616, 78675968,
>>          102400000, 214990848, 512000000, 550731776, 644972544
> But it does give you the locations of the backup superblocks.  Use these
> numbers, starting with 32768, as "xxxx" in:
>
> fsck.ext4 -n -b xxxx /dev
>
> Once you give it a superblock that hasn't been corrupted, it should be
> able to check the rest of the filesystem.  There will be damage near the
> beginning, and probably more damage where you had to put zeros.
>
> If it looks like that, do it again without "-n" to actually fix it.
>
> Phil
>
ok. i think i dont understand you not complete.
i restore now the superblock with --> fsck.ext4 -bv 4096000 
/dev/mapper/md2_nas

when this is done i make full filesystemcheck --> fsck.ext4 /dev/md2_nas
and answer the quest questions.

right?
thx.

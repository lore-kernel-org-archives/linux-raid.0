From: Phil Turmel <philip@turmel.org>
Subject: Re: Brocken Raid & LUKS
Date: Thu, 21 Feb 2013 13:00:25 -0500
Message-ID: <512660B9.8090609@turmel.org>
References: <5123A1CC.2000003@heisl.org> <5123BD1F.4060200@turmel.org> <5123E4E9.3020609@heisl.org> <5123EB92.5090505@turmel.org> <5123EF45.6080405@heisl.org> <5123F7C7.7000406@turmel.org> <5123FB71.3060509@heisl.org> <5124196F.6090000@turmel.org> <512516C2.3010105@heisl.org> <5125184A.6040707@turmel.org> <5125C6E9.4050802@heisl.org> <5125EBFD.3050802@heisl.org> <51262137.3040609@turmel.org> <51262CE0.3000809@heisl.org> <51263785.2010001@turmel.org> <51263D9D.1080002@heisl.org> <51263F7E.7040207@turmel.org> <5126421E.3040702@turmel.org> <51264C18.8000201@heisl.org> <51264E26.9050100@turmel.org> <51264EBF.9090000@heisl.org> <51264F7F.3020508@turmel.org> <512650A1.7070103@heisl.org> <51265132.7070706@turmel.org> <512656B5.4090505@heisl.org> <51265824.4030407@heisl.org> <51265B0B.9020108@turm
 el.org> <51265DA7.2030209@heisl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51265DA7.2030209@heisl.org>
Sender: linux-raid-owner@vger.kernel.org
To: Stone <stone@heisl.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 02/21/2013 12:47 PM, Stone wrote:
> Am 21.02.2013 18:36, schrieb Phil Turmel:

>> But it does give you the locations of the backup superblocks.  Use these
>> numbers, starting with 32768, as "xxxx" in:
>>
>> fsck.ext4 -n -b xxxx /dev
>>
>> Once you give it a superblock that hasn't been corrupted, it should be
>> able to check the rest of the filesystem.  There will be damage near the
>> beginning, and probably more damage where you had to put zeros.
>>
>> If it looks like that, do it again without "-n" to actually fix it.
>>
>> Phil
>>
> ok. i think i dont understand you not complete.
> i restore now the superblock with --> fsck.ext4 -bv 4096000
> /dev/mapper/md2_nas

No!  You must keep using "-n" until you have seen a mostly-clean report!
 We don't know yet that the chunk size is right.

Leaving off "-n" will simultaneously fix the superblock (and all other
backup copies) and continue to fix the rest of the filesystem.  You
mustn't do that with a wrong chunk size--it will damage much more.

> when this is done i make full filesystemcheck --> fsck.ext4 /dev/md2_nas
> and answer the quest questions.

> right?

No.

Just do the "fsck -n -b xxxx" combinations until you find a good
superblock.  That report will also show if there are many other errors.
 Expect scattered damage in the region < 384MB due to the wrong data
offset.  After that, there should only be errors where the new zeros
are, and maybe a few scattered errors from the original crash.  If there
many more errors, you have the wrong chunk size.

Phil

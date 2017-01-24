From: Salatiel Filho <salatiel.filho@gmail.com>
Subject: Re: Input/Output error reading from a clean raid
Date: Tue, 24 Jan 2017 18:15:11 -0300
Message-ID: <CAGmni9qF_LjdzYtsMJ9YmHoymG=SN6p2Mta-COEhbyReQFbNTA@mail.gmail.com>
References: <CAGmni9p7T5VQsSGQrwkpYgV=H4B-pjXtg8TxnuWst-FQSJh_fA@mail.gmail.com>
 <20170123010334.GA7546@metamorpher.de> <CAGmni9pazRfia++-s5Hn4FT+ubVzEhsnrQrKC3cSLja53-SizQ@mail.gmail.com>
 <20170123173411.GA9270@metamorpher.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170123173411.GA9270@metamorpher.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Jan 23, 2017 at 2:34 PM, Andreas Klauer
<Andreas.Klauer@metamorpher.de> wrote:
> On Mon, Jan 23, 2017 at 11:02:24AM -0300, Salatiel Filho wrote:
>> mdadm mdadm --examine-badblocks /dev/sdd1 /dev/sdg1 /dev/sdf1  /dev/sde1
>>
>> Bad-blocks on /dev/sdd1:
>>           1515723072 for 512 sectors
>> Bad-blocks on /dev/sde1:
>>           1515723072 for 512 sectors
>
> md believes you have bad blocks in identical places so it won't return
> whatever data is in these blocks. Thus you get read errors even if there
> is no bad block on the disk itself. Those bad block entries can be caused
> by cable or controller flukes, making temporary problems permanent...
>
> Personally I disable the bad block list everywhere.
>
> You can search this list for old messages regarding --examine-badblocks,
> this problem came up several times. Clearing the mdadm bad block list is
> worth a try. There's an undocumented option, update=force-no-bbl or such.
>
> Regards
> Andreas Klauer

Thanks all of you for the help.
Andreas, the force-no-bbl from mdadm 3.4 did the trick. I was able to
retrieve all files and their md5 matches, so it is great =)
I really think it is very unlikely that two different disks from two
different brands would have problems at exactly the same block.
I have a question, who populates the badblock list ? Is the check
action send to the /sys/block/md??/md/sync_action OR each read error
updates it ?
I think it was maybe some problem with the cable ( it is a 4 disks usb3 bay ).
Anyway, thank you very much !

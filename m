From: Philipp Wendler <ml@philippwendler.de>
Subject: Re: Yet another corrupt raid5
Date: Sun, 06 May 2012 11:21:15 +0200
Message-ID: <4FA6428B.802@philippwendler.de>
References: <4FA52031.2040608@philippwendler.de> <20120506160044.5b3a50c2@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120506160044.5b3a50c2@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

Am 06.05.2012 08:00, schrieb NeilBrown:
> On Sat, 05 May 2012 14:42:25 +0200 Philipp Wendler <ml@philippwendler.de>
> wrote:

>> I did not write on the disks, and did not execute any other commands
>> than --assemble, so from the other threads I guess that I can recreate
>> my raid with the data?
> 
> Yes, you should be able to.  Patience is important though, don't rush things.

Yes, that's why I didn't try anything myself and came to this list to ask.

>> Is the following command right:
>> mdadm -C -e 1.2 -5 -n 3 --assume-clean \
>>   -b /boot/md0_write_intent_map \
>>   /dev/sdb1 /dev/sdc1 /dev/sdd1
> 
> If you had an external write-intent bitmap and 3 drives is a RAID5 which
> were, in order , sdb1, sdc1, sdd1, then it is close.
> You want "-l 5" rather than "-5"
> You also want "/dev/md0" after the "-C".

Right, I just forgot that.

>> Do I need to specify the chunk-size?
>> If so, how can I find it out?
> 
> You cannot directly.  If you don't know it then you might need to try
> different chunk sizes until you get an array the presents your data correctly.
> I would try the chunksize that you think is probably correct, then "fsck -n"
> the filesystem (Assuming you are using extX).  If that works, mount read-only
> and have a look at some files.
> If it doesn't work, stop the array and try with a different chunk size.
> 
>> I think I might have used a custom chunk size back then.
>> -X on my bitmap says Chunksize is 2MB, is this the right chunk size?
> 
> No.  The bitmap chunk size (should be called a 'region size' I now think) is
> quite different from the RAID5 chunk size.
> 
> However the bitmap will record the total size of the array.  The chunksize
> must divide that evenly.  As you have 2 data disks, 2*chunksize must divide
> the total size evenly.  That will put an upper bound on the chunk size.
> 
> The "mdadm -E" claims the array to be 3907024896 sectors which is 1953512448K.
> That is 2^10K * 3 * 635909
> So that chunk size is at most 2^9K - 512K, which is currently the default.
> It might be less.

Ah, if the maximum size is equal to the default, then I am sure I used
this. I just was not sure if I made it bigger.

>> -X says there are 1375 dirty chunks.
>> Will mdadm be able to use this information, or are the dirty chunks just
>> lost?
> 
> No mdadm cannot use this information, but that is unlikely to be a problem.
> "dirty" doesn't mean that the parity is inconsistent with the data, it means
> that the parity might be inconsistent with the data.  It most cases it isn't.
> And as your array is not degraded, it doesn't matter anyway.
> 
> Once you have you array back together again you should
>    echo repair > /sys/block/md0/md/sync_action
> to check all the parity blocks and repair any that are found to be wrong.

Ok, I already thought that might be good.

>> Is the order of the devices on the --create command line important?
>> I am not 100% sure about the original order.
> 
> Yes, it is very import.
> Every time md starts the array it will print a "RAID conf printout" which
> lists the devices in order.  If you can find a recent one of those in kernel
> logs it will confirm the correct order.  Unfortunately it doesn't list the
> chunk size.

Good idea, I found it in the log. Was actually sdc1 sdb1 sdd1.

So I did it, and it worked out fine on the first try.
Luks could successfully decrypt it, fsck did not complain, mounting
worked and data is also fine. So hurrayy and big thanks ;-)
Now I am running the resync.

>> Thank you very much in advance for your help.
> 
> Good luck, and please accept my apologies for the bug that resulted in this
> unfortunate situation.

Hey, you don't need to apologize. I am a software developer as well, and
I know that such things might happen. And it didn't crash my data, so
everything is fine.

On the contrary, I want to thank all the developers here that you do all
this work I can use for free (in both senses) and now when there was a
problem, I could ask on this list and get such a extensive and helpful
answer, although I am this "yet another guy" that asks something for the
x-th time.

Greetings, Philipp

From: Roberto Nunnari <roberto.nunnari@supsi.ch>
Subject: Re: replacing drives
Date: Tue, 07 May 2013 12:22:14 +0200
Message-ID: <5188D5D6.3070900@supsi.ch>
References: <517A8EB5.8080100@supsi.ch> <20130426155347.GA9928@cthulhu.home.robinhill.me.uk> <5183E592.6020409@supsi.ch> <20130507075340.GA25772@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130507075340.GA25772@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 05/07/2013 09:53 AM, Robin Hill wrote:
> On Fri May 03, 2013 at 06:28:02PM +0200, Roberto Nunnari wrote:
>
>> Robin Hill wrote:
>>> The safest option would be:
>>>   - add in the new disks
>>>   - partition to at least the same size as your existing partitions (they
>>>     can be larger)
>>>   - add the new partitions into the arrays (they'll go in as spares)
>>>   - grow the arrays to 4 members (this avoids any loss of redundancy)
>>>   - wait for the resync to complete
>>>   - install grub/lilo/syslinux to the new disks
>>>   - fail and remove the old disk partitions from the arrays
>>>   - shrink the arrays back down to 2 members
>>>   - remove the old disks
>>>
>>> Then, if you're keeping the same number of partitions but increasing the
>>> size:
>>
>> Ok.. got here.
>>
>>>   - grow the arrays to fill the partitions
>>>   - grow the filesystems to fill the arrays
>>
>> Now the scary part.. so.. here I believe I should give the following
>> commands:
>>
>> mdadm --grow /dev/md0 --size=max
>> mdadm --grow /dev/md1 --size=max
>> mdadm --grow /dev/md2 --size=max
>>
> Yep, that's right. Make sure they've actually grown to the correct size
> before you progress though - I have had one occasion where using
> --size=max actually ended up shrinking the array and I had to manually
> work out the size to use in order to recover. That was using an older
> version of mdadm though, and I've not seen it happen since.
>
>> and after that
>>
>> fsck /dev/md0
>> fsck /dev/md1
>> fsck /dev/md2
>>
> You'll need 'fsck -f' here to force it to run.
>
>> and
>>
>> resize2fs /dev/md0
>> resize2fs /dev/md1
>> resize2fs /dev/md2
>>
>> Correct?
>>
> That should be it, yes.
>
>>
>> .. I still have a couple of questions:
>>
>> 1) how do I know if there's a bitmap?
>>
> Check /proc/mdstat - it'll report a bitmap - e.g.
> md6 : active raid6 sdg[0] sdf[6] sde[5] sdi[2] sdh[1]
>        11721052272 blocks super 1.2 level 6, 16k chunk, algorithm 2 [5/5] [UUUUU]
>        bitmap: 0/30 pages [0KB], 65536KB chunk
>
>> 2) at present /dev/md2 usage is 100%.. could that cause any problem?
>>
> It'll slow things down a bit but otherwise shouldn't be an issue.
>
>> 3) the new drives are 2TG drives.. As around one year ago had trouble on
>> linux (it was a server dated 2006 with CentOS 5) that would not handle
>> drives larger than 2TB.. I wander what happens if one day one drive
>> fails and the drive I'll buy to replace will be sold as 2TB but in
>> reality slightly larger than 2TB.. what will happen? Will linux fail
>> again to use a drive larger than 2TB?
>>
> All 2TB drives are exactly the same size. Since somewhere around the
> 320G/500G mark, all drive manufacturers have agreed to standardise the
> drive sizes, so getting mismatches like this is a thing of the past.
>
>> At present I'm on ubuntu 10.04, all software from standard distribution.
>>
>> Pitfalls I should know?
>>
> You'll need to use GPT partitions instead of standard MBR partitions for
> drives over 2TB, but there shouldn't be any issue with handling them.
>
> Cheers,
>      Robin
>

Thank you Robin.
Today I'm on holiday, but I will look at it tomorrow. :-)
Best regards.
Robi

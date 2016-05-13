From: Gioh Kim <gi-oh.kim@profitbricks.com>
Subject: Re: [RFC] super1: error handling for super-block loading
Date: Fri, 13 May 2016 17:15:03 +0200
Message-ID: <5735EF77.5030005@profitbricks.com>
References: <5734BFA3.1070405@profitbricks.com> <wrfj8tzfb0r0.fsf@redhat.com>
 <wrfj4ma39i4l.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wrfj4ma39i4l.fsf@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-raid@vger.kernel.org, Elmar Gerdes <elmar.gerdes@profitbricks.com>, Jinpu Wang <jinpu.wang@profitbricks.com>
List-Id: linux-raid.ids



On 12.05.2016 21:43, Jes Sorensen wrote:
> Jes Sorensen <Jes.Sorensen@redhat.com> writes:
>> Gioh Kim <gi-oh.kim@profitbricks.com> writes:
>> This is definitly not the right way to solve this problem. Error codes
>> are negative, and zero should _always_ mean success. Here you suddenly
>> introduced a new meaning to positive values of rv.
>>
>> I agree handling the error case needs to be fixed, so a better way to
>> solve this would be to bail out when the load_super() call fails and
>> stop there, the same way it does if add_internal_bitmap() fails.
>>
>> Ie. make it do something like this:
>>
>> 	rv = st->ss->load_super(st, fd2, NULL)==0) {
>> 	if (!rv) {
>> 		if (st->ss->add_internal_bitmap(
>> ....
>> 	} else {
>> 		pr_err("failed to load super-block.\n");
>> 		close(fd2);
>> 		return 1;
>> 	}
>>
>> Actually looking at that code, there's a couple of things to do to clean
>> it up and make it more readable.
> So I started looking at this, and ended up making a bunch of changes
> which should both resolve the issue you encountered and also cleans up
> this part of the code. I had to change add_internal_bitmap() to return 0
> on success, in order to get it cleaned up. Looks like we have a pile of
> inconsistencies on the 0 vs 1 as success returns ... guess we won't get
> bored.
>
> I just pushed this into git - let me know if it doesn't work for you.

GREATE!!

I pulled your patch and checked it works fine.
Following is how I tested.

1. I set one device as faulty.
# cat /proc/mdstat
Personalities : [raid1]
md101 : active raid1 dm-6[1] dm-1[0](F)
       16384 blocks super 1.2 [2/1] [_U]

unused devices: <none>

2. I disconnected storage.

3. recover bitmap
# mdadm --grow --bitmap=internal /dev/md101
Segmentation fault

4. new mdadm including your patch
# mdadm --grow --bitmap=internal /dev/md101
failed to load super-block.
# echo $?
1

Thank you very much.
Have a nice weekend!

-- 
Best regards,
Gioh Kim


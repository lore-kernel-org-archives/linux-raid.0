From: Justin Maggard <jmaggard10@gmail.com>
Subject: Re: [PATCH] Grow: fix resize of array component size to > 32bits
Date: Tue, 28 Oct 2014 16:47:06 -0700
Message-ID: <CAKgsxVQJp7C0_y9ZENG_ZpaSk9Zi0Aa1cf0-qwRFcHx1HB5v0A@mail.gmail.com>
References: <1414198502-10167-1-git-send-email-jmaggard10@gmail.com>
	<20141029091957.1c4cdeae@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20141029091957.1c4cdeae@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Oct 28, 2014 at 3:19 PM, NeilBrown <neilb@suse.de> wrote:
> On Fri, 24 Oct 2014 17:55:02 -0700 Justin Maggard <jmaggard10@gmail.com>
> wrote:
>
>> If the request --size to --grow an array to is larger
>> than 32bits, then mdadm may make the wrong choice and
>> use ioctl instead of setting component_size via sysfs
>> and the change is ignored.
>
> Can you explain exactly why the  current code is not sufficient?  When does
> it fail?
> If you include the explanation in a re-submission of the patch, and I am
> convinced, then I will gladly apply your patch.
>

To be honest, I can't figure out how the current comparison would have
ever worked at all. To illustrate, here's a simple test program:
-----
$ ./test 0xfffffffff
cast comparison did not detect truncation
bit comparison detected truncation

$ cat test.c
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

int main(int argc, char **argv)
{
unsigned long long ssize = strtoull(argv[1], NULL, 0);
int asize;

asize = ssize;
if (asize != (signed)ssize)
printf("cast comparison detected truncation\n");
else
printf("cast comparison did not detect truncation \n");
if (ssize & ~INT32_MAX)
printf("bit comparison detected truncation\n");
else
printf("bit comparison did not detect truncation \n");

return 0;
}
-----

I plugged lots of numbers in there, and I was never able to get the
current cast comparison to see a difference.

I ran into the issue by trying to grow the component size of a RAID
array from 1TB to 3TB, and it wouldn't work if I specified the size;
only using "max" worked.

I'm happy to re-submit if you'd like; I just thought it was a pretty
straightforward bug.  I guess what I'm saying is, I don't understand
why there *should* be a difference between assigning a unsigned long
long to an int variable, and casting that unsigned long long to a
signed type.  But

-Justin

> Thanks,
> NeilBrown
>
>>
>> Instead of using casts to check for a 32-bit overflow,
>> just check for set bits outside of INT32_MAX.
>> ---
>>  Grow.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/Grow.c b/Grow.c
>> index a9c8589..a614102 100644
>> --- a/Grow.c
>> +++ b/Grow.c
>> @@ -1818,7 +1818,7 @@ int Grow_reshape(char *devname, int fd,
>>               if (s->size == MAX_SIZE)
>>                       s->size = 0;
>>               array.size = s->size;
>> -             if (array.size != (signed)s->size) {
>> +             if (s->size & ~INT32_MAX) {
>>                       /* got truncated to 32bit, write to
>>                        * component_size instead
>>                        */
>

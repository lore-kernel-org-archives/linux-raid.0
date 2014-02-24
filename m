From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Subject: Re: feature re-quest for "re-write"
Date: Mon, 24 Feb 2014 14:40:17 +1100
Message-ID: <530ABF21.7030200@eyal.emu.id.au>
References: <alpine.DEB.2.02.1402211903030.15054@uplift.swm.pp.se> <530AA09B.3090708@fnarfbargle.com> <530AA460.602@eyal.emu.id.au> <530AAA55.2080508@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <530AAA55.2080508@fnarfbargle.com>
Sender: linux-raid-owner@vger.kernel.org
To: list linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I know that the i/o error is in /dev/sdi sector 261696 (consistent kernel and smart reports)
- /dev/sdi1 starts 2048 sectors later
- /dev/md127 is a 7 devs raid6 so there is 5 times as much data in the array until we hit
   the bad sector

# dd if=/dev/sdi1 of=/dev/null skip=$((1*(261696-2048))) count=1
dd: error reading '/dev/sdi1': Input/output error
0+0 records in
0+0 records out

The error is in one sector but 8 sectors will be read (a 4k buffer) so to get a clean read:

# dd if=/dev/sdi1 of=/dev/null skip=$((1*(261696-2048)+8)) count=1
1+0 records in
1+0 records out
512 bytes (512 B) copied, 5.5852e-05 s, 9.2 MB/s

# echo 3 >'/proc/sys/vm/drop_caches'
# dd if=/dev/md127 of=/dev/null skip=$((5*(261696-2048))) count=5
5+0 records in
5+0 records out
2560 bytes (2.6 kB) copied, 0.00380436 s, 673 kB/s

Now reading *much* more than necessary (first 10GB of the array):

# echo 3 >'/proc/sys/vm/drop_caches'
# dd if=/dev/md127 of=/dev/null count=$((20*1024*1024))
20971520+0 records in
20971520+0 records out
10737418240 bytes (11 GB) copied, 13.5717 s, 791 MB/s

Note that I do not expect to get an error because reading the array will not read the P/Q checksums
(it assumes good data and avoids the calculations overhead of verifying P/Q).

BTW, due to the use of a buffer layer I could have done the whole test using 4k blocks rather than
sectors, but it makes no difference in this case.

Eyal

On 02/24/14 13:11, Brad Campbell wrote:
> On 24/02/14 09:46, Eyal Lebedinsky wrote:
>> In my case (see earlier thread "raid check does not..." the pending
>> sector is early
>> in the device, in sector 261696 of a 4TB component (whole space in one
>> partition of
>> each component). So yes, inside the data area.
>>
>> I still have it reported in my daily logwatch, any idea what to try?
>>
>
> Yes, can you run a dd of the md device from well before to well after the theoretical position of the error?
>
> If the dd passes cleanly, it indicates the bad block is a parity block rather than a data block. That hopefully will help narrow down the scope of the search.
>
> Brad

-- 
Eyal Lebedinsky (eyal@eyal.emu.id.au)

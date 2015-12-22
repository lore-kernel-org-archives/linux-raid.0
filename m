From: Doug Dumitru <doug@easyco.com>
Subject: Re: best base / worst case RAID 5,6 write speeds
Date: Tue, 22 Dec 2015 10:33:24 -0800
Message-ID: <CAFx4rwQvTrUEskJxdc6CpvGu3uVYOJWEvHmMkqmNbmTgTVT0-Q@mail.gmail.com>
References: <CAE9DZUR=uSzYfdqFkVFdyXx+iKb1SeXxo5eX7M_nTw-fnWBwNA@mail.gmail.com>
 <CAK2H+ed-3Z8SR20t8rpt3Fb48c3X2Jft=qZoiY9emC2nQww1xQ@mail.gmail.com>
 <CAE9DZUQHBycc5+Z2YrJtWZRYxOUMu3pgnaEQSrsyeCZEv8vndA@mail.gmail.com>
 <CAE9DZUT1v+CFZOs33CC+JrWcX_WHBu+WW78AynkWqJN+LLoqDA@mail.gmail.com>
 <CAK2H+ecMvDLdYLhMtMQbP7Ygw-VohG7LGZ2n7H+LAXQ1waJK3A@mail.gmail.com>
 <CAE9DZUSbt7Kfwd9S3K_SXY7fVRk-vq5RhrPzKs4XO8uhyfPh3Q@mail.gmail.com>
 <CAE9DZUQxT_5L0bW5m9SZ_d2GU6sZS8k0qD=g+o112qM4V=cJkw@mail.gmail.com>
 <22128.11867.847781.946791@quad.stoffel.home> <CAE9DZURepRB3k-pBnRg2Tx8GCzAr6zCzv+LJy4mK4CDdAkBYVQ@mail.gmail.com>
 <22128.35881.182823.556362@quad.stoffel.home> <CAE9DZUQNBPNXFs69JRU0Q82TQ4RjAgpsc7voMgEzuhSZhmDjig@mail.gmail.com>
 <CAE9DZUQqeCY__+8Fwg51PJc6zAk0J2Apm2TE3CRvxbFUf-xDKQ@mail.gmail.com>
 <CAK2H+eeD2k4yzuvL4uF_qKycp6A=XPe8pVF_J-7Agi8Ze89PPQ@mail.gmail.com>
 <5672BB7A.4050808@turmel.org> <CAE9DZUQj2TNX4Wpk5xbaCVzEgPq2D6Co7ZDNaAy-TOaB4hwZeA@mail.gmail.com>
 <567339F0.9000209@turmel.org> <CAE9DZUS+gmgTLr_4EUgLcPCPWknoqg640mCMZX46cxXeyT6RQA@mail.gmail.com>
 <CAE9DZUQoYtt3U5rGBAUtTuLS2N2uA80e=EcDD73fHq0qn6YH2w@mail.gmail.com>
 <CAFx4rwT8xgwZ0OWaLLsZvhMskiwmY54MzHgnnEPaswByeRrXxQ@mail.gmail.com>
 <CAFx4rwTUiMo=1+JXpY3P5BhZYSQC8MVYhTJfdJd7gL6r9WSAiA@mail.gmail.com> <CAE9DZUQoNh2uU1h4okY0Fz5wzVv6-ZTnet9tS-dNQRHsLnPvNg@mail.gmail.com>
Reply-To: doug@easyco.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAE9DZUQoNh2uU1h4okY0Fz5wzVv6-ZTnet9tS-dNQRHsLnPvNg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dallas Clement <dallas.a.clement@gmail.com>, Robert Kierski <rkierski@cray.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Robert and Dallas,

The patch is an astonishingly single case and has a few usage caveats.

It only works when IO is precisely aligned on stripe boundaries.  If
anything is off-aligned, or even is an aligned case is encountered and
the stripe cache is not empty, the patch special case does not happen.
Second, the patch assumes that your application layer "makes sense"
and will not try to read a block that is in the middle of being
written.

The patch is in use on production servers, but with still more
caveats.  It turns off if the array is not clean or if a rebuild or
check is in progress.

Here is "raid5.c" from CentOS 7 with the patch applied:

https://drive.google.com/file/d/0B3T4AZzjEGVkbUYzeVZqbkIzN1E/view?usp=sharing

The modified areas are all inside of #ifdef EASYCO conditionals.  I
did not want to post this as a patch here as this is not appropriate
code for general use.

-- Some comments on stripe cache --

The stripe cache is a lot of overhead for this particular case, but
still works quite well compared to the alternatives.  Most benchmarks
I see with high-end raid cards cannot get to 1GB/sec either on raid-5
or raid-6.

Moving away from the stripe cache, especially dynamically, might open
up a nasty set of locking semantics.

-- Some comments on the raid background thread --

With most "reasonable" disk sets, the single raid thread is fine for
raid-5 at 1.8GB/sec.  If you want to get raid-6 faster, you need more
cores.  With my E5-1650 v3 I get just over 8 GB/sec with raid-6, most
of which is the raid-6 parity compute code.  Multi-socket E5s might do
a little better, but NUMA throws all sorts of interesting performance
tuning issues at our proprietary layer that is above raid.

-- Some comments on benchmarks --

If you run benchmarks like fio, you will get IO patterns that never
happen "in live datasets".  For example, a real file system will never
read a block that is being written.  This is a side effect of the file
systems use of pages as cache and writes that come from dirty pages.
Benchmarks just pump random numbers and overlaps are allowed.  This
means you must write code that survives the benchmarks, but optimizing
for a benchmark in some areas is dubious.

-- Some comments on RMW and SSDs --

One reason I wrote this patch was to keep SSDs happy.  If you write to
SSDs "perfectly" they never degrade and stay at full performance.  If
you do any random writing, the SSDs eventually need to do some space
management (garbage collection).  Even the 2-3% of RMW that I see
without the patch is enough to cost 3x of SSD wear with some drives.



Doug Dumitru
WildFire Storage


On Tue, Dec 22, 2015 at 8:48 AM, Dallas Clement
<dallas.a.clement@gmail.com> wrote:
> On Tue, Dec 22, 2015 at 12:15 AM, Doug Dumitru <doug@easyco.com> wrote:
>> My apologies for diving in so late.
>>
>> I routinely run 24 drive raid-5 sets with SSDs.  Chunk is set at 32K
>> and the applications only writes "perfect" 736K "stripes".  The SSDs
>> are Samsung 850 pros on dedicated LSI 3008 SAS ports and are at "new"
>> preconditioning (ie, they are at full speed) or just over 500 MB/sec.
>> CPU is a single E5-1650 v3.
>>
>> With stock RAID-5 code, I get about 1.8 GB/sec, q=4.
>>
>> Now this application is writing from kernel space
>> (generic_make_request w/ q waiting for completion callback).  There
>> are a lot of RMW operations happening here.  I think the raid-5
>> background thread is waking up asynchronously when only a part of the
>> write has been buffered into stripe cache pages.  The bio going into
>> the raid layer is a single bio, so nothing is being carved up on the
>> request end.  The raid-5 helper thread also saturates a cpu core
>> (which is about as fast as you can get with an E5-1650).
>>
>> If I patch raid5.ko with special case code to avoid the stripe cache
>> and just compute parity and go, the write throughput goes up above
>> 11GB/sec.
>>
>> This is obviously an impossible IO pattern for most applications, but
>> does confirm that the upper limit of (n-1)*bw is "possible", but not
>> with the current stripe cache logic in the raid layer.
>>
>> Doug Dumitru
>> WildFire Storage
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>> If I patch raid5.ko with special case code to avoid the stripe cache
>> and just compute parity and go, the write throughput goes up above
>> 11GB/sec.
>
> Hi Doug.  This is really quite astounding and encouraging!  Would you
> be willing to share your patch?  I am eager to give it a try for RAID
> 5 and 6.
>
>> Now this application is writing from kernel space
>> (generic_make_request w/ q waiting for completion callback).  There
>> are a lot of RMW operations happening here.  I think the raid-5
>> background thread is waking up asynchronously when only a part of the
>> write has been buffered into stripe cache pages.
>
> I am also anxious to hear from anyone who maintains the stripe cache
> code.  I am seeing similar behavior when I monitor writes of perfectly
> stripe-aligned blocks.  The # of RMWs are smallish and seem to vary,
> but still I do not expect to see any of them!



-- 
Doug Dumitru
EasyCo LLC

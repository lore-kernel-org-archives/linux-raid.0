From: Dallas Clement <dallas.a.clement@gmail.com>
Subject: Re: best base / worst case RAID 5,6 write speeds
Date: Mon, 14 Dec 2015 16:05:50 -0600
Message-ID: <CAE9DZUT1v+CFZOs33CC+JrWcX_WHBu+WW78AynkWqJN+LLoqDA@mail.gmail.com>
References: <CAE9DZUR=uSzYfdqFkVFdyXx+iKb1SeXxo5eX7M_nTw-fnWBwNA@mail.gmail.com>
	<CAE9DZUR1Nka=5mAB2WQHeFkinO0CzuH_GT1gRiVsuREQfgdGcQ@mail.gmail.com>
	<CAK2H+efF2dM1BsM7kzfTxMdQEHvbWRaVe7zJLTGcPZzafn2M6A@mail.gmail.com>
	<CAE9DZUQ+LOFWNQ2MpKoSx8j8RHVqkL15PO+jVjs7EkCQykG6VA@mail.gmail.com>
	<CAE9DZUQo4CojhuVkQ6y=gTEWG5qUkeu57wcZsqbXZtGD_V5JCQ@mail.gmail.com>
	<CAK2H+ec-zMbhxoFyHXLkdM-z-9cYYzNbPFhn19XjTHqrOMDZKQ@mail.gmail.com>
	<CAE9DZURK+bZ=4czbGojzW815Du1ascr5vzAPtQBw4ZDGyq0MAQ@mail.gmail.com>
	<22122.64143.522908.45940@quad.stoffel.home>
	<CAE9DZUQ=QynBKYJvq2JSnMaACKNpm+5yrhz+5x9Tx6_TK78mCg@mail.gmail.com>
	<22123.9525.433754.283927@quad.stoffel.home>
	<CAE9DZUTMnwpUX1e95c_i04uWREHd+aR8P2yCE_W-WmEbL6YRkw@mail.gmail.com>
	<CAE9DZUTTP1VhVgT56dyv6aLaM2V8peWSHaBg4xvXzGGUZcJ_hw@mail.gmail.com>
	<CAE9DZURuPGEL4bG=44ntbjp+51jktn36LFGfn11xFR-X9O9POw@mail.gmail.com>
	<566B6C8F.7020201@turmel.org>
	<CAE9DZURoHBRHq2M0spkTrBGoXmw9QjoARb_Gc6C6OvM9940aMA@mail.gmail.com>
	<566BA6E5.6030008@turmel.org>
	<CAE9DZUT42rCgjSacbs170ftzBtC4i83TRvk7CGeELqpYg3hVzw@mail.gmail.com>
	<CAK2H+edazVORrVovWDeTA8DmqUL+5HRH-AcRwg8KkMas=o+Cog@mail.gmail.com>
	<CAE9DZURBQxteib=hW6FskuJCJTxZDWhy5kMVy2u1hU5Nkg8Khg@mail.gmail.com>
	<CAK2H+ed-3Z8SR20t8rpt3Fb48c3X2Jft=qZoiY9emC2nQww1xQ@mail.gmail.com>
	<CAE9DZUQHBycc5+Z2YrJtWZRYxOUMu3pgnaEQSrsyeCZEv8vndA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAE9DZUQHBycc5+Z2YrJtWZRYxOUMu3pgnaEQSrsyeCZEv8vndA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Knecht <markknecht@gmail.com>
Cc: Phil Turmel <philip@turmel.org>, John Stoffel <john@stoffel.org>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Dec 14, 2015 at 3:20 PM, Dallas Clement
<dallas.a.clement@gmail.com> wrote:
> On Mon, Dec 14, 2015 at 3:02 PM, Mark Knecht <markknecht@gmail.com> wrote:
>>
>>
>> On Mon, Dec 14, 2015 at 12:55 PM, Dallas Clement
>> <dallas.a.clement@gmail.com> wrote:
>>>
>>> On Mon, Dec 14, 2015 at 2:40 PM, Mark Knecht <markknecht@gmail.com> wrote:
>>> >
>>> >
>>> > On Mon, Dec 14, 2015 at 12:14 PM, Dallas Clement
>>> > <dallas.a.clement@gmail.com> wrote:
>>> >>
>>> >> <SNIP>
>>> >>
>>> >> Hi Phil,  I ran blktrace while writing with dd to a RAID 5 device with
>>> >> 12 disks.  My chunk size is 128K.  So I set my block size to 128K *
>>> >> (12-2) = 1280k.   Here is the dd command I ran.
>>> >
>>> > Just curious but for my own knowledge if it's RAID5 why is it 12-2?
>>> >
>>> > - Mark
>>>
>>> > Just curious but for my own knowledge if it's RAID5 why is it 12-2?
>>>
>>> Shouldn't be.  It should have been 12-1 or writing 1408k.  Boy do I
>>> feel dumb.  Anyhow, when writing this value, no more RMWs.   Yay!
>>
>> I wasn't going to be so bold as to suggest the RMW's would go away but I'm
>> glad they did.
>>
>> So, now you can presumably gather new data looking at speed and post that,
>> correct?
>>
>> Cheers,
>> Mark
>
> Hmm, I think I may have spoke to soon.  I did a speed test using fio
> this time, same bs=1408k.  I see lots of RMWs in the trace this time.
> I did another larger dd transfer too, and I see some RMWs but not very
> many - maybe 4 or 5 for a 20GB transfer.
>
> It looks like the LBAs are increasing for the writes to the disks.
>
>   9,10   2     2816     0.737523948 27410  Q  WS 965888 + 256 [dd]
>   9,10   2     2817     0.737620583 27410  Q  WS 966144 + 256 [dd]
>   9,10   2     2818     0.737630651 27410  Q  WS 966400 + 256 [dd]
>   9,10   2     2819     0.737641625 27410  Q  WS 966656 + 256 [dd]
>   9,10   2     2820     0.737651603 27410  Q  WS 966912 + 256 [dd]
>   9,10   2     2821     0.737662735 27410  Q  WS 967168 + 256 [dd]
>   9,10   2     2822     0.737672709 27410  Q  WS 967424 + 256 [dd]
>   9,10   2     2823     0.737683881 27410  Q  WS 967680 + 256 [dd]
>   9,10   2     2824     0.737693896 27410  Q  WS 967936 + 256 [dd]
>   9,10   2     2825     0.737704484 27410  Q  WS 968192 + 256 [dd]
>   9,10   2     2826     0.737714348 27410  Q  WS 968448 + 256 [dd]
>
> The dd transfers do seem faster when using bs=1408k.  But need to
> collect some more data.

The speeds I am seeing with dd are definitely faster.  I was getting
about 333 MB/s when writing bs=2048k which was not chunk aligned.
When writing bs=1408k I am getting at least 750 MB/s.  Reducing the
RMWs certainly did help.  But this write speed is still far short of
the (12 - 1) * 150 MB/s = 1650 MB/s I am expecting for minimal to no
RMWs.  I probably am not able to saturate the RAID device with dd
though.

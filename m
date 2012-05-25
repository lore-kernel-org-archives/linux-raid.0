From: =?ISO-8859-1?Q?Patrik_Horn=EDk?= <patrik@dsl.sk>
Subject: Re: Sequential writing to degraded RAID6 causing a lot of reading
Date: Fri, 25 May 2012 18:07:42 +0200
Message-ID: <CAAOsTSnSj6CO=7J6KfNnD=WVuxjCh+5yTeuMqC+LaB=xByRzxA@mail.gmail.com>
References: <CAAOsTSmnbtejYvjoMpdOzrGFM0+PW45uuf-uBNkR4HUkgyaWDg@mail.gmail.com>
	<20120524144822.747b446b@notabene.brown>
	<CAAOsTSm47hy6YF-5fodB+2G6n1E=+Ces_PWsSo7F6GKEF_R1iA@mail.gmail.com>
Reply-To: patrik@dsl.sk
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAOsTSm47hy6YF-5fodB+2G6n1E=+Ces_PWsSo7F6GKEF_R1iA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

So Neil,

what do you think? Is this working as intended in this configuration?
If not, where can be problem?

BTW one other diff between my RAID5 and RAID6 I did not mention is
that I have LVM between filesystem and RAID6. There is no LVM in RAID5
case.

Thanks.

Patrik

On Thu, May 24, 2012 at 2:37 PM, Patrik Horn=EDk <patrik@dsl.sk> wrote:
> On Thu, May 24, 2012 at 6:48 AM, NeilBrown <neilb@suse.de> wrote:
>> On Wed, 23 May 2012 21:01:09 +0200 Patrik Horn=EDk <patrik@dsl.sk> w=
rote:
>>
>>> Hello boys,
>>>
>>> I am running some RAID6 arrays in degraded mode, one with
>>> left-symmetry layout and one with left-symmetry-6 layout. I am
>>> experiencing (potentially strange) behavior that degrades performan=
ce
>>> of both arrays.
>>>
>>> When I am writing sequentially a lot of data to healthy RAID5 array=
,
>>> it also reads internally a bit of data. I have data on arrays, so I
>>> only write through the filesystem. So I am not sure what causing th=
e
>>> reads, if writing through filesystem potentially causes skipping an=
d
>>> not writing whole stripes =A0or sometimes timing causes that the wh=
ole
>>> stripe is not written at the same time. But anyway there is only a
>>> small ratio of reads and the performance is almost OK.
>>>
>>> I cant test it with full healthy RAID6 array, because I dont have a=
ny
>>> at the moment.
>>>
>>> But when I write sequentially to RAID6 without one drive (again
>>> through filesystem) I get almost exactly the same amount of interna=
l
>>> reads as writes. Is it by design and is this expected behaviour? Wh=
y
>>> does it behave like this? It should behave exactly like healthy RAI=
D5,
>>> it should detect the writing of whole stripe and should not read
>>> (almost) anything.
>>
>> "It should behave exactly like healthy RAID5"
>>
>> Why do you say that? =A0Have you examined the code or imagined caref=
ully how
>> the code would work?
>>
>> I think what you meant to say "I expect it would behave exactly like=
 healthy
>> READ5". =A0That is a much more sensible statement. =A0It is even cor=
rect. =A0It
>> just your expectations that are wrong :-)
>> (philosophical note: always avoid the word "should" except when appl=
ying it
>> to yourself).
>
> What I meant by should was there is theoretical way it can work that
> way so it should work that way... :)
>
> I was implicitly referring to whole stripe write.
>
>> Firstly, degraded RAID6 with a left-symmetric layout is quite differ=
ent from
>> an optimal RAID5 because there are Q blocks sprinkled around and som=
e D
>> blocks missing. =A0So there will always be more work to do.
>>
>> Degraded left-symmetric-6 is quite similar to optimal RAID5 as the s=
ame data
>> is stored in the same place - so reading should be exactly the same.
>> However writing is generally different and the code doesn't make any=
 attempt
>> to notice and optimise cases that happen to be similar to RAID5.
>
> Actually I have left-symmetric-6 without one of the "regular" drives
> not the one with only Qs on it, so it should be similar to degraded
> RAID6 with a left-symmetric in this regard.
>
>> A particular issue is that while RAID5 does read-modify-write when u=
pdating a
>> single block in an array with 5 or more devices (i.e. it reads the o=
ld data
>> block and the parity block, subtracts the old from parity and adds t=
he new,
>> then writes both back), RAID6 does not. It always does a reconstruct=
-write,
>> so on a 6-device RAID6 it will read the other 4 data blocks, compute=
 P and Q,
>> and write them out with the new data.
>> If it did read-modify-write it might be able to get away with readin=
g just P,
>> Q, and the old data block - 3 reads instead of 4. =A0However subtrac=
ting from
>> the Q block is more complicated that subtracting from the P block an=
d has not
>> been implemented.
>
> OK, I did not know that. In my case I have 8 drives RAID6 degraded to
> 7 drives, so it would be plus to have it implemented the RAID5 way.
> But anyway I was thinking the whole-stripe detection should work in
> this case.
>
>> But that might not be the issue you are hitting - it simply shows th=
at RAID6
>> is different from RAID5 in important but non-obvious ways.
>>
>> Yes, RAID5 and RAID6 do try to detect whole-stripe write and write t=
hem out
>> without reading. =A0This is not always possible though.
>> Maybe if you told us how many devices were in your arrays (which may=
 be
>> import to understand exactly what is happening), what the chunk size=
 is, and
>> exactly what command you use to write "lots of data". =A0That might =
help
>> understand what is happening.
>
> The RAID5 is 5 drives, the RAID6 arrays are 7 of 8 drives, chunk size
> is 64K. I am using command dd if=3D/dev/zero of=3Dfile bs=3DX count=3D=
Y, it
> behaves the same for bs between 64K to 1 MB. Actually internal read
> speed from every drive is slightly higher that write speed, about cca
> 10%. The ratio between write speed to the array and write speed to
> individual drive is cca 5.5 - 5.7.
>
> I have enough free space on filesystem (ext3) so I guess I should be
> hitting whole stripes most of the time.
>
> Patrik
>
>> NeilBrown
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

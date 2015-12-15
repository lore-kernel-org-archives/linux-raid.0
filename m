From: Dallas Clement <dallas.a.clement@gmail.com>
Subject: Re: best base / worst case RAID 5,6 write speeds
Date: Mon, 14 Dec 2015 20:36:05 -0600
Message-ID: <CAE9DZUQxT_5L0bW5m9SZ_d2GU6sZS8k0qD=g+o112qM4V=cJkw@mail.gmail.com>
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
	<CAE9DZUT1v+CFZOs33CC+JrWcX_WHBu+WW78AynkWqJN+LLoqDA@mail.gmail.com>
	<CAK2H+ecMvDLdYLhMtMQbP7Ygw-VohG7LGZ2n7H+LAXQ1waJK3A@mail.gmail.com>
	<CAE9DZUSbt7Kfwd9S3K_SXY7fVRk-vq5RhrPzKs4XO8uhyfPh3Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAE9DZUSbt7Kfwd9S3K_SXY7fVRk-vq5RhrPzKs4XO8uhyfPh3Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Knecht <markknecht@gmail.com>
Cc: Phil Turmel <philip@turmel.org>, John Stoffel <john@stoffel.org>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Dec 14, 2015 at 5:25 PM, Dallas Clement
<dallas.a.clement@gmail.com> wrote:
> On Mon, Dec 14, 2015 at 4:17 PM, Mark Knecht <markknecht@gmail.com> wrote:
>>
>>
>> On Mon, Dec 14, 2015 at 2:05 PM, Dallas Clement <dallas.a.clement@gmail.com>
>> wrote:
>>>
>>> <SNIP>
>>>
>>> The speeds I am seeing with dd are definitely faster.  I was getting
>>> about 333 MB/s when writing bs=2048k which was not chunk aligned.
>>> When writing bs=1408k I am getting at least 750 MB/s.  Reducing the
>>> RMWs certainly did help.  But this write speed is still far short of
>>> the (12 - 1) * 150 MB/s = 1650 MB/s I am expecting for minimal to no
>>> RMWs.  I probably am not able to saturate the RAID device with dd
>>> though.
>>
>> But then you get back to all the questions about where you are on the drives
>> physically (inside vs outside) and all the potential bottlenecks in the
>> hardware. It
>> might not be 'far short' if you're on the inside of the drive.
>>
>> I have no idea about what vintage Cougar Point machine you have but there
>> are some reports about bugs that caused issues with a couple of the
>> higher hard drive interface ports on some earlier machines. Your nature
>> seems to be to generally build the largest configurations you can but Phil
>> suggested earlier and it might be appropriate here to disconnect a bunch of
>> drives and then do 1 drive, 2 drives, 3 drives and measure speeds. I seem
>> to remember you saying something about it working well until you added the
>> last drive so if you go this way I'd suggest physically disconnecting drives
>> you are not testing, booting up, testing, powering down, adding another
>> drive, etc.
>
> Hi Mark
>
>> But then you get back to all the questions about where you are on the drives
>> physically (inside vs outside) and all the potential bottlenecks in the
>> hardware. It
>> might not be 'far short' if you're on the inside of the drive.
>
> Perhaps.  But I was getting about 95 MB/s on the inside when I
> measured earlier.  Even with this number the write speed for RAID 5
> should be around 11 * 95 = 1045 MB/s.  Also, when I was running fio on
> individual disks concurrently, adding one in at a time, iostat was
> showing wMB/s to be around 160-170 MB/s.
>
>> I have no idea about what vintage Cougar Point machine you have but there
>> are some reports about bugs that caused issues with a couple of the
>> higher hard drive interface ports on some earlier machines.
>
> Hmm, I will need to look into that some more.
>
>> I'd suggest physically disconnecting drives you are not testing, booting up, testing, powering down, adding another drive, etc.
>
> Yes, I haven't tried that yet with RAID 5 or 6.  I'll give it a shot
> maybe starting with 4 disks, adding one at a time and measure the
> write speed.
>
> On another point, this blktrace program sure is neat!  A wealth of info here.

Hi Everyone.  I have some very interesting news to report.  I did a
little bit more playing around with fio, doing sequential writes to a
RAID 5 device with all 12 disks.  I kept the block size at the 128K
chunk aligned value of 1408K.  But this time I varied the queue depth.
These are my results for writing a 10 GB of data:

iodepth=1 => 642 MB/s, # of RMWs = 11

iodepth=4 => 1108 MB/s, # of RMWs = 6

iodepth=8 => 895 MB/s, # of RMWs = 7

iodepth=16 => 855 MB/s, # of RMWs = 11

iodepth=32 => 936 MB/s, # of RMWs = 11

iodepth=64 => 551 MB/s, # of RMWs = 5606

iodepth=128 => 554 MB/s, # of RMWs = 6333

As you can see, something goes terribly wrong with async i/o with
iodepth >= 64.  Btw, not to be contentious Phil, I have checked
multiple fio man pages and they clearly indicate that iodepth is for
async i/o which this is (libaio).  I don't see any mention of
sequential writes being prohibited with async i/o.  See
https://github.com/axboe/fio/blob/master/HOWTO.  However, maybe I'm
missing something and it sure looks from these results that there may
be a connection.

This is my fio job config:

[job]
ioengine=libaio
iodepth=128
prio=0
rw=write
bs=1408k
filename=/dev/md10
numjobs=1
size=10g
direct=1
invalidate=1

Incidentally, the very best write speed here (1108 MB/s with
iodepth=4) comes out to about 100 MB/s per disk, which is pretty close
to the worst case inner disk speed of 95.5 MB/s I had recorded
earlier.

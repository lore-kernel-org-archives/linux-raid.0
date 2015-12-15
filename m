From: Phil Turmel <philip@turmel.org>
Subject: Re: best base / worst case RAID 5,6 write speeds
Date: Tue, 15 Dec 2015 08:53:18 -0500
Message-ID: <56701B4E.8060007@turmel.org>
References: <CAE9DZUR=uSzYfdqFkVFdyXx+iKb1SeXxo5eX7M_nTw-fnWBwNA@mail.gmail.com>
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
 <CAE9DZUQxT_5L0bW5m9SZ_d2GU6sZS8k0qD=g+o112qM4V=cJkw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAE9DZUQxT_5L0bW5m9SZ_d2GU6sZS8k0qD=g+o112qM4V=cJkw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dallas Clement <dallas.a.clement@gmail.com>, Mark Knecht <markknecht@gmail.com>
Cc: John Stoffel <john@stoffel.org>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Dallas,

On December 14, 2015 9:36:05 PM EST, Dallas Clement

>Hi Everyone. I have some very interesting news to report. I did a
>little bit more playing around with fio, doing sequential writes to a
>RAID 5 device with all 12 disks. I kept the block size at the 128K
>chunk aligned value of 1408K. But this time I varied the queue depth.
>These are my results for writing a 10 GB of data:
>
>iodepth=1 => 642 MB/s, # of RMWs = 11
>
>iodepth=4 => 1108 MB/s, # of RMWs = 6
>
>iodepth=8 => 895 MB/s, # of RMWs = 7
>
>iodepth=16 => 855 MB/s, # of RMWs = 11
>
>iodepth=32 => 936 MB/s, # of RMWs = 11
>
>iodepth=64 => 551 MB/s, # of RMWs = 5606
>
>iodepth=128 => 554 MB/s, # of RMWs = 6333
>
>As you can see, something goes terribly wrong with async i/o with
>iodepth >= 64. Btw, not to be contentious Phil, I have checked
>multiple fio man pages and they clearly indicate that iodepth is for
>async i/o which this is (libaio). I don't see any mention of
>sequential writes being prohibited with async i/o. See
>https://github.com/axboe/fio/blob/master/HOWTO.

Hmmm. I misread that part. But do note the comment that you might not
achieve as many in-flight I/Os as you expect.

>However, maybe I'm
>missing something and it sure looks from these results that there may
>be a connection.
>
>This is my fio job config:
>
>[job]
>ioengine=libaio
>iodepth=128
>prio=0
>rw=write
>bs=1408k
>filename=/dev/md10
>numjobs=1
>size=10g
>direct=1
>invalidate=1
>
>Incidentally, the very best write speed here (1108 MB/s with
>iodepth=4) comes out to about 100 MB/s per disk, which is pretty close
>to the worst case inner disk speed of 95.5 MB/s I had recorded
>earlier.

Very interesting indeed. I wonder if the extra I/O in flight at high
depths is consuming all available stripe cache space, possibly not
consistently. I'd raise and lower that in various combinations with
various combinations of iodepth.  Running out of stripe cache will cause
premature RMWs.

Regards,

Phil

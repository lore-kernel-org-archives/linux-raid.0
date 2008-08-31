From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: I/O wait problem with hardware raid
Date: Sun, 31 Aug 2008 17:08:19 -0400
Message-ID: <48BB0843.3050008@tmr.com>
References: <48B75097.7000509@harvee.org> <48B995B9.2040600@tmr.com> <48BAAFB0.8060103@harvee.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <48BAAFB0.8060103@harvee.org>
Sender: linux-raid-owner@vger.kernel.org
To: "Eric S. Johansson" <esj@harvee.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Eric S. Johansson wrote:
> Bill Davidsen wrote:
>
>  =20
>> iowait means that there is a program waiting for I/O. That's all.=20
>>    =20
>
> I was under the impression that I/O wait created a blocking condition=
=2E
>  =20

I means a process is waiting for I/O, so that one is blocked. And often=
=20
it means that heavy disk access will slow down other disk i/o. But the=20
CPU involved in iowait is available for CPU-bound process (any process=20
which needs it).

One of the things Linux does poorly is to balance reads and writes. If=20
you are doing heavy writes you don't have reads jumping the queue and=20
getting donw in reasonable time. Use of the deadline i/o scheduler may=20
help this, as may making the dirty ratio _smaller_ to slow writes to le=
t=20
reads get run.

I played with allowing the reads to bypayy a certain number of writes t=
o=20
balance performance. It worked beautifully, and I could tune it for any=
=20
load, but I never got it to tune itself, so there was a always a=20
"jackpot case" which weorked WAY worse than standard. Needless to say I=
=20
never followed up on it, I haven't had inspiration.
>  =20
>> Of
>> course when you do a copy (regardless of software) the CPU is waitin=
g
>> for disk transfers. I'm not sure what you think you should debug, i/=
o
>> takes time, and if the program is blocked until the next input comes=
 in
>> it will enter the waitio state. If there is no other process to use =
the
>> available CPU it becomes waitio, which is essentially available CPU
>> cycles similar to idle.
>>
>> What exactly do you think is wrong?
>>    =20
>
> As I run rsync which increases the I/O wait state, the first thing I =
notice is
> that IMAP starts getting slow, users start experiencing failures in s=
ending
> e-mail, and the initial exchange for ssh gets significantly longer.
>
> All of these problems have both networking and file I/O in common and=
 I'm trying
> to separate out where the problem is coming from.  I have run netcat =
which has
> shown that the network throughput is not wonderful but that's a diffe=
rent
> problem for me to solve.  When I run netcat, there is no degradation =
of ssh,
> IMAP or SMTP response times. the problem shows up if I run CP or rsyn=
c internal
> source and target.   the problem becomes the worst when I'm doing rsy=
nc within
> the local filesystem and another rsync to an external rsync server.  =
At that
> point, the system becomes very close to unusable.
>
> Of course, I can throttle back rsync and regain some usability but I'=
m backing
> up a couple terabytes of information and it's a time-consuming proces=
s even with
> rsync and would like  it to run as quickly as possible. I should prob=
ably point
> out that the disk array is a relatively small raid five set up with s=
ix 1 TB
> drives.  Never did like raid five especially when it's on a bit of fi=
rmware.
> Can't wait for ZFS (or its equivalent) on linux to reach production q=
uality.
>
> from where I stand right now, this might be "it sucks but it's perfec=
tly
> normal".  In a situation with heavy disk I/O, I would expect anything=
 that
> accesses the disc to run slowly and in a more na=EFve moment, I thoug=
ht that the
> GUI wouldn't be hurt by heavy disk I/O and then I remembered that gno=
me and its
> kindred have lots of configuration files to read every time you move =
the mouse.  :-)
>
> Any case, the people that sign my check aren't happy because they spe=
nt all his
> money on an HP server and performs no better than an ordinary PC.  I'=
m hoping I
> can learn enough to give them a cogent explanation if I can't give th=
em a solution.
>  =20

Some of the tuning I suggested may help, perhaps a lot. If you have a=20
lot of memory you can fill it with dirty buffers and the response will=20
be a problem.
>
> I appreciate the help.
>  =20

Then let me know if any of the things I suggested help. Someone else ma=
y=20
have other ideas, I would cut the dirty ratio by half and see if it=20
makes any difference and for better or worse.
>
> ---eric
>
>  =20


--=20
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will stil=
l
  be valid when the war is over..." Otto von Bismark=20



--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

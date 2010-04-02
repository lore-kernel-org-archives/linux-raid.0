From: Learner Study <learner.study@gmail.com>
Subject: Re: Linux Raid performance
Date: Fri, 2 Apr 2010 14:37:40 -0700
Message-ID: <r2j7efa8a7d1004021437wf6ce1a58qda4c4614ab17d146@mail.gmail.com>
References: <r2v7efa8a7d1003311242vfa92024ar93ad2123a7b49806@mail.gmail.com>
	<20100331201539.GA19395@rap.rap.dk> <g2s7efa8a7d1004012007ibe8b42b6k28a6d2a531fb6103@mail.gmail.com>
	<20100402110506.GA16294@rap.rap.dk> <x2q7efa8a7d1004021055oe2e832ccl8877e9171b8f3442@mail.gmail.com>
	<20100402211443.GA2380@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100402211443.GA2380@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: Keld Simonsen <keld@keldix.com>
Cc: linux-raid@vger.kernel.org, keld@dkuug.dk, learner.study@gmail.com
List-Id: linux-raid.ids

I have seen ~180MB/s RAID5 performance with 4 disks...are you saying
that I could achieve even higher if I have more number of disks (so
instead of 3+1, try 6+1 or 9+1)?
Logically, this sounds right but wanted to verify my thought process
with you....

Thanks!

On Fri, Apr 2, 2010 at 2:14 PM, Keld Simonsen <keld@keldix.com> wrote:
> On Fri, Apr 02, 2010 at 10:55:53AM -0700, Learner Study wrote:
>> Hi Keld:
>>
>> Thanks for your email...
>>
>> 1. Can you pls point me to this benchmark (which shows 500MB/s)? I
>> would like to know which CPU, HDDs and kernel version used to achiev=
e
>> this...
>
> http://home.comcast.net/~jpiszcz/20080329-raid/
> 496843 =A0 KB/s for sequential input with 10 raptor drives
> There probably is an email in the archives with more info on the
> test.
>
>> 2. Secondly, I would like to understand how raid stack (md driver)
>> scales as we add more cores...if single core gives ~500MB/s, can two
>> core give ~1000MB/s? can four cores give ~2000MB/s? etc....
>
> No, the performance is normally limited by the number of drives.
> I would not wsay that more cores woould do a little
> but it would be in the order of 1-2 % I think.
> This is also dependent on wheteher the code actually runs threaded.
> I doubt it....
>
> best regard
> keld
>
>>
>> Thanks for your time.
>>
>> On Fri, Apr 2, 2010 at 4:05 AM, Keld Simonsen <keld@keldix.com> wrot=
e:
>> > On Thu, Apr 01, 2010 at 08:07:25PM -0700, Learner Study wrote:
>> >> Hi Keld:
>> >>
>> >> Do we have raid5/6 numbers for linux on any multi-core CPU? Most =
of
>> >> the benchmarks I have seen on wiki show raid5 perf to be ~150MB/s=
 with
>> >> single core CPUs. How does that scale with multiple cores? Someth=
ing
>> >> like intel's jasper forest???
>> >
>> > I have not checked if the benchmarks were on multi core machines.
>> > It should not matter much if there were more than one CPU, but
>> > of cause it helps a little. bonnie++ test reports cpu usage, and t=
his
>> > is not insignificant, say in the 20 -60 % range for some tests,
>> > but nowhere near a bottleneck. There was one with a raid5 performa=
nce
>> > seq read of about 500 MB/s with 36 % cpu utilization, so it is
>> > definitely possible to come beyound 150 MB/s. The speed is largely
>> > dependent on number of disk drives you employ.
>> >
>> >
>> >> If available, can u pls point me to numbers with multi-core CPU?
>> >
>> > I dont have such benchmarks AFAIK. But new benchmarks are always w=
elcome,
>> > so please feel free to submit your findings.
>> >
>> > Best regards
>> > keld
>> >
>> >> Thanks!
>> >>
>> >> On Wed, Mar 31, 2010 at 1:15 PM, Keld Simonsen <keld@keldix.com> =
wrote:
>> >> > On Wed, Mar 31, 2010 at 12:42:57PM -0700, Learner Study wrote:
>> >> >> Hi Linux Raid Experts:
>> >> >>
>> >> >> I was looking at following wiki on raid perf on linux:
>> >> >>
>> >> >> https://raid.wiki.kernel.org/index.php/Performance
>> >> >>
>> >> >> and notice that the performance numbers are with 2.6.12 kernel=
=2E
>> >> >>
>> >> >> Do we perf numbers for:
>> >> >> - latest kernel (something like 2.6.27 / 2.6.31)
>> >> >> - raid 5 and 6
>> >> >>
>> >> >> Can someone please point me to appropriate link?
>> >> >
>> >> > The link mentioned above has a number of other performance repo=
rts, for other levels of the kernel.
>> >> > Anyway you should be able to get comparable results for newer k=
ernels, the kernel has not become
>> >> > slower since 2.6.12 on RAID.
>> >> >
>> >> > best regards
>> >> > Keld
>> >> >
>> >> --
>> >> To unsubscribe from this list: send the line "unsubscribe linux-r=
aid" in
>> >> the body of a message to majordomo@vger.kernel.org
>> >> More majordomo info at =A0http://vger.kernel.org/majordomo-info.h=
tml
>> >
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

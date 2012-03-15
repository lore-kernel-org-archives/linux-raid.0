From: Jessie Evangelista <jessie.evangelista@gmail.com>
Subject: Re: raid10n2/xfs setup guidance on write-cache/barrier
Date: Fri, 16 Mar 2012 00:52:19 +0800
Message-ID: <CAA8mOyDquGX0kEbQSpo=S0EYdNvXNBQ6ZLnb5Sc7uvCPYB+xqA@mail.gmail.com>
References: <CAA8mOyDKrWg0QUEHxcD4ocXXD42nJu0TG+sXjC4j2RsigHTcmw@mail.gmail.com>
	<4F61803A.60009@hardwarefreak.com>
	<CAA8mOyCzs36YD_QUMq25HQf8zuq1=tmSTPjYdoFJwy2Oq9sLmw@mail.gmail.com>
	<20321.63389.586851.689070@tree.ty.sabi.co.UK>
	<20120315152548.GA25194@www5.open-std.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120315152548.GA25194@www5.open-std.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>, Linux fs XFS <xfs@oss.sgi.com>
List-Id: linux-raid.ids

Hi keld,

On Thu, Mar 15, 2012 at 11:25 PM,  <keld@keldix.com> wrote:
> On Thu, Mar 15, 2012 at 02:07:25PM +0000, Peter Grandi wrote:
>> >>> I want to create a raid10,n2 using 3 1TB SATA drives.
>> >>> I want to create an xfs filesystem on top of it. The
>> >>> filesystem will be used as NFS/Samba storage.
>>
>> Consider also an 'o2' layout (it is probably the same thing for a
>> 3 drive RAID10) or even a RAID5, as 3 drives and this usage seems
>> one of the few cases where RAID5 may be plausible.
>
> Well, for a file server like NFS/Samba, you could also consider raid1=
0,f2.
> I would think you could get about double the read performance compare=
d to n2 and o2
> layouts, and also for individual read transfers on a running system
> you would get somthing like double the read performance.
> Write performance could be somewhat slower (0 to 10 %) bot as users
> are not waiting for writes to complete, they will probably not notice=
=2E

I also plan to try raid10f2. Did you do your own benchmarks or are you
quoting someone elses?
>
> best regards
> keld

thanks for chiming in. have a nice day

> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

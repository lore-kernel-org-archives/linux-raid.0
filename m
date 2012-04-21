From: =?UTF-8?Q?Pawe=C5=82_Brodacki?= <pawel.brodacki@googlemail.com>
Subject: Re: [md PATCH 08/23] md: don't set md arrays to readonly on shutdown.
Date: Sat, 21 Apr 2012 17:18:58 +0200
Message-ID: <CACVpCE6UZvBia2VwRMaFhJJuB2quvKKQc1byLFRP4YPTE8LHSQ@mail.gmail.com>
References: <20120314043555.7978.75486.stgit@notabene.brown>
	<20120314044040.7978.64156.stgit@notabene.brown>
	<CAGRgLy5UYf27335hQmEQQ8V2GSatQ-1aev9DdTia0j-Hv4wsEg@mail.gmail.com>
	<20120419084833.39379a6f@notabene.brown>
	<CAGRgLy6LXB34JtmfZYQEdAK4GLCV-hn-V8cT1zCwo_=ERyK90A@mail.gmail.com>
	<20120419195740.6e35ea02@notabene.brown>
	<CACVpCE5mpJcY5u=8Kqp7TkCHN63aMfncDwbnP77NOFjubhqoPA@mail.gmail.com>
	<20120420220151.623df648@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120420220151.623df648@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Alexander Lyakas <alex.bolshoy@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

W dniu 20 kwietnia 2012 14:01 u=C5=BCytkownik NeilBrown <neilb@suse.de>=
 napisa=C5=82:
> On Fri, 20 Apr 2012 13:30:39 +0200 Pawe=C5=82 Brodacki
> <pawel.brodacki@googlemail.com> wrote:
>>
>> The way I read the message agrees with Alexander's perception. My
>> impression from reading the commit message is, that normal shutdown
>> may result in unclean array, which I would perceive as a regression.
>
> I don't think you'll find the word "normal" in the original message :=
-)
>
Neil, I respect you and admire your work and all, but I think you are
having good time with us and this commit message, aren't you? :)

>>
>> I would really appreciate clear statement, whether this behaviour
>> (writeback during shutdown, with possibility of poweroff/reboot whil=
e
>> array is dirty) can or cannot occur during normal shutdown process.
>
> Define "normal".
> If you kill any processes that could generate write-out, and then do =
a
> 'sync', then everything should be fine.
>
I think "normal shutdown" can be defined for the purpose of this
discussion as whatever /sbin/shutdown does.

If I run /sbin/shutdown -h now, it is a normal shutdown. If I do fancy
stuff echoing cute strings and integers into various parts of /proc
and /sys, push magic buttons and/or pull cables at random, it' is not
a normal shutdown.

> I suspend a "normal" shutdown sequence does this.
>
> NeilBrown
>

I smell a hint here.

man shutdown:
"shutdown arranges for the system to be brought down in a safe way."
Define safe...

Neil, could you point us to a bug report which inspired you to write
this patch? My google fu failed me and I was able to find just one bug
entry from before 2 yerars, and even that hit is of dubious relevance.

Pretty please with sugar on top?

Best regards,
Pawe=C5=82 Brodacki
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

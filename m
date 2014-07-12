From: Vlad Dobrotescu <vlad@dobrotescu.ca>
Subject: Re: RAID6 questions (mdadm 3.2.6/3.3.x)
Date: Sat, 12 Jul 2014 13:15:44 -0400
Message-ID: <53C16D40.7040002@dobrotescu.ca>
References: <53C06815.2020302@dobrotescu.ca> <B953BC37-3769-4D9A-97FF-5EFE7C59EEA4@colorremedies.com> <53C0A994.1050508@dobrotescu.ca> <D7AA36E1-683F-4E39-87C1-8089EA968E30@colorremedies.com> <loom.20140712T145923-203@post.gmane.org> <EAE4EA52-392A-4191-AA1B-B3B9BEFEBA60@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <EAE4EA52-392A-4191-AA1B-B3B9BEFEBA60@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Chris Murphy <lists <at> colorremedies.com> writes:
 >
 > On Jul 12, 2014, at 7:30 AM, Vlad Dobrotescu <vlad <at> dobrotescu.c=
a>
 > wrote:
 > >
 > > Since it seems you have a very healthy view of real-world RAID,
 > > could you point out any significant issues when using a disk as
 > > a degraded md RAID1 (not accidental, but on purpose)?
 >
 > Intentionally degraded raid1 seems oxymoronic to me. Like fat free
 > ice cream. Uptime/data availability is the purpose of RAID, not
 > backup. It sounds like a member drive is being used as a shelf or
 > offsite backup, with periodic catch-up resyncing. If it's an n way
 > mirror with 3 drives, two left connected, one off-site, then while
 > technically degraded you could still lose one drive and have uptime
 > and a backup. But I still think that's the wrong way to do it =97
 > this is probably more of a philosophical argument than a technical
 > one.
 >
 > Chris Murphy

As mentioned in my original message, this would be a setup that can
accomodate "hot-replace" (without a full resync) before this feature
becomes available in mdadm 3.3.x ...

Vlad

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

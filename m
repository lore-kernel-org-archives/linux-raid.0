From: Paul Clements <paul.clements@steeleye.com>
Subject: Re: Sync rates?
Date: Thu, 06 May 2004 15:40:45 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <409A94BD.40207@steeleye.com>
References: <00a401c4339e$7f86b340$6705a8c0@a30> <yw1xsmede4hk.fsf@kth.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <yw1xsmede4hk.fsf@kth.se>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

M=E5ns Rullg=E5rd wrote:
> <me@heyjay.com> writes:

>>will be done syncing in just under 24 hours.  Is this sync rate expec=
ted?  I

Have you checked /proc/sys/dev/raid/speed_limit_min and _max ? These ma=
y=20
need to be increased if you want the resync to be faster.


> Maybe you are syncing all 5 partitions at the same time.

Except the driver won't let that happen. It serializes resync of arrays=
=20
that share the same physical components.

--
Paul


-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

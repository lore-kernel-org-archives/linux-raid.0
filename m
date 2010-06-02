From: Miha Verlic <ml@krneki.org>
Subject: Re: devices get kicked from RAID about once a month
Date: Wed, 02 Jun 2010 21:55:22 +0200
Message-ID: <4C06B72A.5080304@krneki.org>
References: <87k4qho723.fsf@uwo.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87k4qho723.fsf@uwo.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Christensen <jdc@uwo.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 06/02/2010 04:14 PM, Dan Christensen wrote:
> I tried disconnecting and re-connecting all four SATA cables, but the
> problem occurred again.  In fact, today *two* partitions were kicked out
> of their (different) raid devices.

Well the logs only show that separate hard drives stoped responding for
a while and kernel resetted sata link at that point.

Since it's happening on random drives, and even two at a time, I'd say
hard drives itself are not the problem. I'd replace power supply first.
I've had similar simptoms on one of my machines - it either crashed or
kicked one of drives out of the array. It happened randomly, but usually
once per month - who knows, maybe a spike in a grid, sudden cpu usage or
something similar caused it.

Anyway - bigger power supply solved the problem.

--
Miha

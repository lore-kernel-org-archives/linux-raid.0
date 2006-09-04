From: Ferenc Wagner <wferi@niif.hu>
Subject: Re: RAID6 fallen apart
Date: Mon, 04 Sep 2006 18:03:28 +0200
Message-ID: <87veo3mxf3.fsf@tac.ki.iif.hu>
References: <87y7tcxu71.fsf@szonett.ki.iif.hu>
	<17650.20238.346014.292009@cse.unsw.edu.au>
	<87ejv027py.fsf@tac.ki.iif.hu>
	<17651.40951.849657.876173@cse.unsw.edu.au>
	<5b170a7d0609030818ra8fa45i8f45cb55a8628fc9@mail.gmail.com>
	<5b170a7d0609030819r402a2a36ob7e8b74195d16a5b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5b170a7d0609030819r402a2a36ob7e8b74195d16a5b@mail.gmail.com> (Tuomas
 Leikola's message of "Sun, 3 Sep 2006 18:19:13 +0300")
Sender: linux-raid-owner@vger.kernel.org
To: Tuomas Leikola <tuomas.leikola@gmail.com>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

"Tuomas Leikola" <tuomas.leikola@gmail.com> writes:

> On 9/3/06, Tuomas Leikola <tuomas.leikola@gmail.com> wrote:
>>> Possibly safer to recreate with two missing if you aren't sure of the
>>> order.  That way you can look in the array to see if it looks right,
>>> or if you have to try a different order.
>>
>> I'd say it's safer to recreate with all disks, in order to get the
>> resync. Otherwise you risk the all so famous silent data corruption on
>> stripes with writes in-flight at the time of failure.
>
> Ment to say: after you know the correct order. Sorry.

I highly appreciate expert advice. Thanks for taking the time!
-- 
Best wishes,
Feri.

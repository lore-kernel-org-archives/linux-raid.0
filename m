From: BillStuff <billstuff2001@sbcglobal.net>
Subject: Re: Raid5 hang in 3.14.19
Date: Tue, 14 Oct 2014 11:55:00 -0500
Message-ID: <543D5564.9000101@sbcglobal.net>
References: <5425E9D6.1050102@sbcglobal.net>	<20140929122533.3b91a543@notabene.brown>	<5428D863.7090409@sbcglobal.net>	<20140929140818.1086972e@notabene.brown>	<5428DFE1.9080600@sbcglobal.net>	<20140930075950.1d1e3865@notabene.brown>	<542B1EDC.7060803@sbcglobal.net>	<20141001085409.41399b13@notabene.brown>	<54316C34.6090304@sbcglobal.net> <20141014124245.69b143e2@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20141014124245.69b143e2@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

[snip]
On 10/13/2014 08:42 PM, NeilBrown wrote:
> Write errors start happening.
>
> You should only get a write error if no writes successfully completed to
> in_sync, non-faulty devices.
> It is possible that the write to sdg3 completed before it was marked in-sync,
> and the write to sdh3 completed after it was marked as faulty.
> How long after recovery completes do you fail the next device?
> The logs suggest it is the next second, which could be anywhere from 1msec
> to 1998 msecs.
>
>
> NeilBrown
>

FYI Neil: Running through my logs, I noticed 6 of these failures in my 
testing
over the past few days. All "recovery completed, wait a second, fail the 
other
drive" cases. Same signature in the logs. Apparently things kept working 
until
the filesystem tripped on its journal and fell over.

So the upshot is this seems reasonably reproducible.

-Bill

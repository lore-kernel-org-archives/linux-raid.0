From: "Jon Nelson" <jnelson-linux-raid@jamponi.net>
Subject: Re: Awful Raid10,f2 performance
Date: Mon, 15 Dec 2008 20:47:24 -0600
Message-ID: <cccedfc60812151847u6e69a44jc50b3f58da5b9171@mail.gmail.com>
References: <cccedfc60806020711o39ccd321h5e410c963d8bf3b1@mail.gmail.com>
	 <48440953.3040004@wpkg.org>
	 <cccedfc60806020809t73794ce6w539c6b0d247a264f@mail.gmail.com>
	 <cccedfc60812150533p31974f4bye490958dbc974212@mail.gmail.com>
	 <18758.52823.375213.963854@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18758.52823.375213.963854@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Linux-Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Dec 15, 2008 at 3:38 PM, Neil Brown <neilb@suse.de> wrote:
> On Monday December 15, jnelson-linux-raid@jamponi.net wrote:
>> A follow-up to an earlier post about weird slowness with RAID10,f2 and
>> 3 drives. This morning's "check" operation is proceeding very slowly,
>> for some reason.

...

>> What might be going on here?
>
> If you think about exactly which blocks of which drives md will have
> to read, and in which order, you will see that each drive is seeking
> half the size of the disk very often.  Exactly how often would depend
> on chunk size and the depth of the queue in the elevator, but it would
> probably read several hundred K from early in the disk, then several
> hundred from half-way in, then back to start etc.  This would be
> expected to be slow.

An excellent explanation, I think.

However, not to add fuel to the fire, but would an alternate 'check'
(and resync and recover) algorithm possibly work better?

Instead of reading each logical block from start to finish (and
comparing it against the N copies), one *could* start with device 0
and read all of the non-mirror chunks (in order) but only from that
device, comparing against other copies. Then md could proceed to the
next device and so on until all devices have been iterated through.
The advantage to this algorithm is that unless you have > 1 copy of
the data on the *same* device the seeking will be minimized and you
could get substantially higher sustained read rates (and less wear and
tear).

-- 
Jon

From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: using the raid6check report
Date: Sun, 8 Jan 2017 20:52:40 +0000
Message-ID: <5872A698.7000009@youngman.org.uk>
References: <14e8ec23-de4a-e90b-4b67-155e5e3cc228@eyal.emu.id.au>
 <20170108174010.GA3699@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170108174010.GA3699@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, Eyal Lebedinsky <eyal@eyal.emu.id.au>
Cc: list linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 08/01/17 17:40, Piergiorgio Sartor wrote:
> On Fri, Dec 23, 2016 at 11:56:34AM +1100, Eyal Lebedinsky wrote:
>> > From time to time I get non-zero mismatch_count in the weekly scrub. The way I handle
>> > it is to run a check around the stripe (I have a background job printing the mismatch
>> > count and /proc/mdstat regularly) which should report the same count.
>> > 
>> > I now drill into the fs to find which files use this area, deal with them and delete
>> > the bad ones. I then run a repair on that small area.
>> > 
>> > I now found about raid6check which can actually tell me which disk holds the bad data.
>> > This is something raid6 should be able to do assuming a single error.
>> > Hoping it is one bad disk, the simple solution now is to recover the bad stripe on
>> > that disk.
>> > 
>> > Will a 'repair' rewrite the bad disk or just create fresh P+Q which may just make the
>> > bad data invisible to a 'check'? I recall this being the case in the past.
> "repair" should fix the data which is assumed
> to be wrong.
> It should not simply correct P+Q, but really
> find out which disk is not OK and fix it.
> 
Having just looked at the man page and the source to raid6check as found
online ...

"man raid6check" says that it does not write to the disk. Looking at the
source, it appears to have code that is intended to write to the disk
and repair the stripe. So what's going on?

I can add it to the wiki as a little programming project, but it would
be nice to know the exact status of things - my raid-fu isn't good
enough at present to read the code and work out what's going on.

It would be nice to be able to write "parity-check" or somesuch to
sync_action, and then for raid5 it would check and update parity, or
raid6 it would check and correct data/parity.

Cheers,
Wol

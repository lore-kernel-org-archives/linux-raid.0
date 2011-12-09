From: "John Stoffel" <john@stoffel.org>
Subject: Re: 4 out of 16 drives show up as 'removed'
Date: Fri, 9 Dec 2011 10:31:39 -0500
Message-ID: <20194.10715.190590.487856@quad.stoffel.home>
References: <F0C8A2FE-8E5E-4683-BBF8-8E6B6A831635@ucsc.edu>
	<20111208075709.587ac227@notabene.brown>
	<654BF752-029F-444F-A4AB-68C3CEA7F8D5@ucsc.edu>
	<20111208091651.2a56dd5b@notabene.brown>
	<2866C99D-B573-4EF3-8FD0-0A40B0C20118@ucsc.edu>
	<20111209065140.107aa286@notabene.brown>
	<46200D05-2D7F-44F8-9323-DCFF720776D2@ucsc.edu>
	<20111209075931.29b26b5e@notabene.brown>
	<D1EB6C45-E127-4EC6-BFDD-BDFCC4607981@ucsc.edu>
	<20111209095033.06136f92@notabene.brown>
	<E88BF285-4224-45F8-952A-0248E7025BDD@ucsc.edu>
	<20111209142006.7ad399f9@notabene.brown>
	<109C0559-A65A-41D3-B132-4467B39A6207@ucsc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <109C0559-A65A-41D3-B132-4467B39A6207@ucsc.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Eli Morris <ermorris@ucsc.edu>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "Eli" == Eli Morris <ermorris@ucsc.edu> writes:

Eli> Wow. Thanks so much. I haven't verified the entire array, but it
Eli> looks fine. I'm still really wondering what you think might have
Eli> happened. As I mentioned, everything was OK and then the four
Eli> drives just showed up as "removed" when I went to write to the
Eli> filesystem on the array. Do you think it has to do with the
Eli> hardware or is there something I can correct in software so that
Eli> this won't happen again? I suspect hardware, since after it
Eli> happened, I ran lsscsi and the four drives failed to show up on
Eli> the list. 

I personally suspect that you have hardware issues, possibly cables,
possibly the enclosure you're using.  When you have four drives all on
a single path drop out, it points strongly to the path or some other
common issue.

Have you checked your power supply as well?  Maybe you're running just
slightly overloaded and something happened to work the system, so the
voltage dropped just enough to cause the problem.

If you feel ok, you could try to run the RAID check while at the same
time stressing the system with something CPU intensive to load down
the CPU(s) on the system.  

But in general, when things are stable again, bring down the system,
and double check all your cables are seated properly, controllers are
tight, etc.  

Eli> These are the Caviar Green drives that people seem to have
Eli> problems with in RAID arrays. I was thinking about changing the
Eli> timeout tolerance in the OS to something several minutes
Eli> long. Maybe you've seen something like this before? I'm just not
Eli> sure what happened, but, as you might imagine, I'm keen for it to
Eli> not happen every few months.

I don't remember if you posted and logs from dmesg when this crapped
out, but you might see something in there.

John

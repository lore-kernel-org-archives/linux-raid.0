From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: mismatch_cnt again
Date: Fri, 13 Nov 2009 06:30:43 +0100
Message-ID: <87k4xvxa7w.fsf@frosties.localdomain>
References: <4AF5268D.60900@eyal.emu.id.au>
	<4877c76c0911070008m789507f8h799d419287740ca5@mail.gmail.com>
	<87tyx6tpcb.fsf@frosties.localdomain> <4AF58B20.3000409@redhat.com>
	<87iqdlaujb.fsf@frosties.localdomain> <4AF74B61.6000102@rabbit.us>
	<20091109185632.GA2723@lazy.lzy>
	<73ebdcee169f46611d411755f9aaca5b.squirrel@neil.brown.name>
	<20091109215443.GA4143@lazy.lzy>
	<d99ca9481d2471073484c5d43d493b4d.squirrel@neil.brown.name>
	<20091110195222.GA2777@lazy.lzy>
	<19196.50782.113024.239657@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <19196.50782.113024.239657@notabene.brown> (Neil Brown's message
	of "Fri, 13 Nov 2009 13:37:18 +1100")
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, Peter Rabbitson <rabbit+list@rabbit.us>, Goswin von Brederlow <goswin-v-b@web.de>, Doug Ledford <dledford@redhat.com>, Michael Evans <mjevans1983@gmail.com>, Eyal Lebedinsky <eyal@eyal.emu.id.au>, linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil Brown <neilb@suse.de> writes:

> On Tuesday November 10, piergiorgio.sartor@nexgo.de wrote:
>> Hi again,
>> 
>> > It seems we might have been talking at cross-purposes.
>> > 
>> > When I wrote about the need for a threat model, it was in the
>> > context of automatically determining which block was most
>> > likely to be in error (e.g. voting with a 3-drive RAID1 or
>> > fancy arithmetic with RAID6).  I do not believe there is any
>> > value in doing that.  At least not automatically in the kernel
>> > with the aim of just repairing which block was decided to be
>> > most wrong.
>> > 
>> > You now seem to be talking about the ability to find out which
>> > blocks are inconsistent.  That is very different.  I do agree there
>> > is value in that.  Maybe it should appear in the kernel logs,
>> > or maybe we could store the information and report in via sysfs
>> > (the former would certainly be easier).
>> 
>> maybe there is a misunderstanding between us! :-)
>> 
>> Automatic repair *might* be a far end target, but I do
>> agree, this needs to be clarified deeply.
>> 
>> I see the thing similarly to a previous comment from a
>> fellow poster.
>> To do:
>> 1) detect which MD block is inconsistent
>> 2) detect, when possible, which device component is responsible
>> 3) trigger a repair action
>> 
>> This would be done all under user control, i.e. the user
>> will get the mismatch count, maybe with some hint on which
>> device could be guilty (RAID-6 or RAID-1/10 with multiple
>> redundancy) and then he could decide what to do.
>> 
>> The user will have full control and full *responsability*
>> on the action, but it will also be fully informed on what
>> the situation is.
>> 
>> The system will tell: block ABC is inconsistent, maybe
>> device /dev/sdX is guilty, you could: do nothing, resync
>> the parity, try to repair.
>
> I think just "block ABC is inconsistent" is sufficient.
> user-space can then quiesce that part of the array, read the relevant
> blocks, do any analysis that might be appropriate, and report to the
> admin. 

It is a begining. Eventualy I would like to see the guilty device in
the log though. That way the log can be analysed quickly and for
example a bad cable or failing drive will show up to be always the
guilty drive. Only makes sence for 3+ mirrors or raid6 though.

The repair should also determine the likely faulty block and rewrite
that instead of picking a random one. So you already need a "who is to
blame" function. The loging and repair can share the code.

>> As I mentioned some times ago, I built a RAID-6, where
>> one disk, due to a strange cabling problem, was sometimes
>> returning wrong data (one bit flip, actually).
>> And this without any errors reported, i.e. a bit was
>> sometimes flipped, at the very end it seems, and it
>> was undetected by ECC/CRC/whatever.
>
> That is a very interesting threat scenario - occasional bit flip on
> read between media and memory.  I had a drive like that once.  One
> particular bit in the sector would fairly often return '1' no matter
> what had been written.  I had it in a RAID1 and it quickly made a mess
> of the filesystem.

I had a external raid enclosure that would flip bits in the block
number data was read from or written too. With the box alone data
written to one file would suddenly appear in another file.

To make matters worse 2 enclosures where combined in a software raid1
giving the strangest errors. The file contents would randomly change
depending on which enclosure was used to read data.

Those errors do happen from time to time and will keep hapening.

> As you say, there is nothing that md can or should do about this
> except report that something odd is happening, which it does, and
> report where it is happening, which it does not.
>
> NeilBrown

MfG
        Goswin

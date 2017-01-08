From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: using the raid6check report
Date: Sun, 8 Jan 2017 22:43:00 +0100
Message-ID: <20170108214259.GB7933@lazy.lzy>
References: <14e8ec23-de4a-e90b-4b67-155e5e3cc228@eyal.emu.id.au>
 <20170108174010.GA3699@lazy.lzy>
 <a33dbf5c-465d-b5af-a9a9-a00664816489@eyal.emu.id.au>
 <20170108204659.GB7057@lazy.lzy>
 <5872A9C6.7010408@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5872A9C6.7010408@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, Eyal Lebedinsky <eyal@eyal.emu.id.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Jan 08, 2017 at 09:06:14PM +0000, Wols Lists wrote:
> On 08/01/17 20:46, Piergiorgio Sartor wrote:
> > "should" as in "it is supposed to do it".
> > 
> > So, as far as I know, "raid6check" with "repair" will
> > check the parity and try to find errors.
> > If possible, it will find where the error is, then
> > re-compute the value and write the corrected data.
> > 
> > Now, this was somehow tested and *should* work.
> > 
> > An other option is just to check for the errors and
> > see if one drive is constantly at fault.
> > This will not write anything, so it is safer, but
> > it will help to see if there are strange things,
> > before writing to the disk(s).
> 
> Hmmm ...
> 
> I've now been thinking about it, and actually I'm not sure it's possible
> even with raid6, to correct a corrupt read. The thing is, raid protects
> against a failure to read - if a sector fails, the parity will re-create
> it. But if a data sector is corrupted, how is raid to know WHICH sector?

Here all you need to know:

http://ftp.nluug.nl/ftp/ftp/os/Linux/system/kernel/people/hpa/raid6.pdf

bye,

pg

> 
> If one of the parity sectors is corrupted, it's easy. Calculate parity
> from the data, and either P or Q will be wrong, so fix it. But if it's a
> *data* sector that's corrupted, both P and Q will be wrong. How easy is
> it to work back from that, and work out *which* data sector is wrong? My
> fu makes me think you can't, though I could quite easily be wrong :-)
> 
> But should that even happen, unless a disk is on its way out, anyway? I
> remember years ago, back in the 80s, our minicomputers had
> error-correction in the drive. I don't remember the algorithm, but it
> wrote 16-bit words to disk - each an 8-bit data byte. The first half was
> the original data, and the second half was some parity pattern such that
> for any single-bit corruption you knew which half was corrupt, and you
> could throw away the corrupt parity, or recreate the correct data from
> the parity. Even with a 2-bit error I think it was >90% detection and
> recreation. I can't imagine something like that not being in drive
> hardware today.
> 
> Cheers,
> Wol

-- 

piergiorgio

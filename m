From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: mismatch_cnt again
Date: Sun, 15 Nov 2009 22:05:42 +0100
Message-ID: <20091115210542.GA6826@lazy.lzy>
References: <87tyx6tpcb.fsf@frosties.localdomain> <4AF58B20.3000409@redhat.com> <87iqdlaujb.fsf@frosties.localdomain> <4AF74B61.6000102@rabbit.us> <20091109185632.GA2723@lazy.lzy> <73ebdcee169f46611d411755f9aaca5b.squirrel@neil.brown.name> <20091109215443.GA4143@lazy.lzy> <d99ca9481d2471073484c5d43d493b4d.squirrel@neil.brown.name> <20091110195222.GA2777@lazy.lzy> <19196.50782.113024.239657@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <19196.50782.113024.239657@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, Peter Rabbitson <rabbit+list@rabbit.us>, Goswin von Brederlow <goswin-v-b@web.de>, Doug Ledford <dledford@redhat.com>, Michael Evans <mjevans1983@gmail.com>, Eyal Lebedinsky <eyal@eyal.emu.id.au>, linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

> I think just "block ABC is inconsistent" is sufficient.
> user-space can then quiesce that part of the array, read the relevant
> blocks, do any analysis that might be appropriate, and report to the
> admin. 

personally I think user space is good for
this kind of operations.

I think the point here is not if this kind of
recovery should be in kernel space or not, but
to have this kind of recovery.

> That is a very interesting threat scenario - occasional bit flip on
> read between media and memory.  I had a drive like that once.  One
> particular bit in the sector would fairly often return '1' no matter
> what had been written.  I had it in a RAID1 and it quickly made a mess
> of the filesystem.

In my case, a further analisys showed that the "bits"
where always *written* correctly, but the reading
operation was, sometimes, flipping bits.

This was especially nasty, because, without "resync"
the array would have been always fine.
 
> As you say, there is nothing that md can or should do about this
> except report that something odd is happening, which it does, and
> report where it is happening, which it does not.

Well, md specifically may or may not have the infrastructure
to use the RAID-6 parity to correct this sort of issues.
Nevertheless, using the RAID-6 double parity, in user or
kernel space, is really one point for software RAID.

bye,

-- 

piergiorgio

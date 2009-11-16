From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: mismatch_cnt again
Date: Mon, 16 Nov 2009 08:40:16 +0100
Message-ID: <87639ayl27.fsf@frosties.localdomain>
References: <87tyx6tpcb.fsf@frosties.localdomain>
	<4AF58B20.3000409@redhat.com> <87iqdlaujb.fsf@frosties.localdomain>
	<4AF74B61.6000102@rabbit.us> <20091109185632.GA2723@lazy.lzy>
	<73ebdcee169f46611d411755f9aaca5b.squirrel@neil.brown.name>
	<20091109215443.GA4143@lazy.lzy>
	<d99ca9481d2471073484c5d43d493b4d.squirrel@neil.brown.name>
	<20091110195222.GA2777@lazy.lzy>
	<19196.50782.113024.239657@notabene.brown>
	<20091115210542.GA6826@lazy.lzy> <DC9DEEF4919E420CB7CC2A160120D49A@m5>
	<20091116123747.29592212@notabene.brown>
	<87tywv59kw.fsf@frosties.localdomain>
	<20091116163527.36454acc@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091116163527.36454acc@notabene.brown> (Neil Brown's message of
	"Mon, 16 Nov 2009 16:35:27 +1100")
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Goswin von Brederlow <goswin-v-b@web.de>, Guy Watkins <linux-raid@watkins-home.com>, 'Piergiorgio Sartor' <piergiorgio.sartor@nexgo.de>, 'Peter Rabbitson' <rabbit+list@rabbit.us>, 'Doug Ledford' <dledford@redhat.com>, 'Michael Evans' <mjevans1983@gmail.com>, 'Eyal Lebedinsky' <eyal@eyal.emu.id.au>, 'linux-raid list' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil Brown <neilb@suse.de> writes:

> On Mon, 16 Nov 2009 06:21:03 +0100
> Goswin von Brederlow <goswin-v-b@web.de> wrote:
>
>> Neil Brown <neilb@suse.de> writes:
>> 
>> > On Sun, 15 Nov 2009 17:29:17 -0500
>> > "Guy Watkins" <linux-raid@watkins-home.com> wrote:
>> >
>> >> I have been following this issue some, and I think this could be a
>> >> cause for silent corruption on RAID5 and RAID6.  I don't think this
>> >> has been mentioned, if so, sorry.
>> >
>> > RAID1/RAID10 are very different from RAID5/RAID6
>> >
>> > RAID1/RAID10 can get 'mismatches' due to the particular behaviour
>> > of swap or filesystems.  However this doesn't matter (the blocks
>> > that are inconsistent are of no interest to the filesystem).
>> >
>> > RAID5/RAID6 is careful not to allow any mismatches to creep in
>> > due to any particular filesystem or swap activity.  This is because,
>> > as you say, those mismatches could be significant to the RAID
>> > algorithm even though they might be of no interest to the
>> > filesystem.
>> >
>> > mismatches can only occur in a RAID5/RAID6 due to a software bug
>> > in the md/raid code, or due to 'hardware errors' (including of
>> > course drive firmware errors etc).
>> >
>> > NeilBrown
>> 
>> Does that mean raid4/5/6 always coppies the data or that it protects
>> it with the MMU?
>
> Always copies.  Given that it has to access the data to calculate the
> XOR, the extra overhead of copying it is less than RAID1.
> Where hardware XOR support, hardware copy support is normally also
> available, and that is used.

In cases where you have XOR but not copy wouldn't you XOR against a
zero filled page to copy?

MfG
        Goswin

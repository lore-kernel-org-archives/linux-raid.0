From: Paul Clements <paul.clements@us.sios.com>
Subject: Re: [BUG 2.6.32] md/raid1: barrier disabling does not work correctly
 in all cases
Date: Tue, 1 Feb 2011 20:04:25 -0500
Message-ID: <AANLkTin_Xuo5hwPXr5bnYZJX5zjZheFaeYB6cDvOW-Qg@mail.gmail.com>
References: <AANLkTimp7eGLu5UEr-wH9MVSGrQWA3PKMakW74_48gk7@mail.gmail.com>
	<AANLkTikGsB=ZdA-TpjC+npqW-TM9NjwZkWpjWtUEzswn@mail.gmail.com>
	<20110121072515.07dc2b74@notabene.brown>
	<AANLkTi=NqHV9p0rc4VBBNAzxwjvfA0DpKgkxQpsX9gsT@mail.gmail.com>
	<AANLkTimS00pyoN2f4E-2ZbSLq8-Xar3oj9DZ2sEfXzgs@mail.gmail.com>
	<20110202113215.3e106ccb@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110202113215.3e106ccb@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Feb 1, 2011 at 7:32 PM, NeilBrown <neilb@suse.de> wrote:
> On Tue, 1 Feb 2011 15:45:16 -0500 Paul Clements <paul.clements@us.sio=
s.com>
> wrote:
> Disabling behind-writes for all barrier requests would be quite easy,=
 but it
> might negate a lot of the value of behind writes

Agreed...

> I think the best option is to reject barrier writes if there are any
> behind-write devices. =A0That would be reasonably safe and reasonably
> consistent.

Yeah, I was leaning toward this.

> So maybe something like this??

Yes, I think that would work.

Thanks,
Paul
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

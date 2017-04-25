From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: Recover array after I panicked
Date: Tue, 25 Apr 2017 14:41:00 +0200
Message-ID: <20170425124100.GA7449@metamorpher.de>
References: <20170424123706.GA6798@metamorpher.de>
 <CAHKno4BR3kdsLU9AnNHvarc-e6UibNr7WQks2ssPX4pE1ZoUpA@mail.gmail.com>
 <20170424133946.GA7057@metamorpher.de>
 <727eeaf5-b856-305d-99b6-e42f3383b699@powerlamerz.org>
 <20170425001614.GA3936@metamorpher.de>
 <CAHKno4A7umuNBUPaHk0vmgj2fnjPgBi2oZJWidhKKaRX7ekgKA@mail.gmail.com>
 <20170425090122.GA4488@metamorpher.de>
 <CAHKno4AuKNxYiMazUy+hRJ2kJCdNNYw5L0uExvWc_52Ocn5V=g@mail.gmail.com>
 <20170425110807.GA5159@metamorpher.de>
 <CAHKno4BfQG61pYMtcUf8NrzPt3dtNM=xe_DAb7Ypt4Qy_=1QkQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHKno4BfQG61pYMtcUf8NrzPt3dtNM=xe_DAb7Ypt4Qy_=1QkQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Patrik =?iso-8859-1?Q?Dahlstr=F6m?= <risca@powerlamerz.org>
Cc: Brad Campbell <lists2009@fnarfbargle.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Apr 25, 2017 at 01:37:53PM +0200, Patrik Dahlström wrote:
> Oh, I see. Does it do that every time I grow? In that case the
> original 5disk raid won't have 128M offset either.

The 128M offset is what we guessed from the device size and log output 
you provided a few mails back in the discussion.

On raid assembly the raid capacity is printed in the syslog and that's 
the capacity it would have with your disk size and 128M offset.

So I'd start with that if possible...

> Does the data offset change by a fixed or calculated value?
> Can I calculate the data offset by comparing to known data?

I guess it depends on mdadm/kernel version, and also the exact command, 
the number of disks involved, the chunk size, ...

For example the offset does not shift when you use --backup-file.

Without metadata it's a puzzle.

Regards
Andreas Klauer

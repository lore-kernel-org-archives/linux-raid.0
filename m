From: Can Jeuleers <can.jeuleers@gmail.com>
Subject: Re: Migrating a RAID 5 from 4x2TB to 3x6TB ?
Date: Tue, 09 Jun 2015 21:18:59 +0200
Message-ID: <55773C23.1010600@gmail.com>
References: <167089395.613.1433791723592.JavaMail.zimbra@wieser.fr> <55767860.5000803@gmail.com> <55773493.3050605@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <55773493.3050605@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, Pierre Wieser <pwieser@trychlos.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09/06/15 20:46, Wols Lists wrote:
> Please expand! Having read the article, it doesn't seem to say anything
> more than what is repeated time and time on this list - MAKE SURE YOUR
> DRIVES ARE DECENT RAID DRIVES.

Large RAID5 arrays are a bad idea because of the probability of
unrecoverable read errors occurring during a rebuild, which increases
with the size of the array.

Decent RAID drives will have better reliability than indecent-ones
(haha), but in absolute terms their URE rates are still going to
increase with array size.

> If you have ERC, then the odd "soft" read error doesn't matter. If you
> don't have ERC, then your data is at risk when you replace a drive, and
> it doesn't matter how big your drives are, it's the array size that matters.

Indeed. Pierre was proposing to further increase the size of his RAID5
array, and I was advising him against it because of the above.

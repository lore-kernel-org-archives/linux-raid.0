From: Phil Turmel <philip@turmel.org>
Subject: Re: 3TB drives failure rate
Date: Sun, 28 Oct 2012 20:21:48 -0400
Message-ID: <508DCC1C.8080900@turmel.org>
References: <11510711257.20121028131527@oudeis.org> <DB91871A-731F-44B4-9381-8FBF7D9CC3BF@colorremedies.com> <20121029015910.018efb17@natsu> <F548750F-8D0E-4D05-813B-58D85D652226@colorremedies.com> <20121029021643.1c9e3195@natsu> <46B8932A-58A5-4C1A-9C8C-DCCD5D3A1CD9@colorremedies.com> <508DAAD3.4050209@shiftmail.org> <508DAD6F.1070509@turmel.org> <508DC9F5.1040504@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <508DC9F5.1040504@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: joystick <joystick@shiftmail.org>
Cc: Chris Murphy <lists@colorremedies.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 10/28/2012 08:12 PM, joystick wrote:
> On 10/28/12 23:10, Phil Turmel wrote:
>> The drives I've suffered with on this have ignored the link reset and
>> were still unresponsive when MD tried to rewrite the sector(s) involved
>> (from the other drives in the array).
> 
> Very interesting
> 
> I would like to see this behaviour to make some experiments.
> I would like to simulate an unreadable sector...
> I see --make-bad-sector in hdparm, does that simulate an unreadable
> sector faithfully?

I've never tried this, but the description of that option suggests that
it does.

> (e.g. will it even be recorded in SMART current_pending_sector /
> reallocated_sector_ct ?)

Pending, I would presume.  Which should go away when you write back over it.

> Also, how do I trigger a link reset manually?

That I don't know.  But you should get one when you try to read back
that bad sector, if the drive timeout is longer than the driver timeout.

Phil


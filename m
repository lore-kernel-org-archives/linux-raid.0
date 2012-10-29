From: joystick <joystick@shiftmail.org>
Subject: Re: 3TB drives failure rate
Date: Mon, 29 Oct 2012 01:12:37 +0100
Message-ID: <508DC9F5.1040504@shiftmail.org>
References: <11510711257.20121028131527@oudeis.org> <DB91871A-731F-44B4-9381-8FBF7D9CC3BF@colorremedies.com> <20121029015910.018efb17@natsu> <F548750F-8D0E-4D05-813B-58D85D652226@colorremedies.com> <20121029021643.1c9e3195@natsu> <46B8932A-58A5-4C1A-9C8C-DCCD5D3A1CD9@colorremedies.com> <508DAAD3.4050209@shiftmail.org> <508DAD6F.1070509@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <508DAD6F.1070509@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Chris Murphy <lists@colorremedies.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 10/28/12 23:10, Phil Turmel wrote:
> The drives I've suffered with on this have ignored the link reset and
> were still unresponsive when MD tried to rewrite the sector(s) involved
> (from the other drives in the array).

Very interesting

I would like to see this behaviour to make some experiments.
I would like to simulate an unreadable sector...
I see --make-bad-sector in hdparm, does that simulate an unreadable 
sector faithfully?
(e.g. will it even be recorded in SMART current_pending_sector / 
reallocated_sector_ct ?)

Also, how do I trigger a link reset manually?

Thank you

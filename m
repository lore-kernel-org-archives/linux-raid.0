From: Chris Murphy <lists@colorremedies.com>
Subject: Re: 3TB drives failure rate
Date: Sun, 28 Oct 2012 18:27:08 -0600
Message-ID: <B63BE7FC-919F-43BC-A1F8-51D2804A6F48@colorremedies.com>
References: <11510711257.20121028131527@oudeis.org> <DB91871A-731F-44B4-9381-8FBF7D9CC3BF@colorremedies.com> <20121029015910.018efb17@natsu> <F548750F-8D0E-4D05-813B-58D85D652226@colorremedies.com> <20121029021643.1c9e3195@natsu> <46B8932A-58A5-4C1A-9C8C-DCCD5D3A1CD9@colorremedies.com> <508DAAD3.4050209@shiftmail.org> <508DAD6F.1070509@turmel.org> <508DC9F5.1040504@shiftmail.org>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <508DC9F5.1040504@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Oct 28, 2012, at 6:12 PM, joystick <joystick@shiftmail.org> wrote:

> On 10/28/12 23:10, Phil Turmel wrote:
>> The drives I've suffered with on this have ignored the link reset and
>> were still unresponsive when MD tried to rewrite the sector(s) involved
>> (from the other drives in the array).
> 
> Very interesting
> 
> I would like to see this behaviour to make some experiments.
> I would like to simulate an unreadable sector...
> I see --make-bad-sector in hdparm, does that simulate an unreadable sector faithfully?

In this (simulated) case, it knows the answer: bad sector. In a real scenario it doesn't know. So with hdparm's bad sector you're probably going to get an immediate read failure. And hence no hang.

Chris Murphy


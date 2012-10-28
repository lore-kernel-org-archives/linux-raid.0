From: Phil Turmel <philip@turmel.org>
Subject: Re: 3TB drives failure rate
Date: Sun, 28 Oct 2012 18:10:55 -0400
Message-ID: <508DAD6F.1070509@turmel.org>
References: <11510711257.20121028131527@oudeis.org> <DB91871A-731F-44B4-9381-8FBF7D9CC3BF@colorremedies.com> <20121029015910.018efb17@natsu> <F548750F-8D0E-4D05-813B-58D85D652226@colorremedies.com> <20121029021643.1c9e3195@natsu> <46B8932A-58A5-4C1A-9C8C-DCCD5D3A1CD9@colorremedies.com> <508DAAD3.4050209@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <508DAAD3.4050209@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: joystick <joystick@shiftmail.org>
Cc: Chris Murphy <lists@colorremedies.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 10/28/2012 05:59 PM, joystick wrote:
> I have tried to set ERC to lower values than 7 on Hitachi drives, and
> maybe AFAIR also on WD RE, but none of the two allowed values lower
> than, IIRC, 6.0 seconds . Which is strange because the smart command
> wants 2 digits, expressed in deciseconds, so I would expect to be able
> to set the ERC to 0.1 seconds which is definitely not possible.
> 
> Any comments would be appreciated.
> 
> What Linux needs to address this feature imho is the ability to
> configure the failure actions. If the drive does not respond within 1
> second, I want the SCSI command to be aborted, device RESET, bus RESET
> or whatever (without the drive dropping out of the controller if
> possible), then an error to be returned to MD so that it starts the
> sector rewrite and goes on immediately. Do you think this would be
> possible or it would puzzle the drive?

The timeouts are attributes of the controller queues, and default to 30
seconds.  However, if the timeout is shorter than the drive's worst-case
error recovery time, the drive typically gets kicked out of the array.
The drives I've suffered with on this have ignored the link reset and
were still unresponsive when MD tried to rewrite the sector(s) involved
(from the other drives in the array).

In my experience, that's the real problem with green/consumer drives--if
you choose to use them, you *must* set the queue timeouts to ~180
seconds.  And if your digital video recorder app can't buffer data that
long, you're screwed.

Phil

From: Phil Turmel <philip@turmel.org>
Subject: Re: Raid5 drive fail during grow and no backup
Date: Thu, 04 Dec 2014 15:02:51 -0500
Message-ID: <5480BDEB.9070407@turmel.org>
References: <loom.20141031T141939-473@post.gmane.org> <5455A35C.2060000@turmel.org> <loom.20141103T151703-83@post.gmane.org> <5458FC2A.1050308@turmel.org> <545CEDFB.6060806@gautschi.net> <545D8FBA.9090701@turmel.org> <5480B5FF.5050407@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5480B5FF.5050407@ubuntu.com>
Sender: linux-raid-owner@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>, "P. Gautschi" <linuxlist@gautschi.net>
Cc: Vince <stuff@hagenhuegel.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Phillip,

On 12/04/2014 02:29 PM, Phillip Susi wrote:
> On 11/7/2014 10:36 PM, Phil Turmel wrote:
>> However, if the device with the bad sector is trying to recover
>> longer than the linux low level driver's timeout, bad things^TM
>> happen. Specifically, the driver resets the SATA (or SCSI)
>> connection and attempts to reconnect.  During this brief time, it
>> will not accept further I/O, so the write back of the reconstructed
>> data fails.  Then the device has experienced a *write* error, so MD
>> fails the drive.  This is the out-of-the-box behavior of
>> consumer-grade drives in raid arrays.
> 
> What?  During the recovery action ( reset and retry ), a write being
> issued to the drive should just sit in the request queue until after
> the drive finishes being reset; it should not just be failed outright.

It's been a few years since I've directly tested this myself, but that's
what would happen.  The window to reject the write might be small, but
it's there (unless the fix is recent).

I'm not an expert on the driver stack, though.  YMMV.

Phil

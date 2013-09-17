From: P Orrifolius <porrifolius@gmail.com>
Subject: Re: LSI 9211 (SAS2008) BIOS problems, invalid PCI slot
Date: Tue, 17 Sep 2013 22:01:45 +1200
Message-ID: <CAC38o7SiRtQWQ2wHt6+xJkgMSdEWh_CEsyaJpC_F+a-MAiX3XQ@mail.gmail.com>
References: <CAC38o7Q4R_qXdtfBv86cNkEq6bp-6GrtqYat2m=WW47Tc5D6aw@mail.gmail.com>
	<5237AFC2.7090807@hardwarefreak.com>
	<CAC38o7RW1NULs6WhSNTqiTr1Nu38QNy1vQTpHRNRfk4a3fKubw@mail.gmail.com>
	<5237E550.7090606@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5237E550.7090606@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 17 September 2013 17:14, Stan Hoeppner <stan@hardwarefreak.com> wrote:
> On 9/16/2013 10:55 PM, P Orrifolius wrote:

> That said, I highly recommend you do not flash the board with the
> Initiator Target (IT) firmware.  The IT firmware simply removes RAID
> capability, and adds support for SAS expanders and up to 256 connected
> devices.  Other than that, AFA Linux is concerned, there is no
> -functional- difference between the IR firmware in HBA (BIOS disabled)
> mode, and the IT firmware.  If you do not plan to use an expander, don't
> flash the board.  Just leave the BIOS disabled.
>
>>  - will the controller being 'Disabled' lose me any capabilities
>> beyond booting from controller connected devices?
>
> The controller isn't disabled.  Only the BIOS and RAID firmware are
> disabled.  You simply lose the firmware based RAID capability.  It
> should be possible to boot a connected drive even with the RAID function
> disabled.  Play with it some more.

Yeah, it was apparent that it wasn't really disabled, though that is
what the config utility calls it.

All the information I'd seen suggested flashing to IT was
required/ideal in order to use as JBOD to avoid the controller messing
with things, though I obviously started to doubt that when I saw the
drive in linux.

Anyway, I don't need the expanders or more drives so, as you say, I'll
have a play with it 'Disabled' on the strength of your comments.  I'd
rather not flash the firmware.

Thanks for the help.

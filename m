From: "Wilson, Jonathan" <piercing_male@hotmail.com>
Subject: Re: Sleepy drives and MD RAID 6
Date: Tue, 12 Aug 2014 10:46:24 +0100
Message-ID: <BLU436-SMTP2487F2FA5F4B1A1A1B1E87B98EA0@phx.gbl>
References: <CAH_2GheOOaJRp7YimEsorFzGUJyObG2QsOpu87CYvwLPwz-V+A@mail.gmail.com>
	 <53E96C21.2050309@nuclearwinter.com> <53E9AC63.1020809@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <53E9AC63.1020809@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Can Jeuleers <can.jeuleers@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 2014-08-12 at 07:55 +0200, Can Jeuleers wrote:
> On 08/12/2014 03:21 AM, Larkin Lowrey wrote:
> > Also, leaving spin-up to the controller is
> > also not so hot since some controllers spin-up the drives sequentially
> > rather than in parallel.
> 
> Sequential spin-up is a feature to some, because it avoids large power
> spikes.

I vaguely recall older drives had a jumper to set a delayed spin up so
they stayed in a low power (possibly un-spun up) mode when power was
applied and only woke up when a command was received (I think any
command, not a specific "wake up" one).

Also as mentioned some controllers may also only wake drives one after
the other, likewise mdriad does not care about the underlying
hardware/driver stack, only that it eventually responds, and even then I
believe it will happily wait till the end of time if no response or
error is propagated up the stack; hence the time out in scsi_device
stack not in the mdraid.



> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 



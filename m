From: Phil Turmel <philip@turmel.org>
Subject: Re: md failing mechanism
Date: Fri, 22 Jan 2016 19:44:55 -0500
Message-ID: <56A2CD07.9000804@turmel.org>
References: <56A26E11.2090703@yandex.ru> <56A28309.9080806@turmel.org>
 <56A2A2C3.9000801@yandex.ru> <56A2BDF7.7020101@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <56A2BDF7.7020101@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: James J <james.j@shiftmail.org>, Dark Penguin <darkpenguin@yandex.ru>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 01/22/2016 06:40 PM, James J wrote:
> On 22/01/2016 22:44, Dark Penguin wrote:
>>
>> As I understand, one way around this problem is to change the kernel
>> timeout to exceed the drive timeout by changing
>> /sys/block/sd?/device/timeout to something larger than the default 30,
>> but I'd have to do that after every reboot, is all that correct?
>>
> 
> No, this part needs further investigation and comments from the gurus.

Yes, DP had that correct.

> With a SCSI timeout 30 secs, which is the setting you had at the time of
> the incident AFAIU, what should have happened was that the drive should
> have been kicked out at the 30th second, this is BEFORE it had a chance
> to return a read failure because your desktop drive takes more than
> 30secs to return a read failure. This was what you indeed expected but
> it is not what has happened.

His problem description doesn't perfectly match timeout mismatch.  He
probably had a real problem that was exacerbated by his now-discovered
timeout problem.  He no longer has the dmesg so further speculation is
moot.  If it happens again, we can look closer.

> The recommentation of raising the timeout to 120+ is for the opposite
> purpose of what you want. It is for the case the sysadmin accepts to
> wait a long time because he wants to prevent the kicking of the drive at
> the first read-error (normally drives are kicked for a write error).
> This might be wanted in order to a) defer the replacement of the drive,
> either to perform the replacement at a more opportune time and/or in a
> better manner such as a no-degrade replace operation, or b) because he
> does not want to replace the drive at all: maybe he believes that the
> error might be spurious and will not happen again and the drive is still
> of acceptable fitness for the purpose, e.g. in a low-cost file server.

No.  If you have a drive that doesn't support scterc or has it turned
off, you *must* set a timeout longer than the drive's native timeout or
you will have great problems.  I suggest you read the references to the
archives I posted.

Keep in mind that in a properly working array UREs are *fixed* when
discovered by overwriting them.  This is vital to array robustness, as
many UREs are transient (don't need relocation at all).

Phil


From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: md failing mechanism
Date: Sat, 23 Jan 2016 14:09:45 +0000
Message-ID: <56A389A9.1080203@youngman.org.uk>
References: <56A26E11.2090703@yandex.ru> <56A28309.9080806@turmel.org>
 <56A2A2C3.9000801@yandex.ru> <56A2BDF7.7020101@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <56A2BDF7.7020101@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: James J <james.j@shiftmail.org>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 22/01/16 23:40, James J wrote:
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

Except, aiui, even in your scenario! drives are kicked for a *write* error.

What happens (should be) is the kernel times out, the raid handles the
read error by trying a rewrite, the drive is still hung on the read
error so it doesn't respond to the write request, and the drive gets
kicked for a write failure.

Cheers,
Wol

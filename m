From: Luca Berra <bluca@comedia.it>
Subject: Re: [systemd-devel] systemd kills mdmon if it was started manually
	by user
Date: Sun, 12 Dec 2010 14:20:28 +0100
Message-ID: <20101212132028.GB24577@maude.comedia.it>
References: <AANLkTimHWjC5RrgZc6egrhgDLwX3zAi9ZPSvZomB2gW-@mail.gmail.com> <201012041012.23757.trapni@gentoo.org> <AANLkTikTa8stFAcXG9jknh=RG=-Mi+xW-AD9DgZCfQ=7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AANLkTikTa8stFAcXG9jknh=RG=-Mi+xW-AD9DgZCfQ=7@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Dec 04, 2010 at 03:08:05PM +0300, Andrey Borzenkov wrote:
>mdmon does not belong to user. User is not even aware that it is
>started. And it is likely not the last case. So systemd does need some
>framework which can move such processes out of user session. It
>probably needs some sd_daemon API to notify systemd that it is system
>level task even if it was started as result of user interaction.

what about running mdmon --all --takeover outside of user context at
shutdown, it should replace all mdmon processes with new ones that won't
be killed when user sessions are being closed?

Regards,
L.

-- 
Luca Berra -- bluca@comedia.it

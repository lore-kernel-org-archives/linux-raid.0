From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Subject: Re: mismatch_cnt again
Date: Sun, 08 Nov 2009 09:19:35 +1100
Message-ID: <4AF5F277.4040309@eyal.emu.id.au>
References: <4AF4C247.6050303@eyal.emu.id.au> <4AF4D323.6020108@panix.com>	<4AF5268D.60900@eyal.emu.id.au>	<4877c76c0911070008m789507f8h799d419287740ca5@mail.gmail.com> <87tyx6tpcb.fsf@frosties.localdomain> <4AF58B20.3000409@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AF58B20.3000409@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Doug Ledford wrote:
[trim]
> And actually, with 1TB drives, your most likely culprit for this is the
> last item I just listed: reallocated drive sectors.
[trim]

I did say "smart shows no issues with the disks". This means, naturally, no
reallocated count/events on any of the 5 drives.

-- 
Eyal Lebedinsky	(eyal@eyal.emu.id.au)

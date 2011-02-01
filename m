From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Performance question, RAID5
Date: Tue, 01 Feb 2011 11:37:42 +0000
Message-ID: <4D47F086.9000308@anonymous.org.uk>
References: <AANLkTimXp-vGP8fb2Y-2EiaGxj+H6UJ9DfjtYMVDhDri@mail.gmail.com>	<20110130035352.1d72e8d1@natsu>	<AANLkTi=ii-iLybJBS8ncajwXWZnkwLY=u0AcQiBJKPUf@mail.gmail.com>	<20110130015231.GA1435@www2.open-std.org>	<AANLkTimw6CTP66FZdbH07kjMmHoxoFRF6Eq9WDR_LYt8@mail.gmail.com>	<20110130055616.GA13022@www2.open-std.org> <AANLkTi=CdiOjA15umaaO9ORDQ9StoesC2eD5q0_e3Bb0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=CdiOjA15umaaO9ORDQ9StoesC2eD5q0_e3Bb0@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?TWF0aGlhcyBCdXLDqW4=?= <mathias.buren@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 30/01/2011 12:12, Mathias Bur=C3=A9n wrote:
[...]
> Ah, good point. The sda is a 60GB SSD, I should definitely move that
> to the PCI-E card, as it doesn't do heavy IO (just small random r/w).
> Then i can have 4 RAID HDDs on the onboard ctrl, and 2 on the PCI-E
> shared with the SSD. If the SSD is idle then I should get ideal
> throughputs.

Hmm, if you have an SSD, you might look at using bcache to speed up=20
write access to your array. On the other hand, with only one SSD you=20
potentially lose redundancy - do SSDs crash and burn like hard drives d=
o?

If the SSD is only being used as a boot/OS drive - so near idle in=20
normal use - I'd swap it for a cheap small laptop hard drive and find=20
somewhere else to put the SSD to better use.

Cheers,

John.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

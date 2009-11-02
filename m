From: Jon Nelson <jnelson-linux-raid@jamponi.net>
Subject: Re: unbelievably bad performance: 2.6.27.37 and raid6
Date: Mon, 2 Nov 2009 13:39:35 -0600
Message-ID: <cccedfc60911021139o7cac1ad2rb70333d5fc8026e6@mail.gmail.com>
References: <cccedfc60910310855l5ca6c42aj503fb0e4fd6232ad@mail.gmail.com>
	<bb145bd20910311259j7b2506c8v4e8907eb73598275@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <bb145bd20910311259j7b2506c8v4e8907eb73598275@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, Oct 31, 2009 at 1:59 PM, Christian Pernegger
<pernegger@gmail.com> wrote:
>> md0 : active raid6 sda4[0] sdc4[5] sdd4[4] sdb4[6]
>> =A0 =A0 =A0613409536 blocks super 1.1 level 6, 64k chunk, algorithm =
2 [4/4] [UUUU]
>
> Why would you use a 4 disk raid6? If 50% of raw capacity is enough
> just go with raid10

With 4 disks, the ability to sustain *any two* devices going bad is a b=
ig bonus.
Using raid10 with two copies (1 original, 1 duplicate) on 4 disks
gives me 50% space but I can only sustain *1* failed device. I'm
guessing I'd have to go with raid10 with three copies (1 original, 2
duplicate) which is even worse (2/3 space lost). Did I just calculate
that all wrong?


--=20
Jon
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Tony Arcieri <tony@medioh.com>
Subject: Re: md tries to assemble md_d0 instead of md0
Date: Mon, 24 Aug 2009 00:10:15 -0600
Message-ID: <c7e6b2b00908232310v47e329d0oc32f5265f8859396@mail.gmail.com>
References: <c7e6b2b00908230907v4a02a76bt9641e8dca009d64e@mail.gmail.com>
	 <c7e6b2b00908230912w59f1998wd109272b6904e03b@mail.gmail.com>
	 <20090824055018.GA11940@maude.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090824055018.GA11940@maude.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Aug 23, 2009 at 11:50 PM, Luca Berra <bluca@comedia.it> wrote:
>
> On Sun, Aug 23, 2009 at 10:12:43AM -0600, Tony Arcieri wrote:
>>
>> Is there a permanent solution to this problem?=A0 Where is md_d0 eve=
n
>> coming from?=A0 How do I permanently get rid of it?
>
> check your udev rules

=46or what it's worth, reinstalling Ubuntu solved the problem.=A0 Upon =
my
first boot into the new install it automatically started resyncing the
RAID.

Dunno what that's about, and reinstalling Linux is not my preferred
way to fix a problem, but at this point my RAID is resyncing and
everything seems to be fine.

--
Tony Arcieri
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

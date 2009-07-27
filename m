From: Jon Nelson <jnelson-linux-raid@jamponi.net>
Subject: Re: help with bad performing raid6
Date: Mon, 27 Jul 2009 15:03:45 -0500
Message-ID: <cccedfc60907271303p7e26ab07w5d400b1279974cc5@mail.gmail.com>
References: <cccedfc60907271219n1f3431c4w50033d4f5bc43edc@mail.gmail.com>
	<20090727200150.GA3764@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090727200150.GA3764@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Jul 27, 2009 at 3:01 PM, Robin Hill<robin@robinhill.me.uk> wrot=
e:
> On Mon Jul 27, 2009 at 02:19:42PM -0500, Jon Nelson wrote:
>
>> I have a raid6 which is exposed via LVM (and parts of which are, in
>> turn, exposed via NFS) and I'm having some really bad performance
>> issues, primarily with large files. I'm not sure where the blame lie=
s.
>> When performance is bad "load" on the server is insanely high even
>> though it's not doing anything except for the raid6 (it's otherwise
>> quiescent) and NFS (to typically just one client).
>>
> Have you checked dmesg for disk errors? =A0I've had similar slowdowns=
 when
> there's a bad block on the drive - it's sitting waiting for the retri=
es
> to timeout (or the bus to reset) and the read to fail.

Yes. There are no bad blocks that are being reported.
I also do a "long" SMART test weekly, and a short one daily.
The smart values look great.

--=20
Jon
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: "Dan Egli" <dan@eglifamily.dnsalias.net>
Subject: Re: What raid to build on that drives?
Date: Wed, 26 Nov 2003 12:59:02 -0700 (MST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4697.206.81.129.218.1069876742.squirrel@eglifamily.dnsalias.net>
References: <3229206566.20031126203657@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3229206566.20031126203657@gmx.net>
To: Timo Boettcher <spida@gmx.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Hi,
>
>    I have 3 * 36GB discs and 5 * 18GB discs on two u160 scsi channels?
>    What possibilities do I have to build a raid on them? I want to be
>    able to survive one failed disc, but get as much space and
>    performance out of the discs as possible.
>

Best I can suggest is a raid 5. You'll get 72GB of space, good performance
(roughly what you'd get from a sigle drive), and if one of the drives goes
south, the other two will keep your raid set up till the drive can be
replaced.

--- Dan


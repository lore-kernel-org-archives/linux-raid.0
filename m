From: Jon Nelson <jnelson-suse@jamponi.net>
Subject: Re: help with bad performing raid6
Date: Fri, 31 Jul 2009 14:31:56 -0500
Message-ID: <cccedfc60907311231j62ccc67ay5b3837f54813fd63@mail.gmail.com>
References: <cccedfc60907271219n1f3431c4w50033d4f5bc43edc@mail.gmail.com>
	<72dbd3150907301409t5ea20979gcf400e4c53a32d62@mail.gmail.com>
	<20090731182118.GB11756@rap.rap.dk> <cccedfc60907311123i6232f926n6617ed9d2432c081@mail.gmail.com>
	<72dbd3150907311219v53bc4fbfja9cc29c806136ae0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <72dbd3150907311219v53bc4fbfja9cc29c806136ae0@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> OK, so how fast does a simple dd write to the NFS share?

I changed some of the test params, here: now I am over a gig-e link
and switch instead of 100Mbit.

Performance: 16-18MB/s very steady. Load on server: around 9. I have 8
nfsd configured.

I can live with 17MB/s. I wonder if I had a hub/switch/whatever go bad
and start to flake out when under load. You may safely ignore this
thread.


-- 
Jon

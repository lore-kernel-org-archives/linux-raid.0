From: Jon Nelson <jnelson-linux-raid@jamponi.net>
Subject: Re: question about bitmaps and dirty percentile
Date: Fri, 31 Jul 2009 14:09:06 -0500
Message-ID: <cccedfc60907311209o2637c2f2vcda619763f79037a@mail.gmail.com>
References: <cccedfc60907301125i2187907od5819e464de2d25a@mail.gmail.com>
	<cccedfc60907301216h769eadd7oc575dd3ae04f64bb@mail.gmail.com>
	<4A733551.5010408@steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4A733551.5010408@steeleye.com>
Sender: linux-raid-owner@vger.kernel.org
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> The bitmap never gets cleared unless all disks in the array are in sync.

Well, that sucks. What is the reasoning behind that? It would seem
that having 2 out of 3 disks with an up-to-date bitmap would be
useful.

However, it doesn't explain the 200% problem.

-- 
Jon

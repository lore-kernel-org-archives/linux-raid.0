From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Reed Solomon coding based Raid?
Date: Mon, 30 Nov 2009 13:36:03 +0100
Message-ID: <87eing42bw.fsf@frosties.localdomain>
References: <4B113E90.50904@xs4all.nl> <1259423300.31633.190.camel@localhost>
	<1f808b4a0911280943x4ab781dbq28a11a2e3a77598a@mail.gmail.com>
	<4B129855.5050702@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B129855.5050702@gmail.com> (Andrew Dunn's message of "Sun, 29
	Nov 2009 10:50:45 -0500")
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Dunn <andrew.g.dunn@gmail.com>
Cc: Peter Chacko <peterchacko35@gmail.com>, Kasper Sandberg <postmaster@metanurb.dk>, John Hendrikx <hjohn@xs4all.nl>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Andrew Dunn <andrew.g.dunn@gmail.com> writes:

> I have been toying with the idea of an open source project to achieve
> a more generalized functional spec. than what symform has created. I
> was thinking of calling it RAINcloud (redundant array of independent
> nodes)
>
> I started drawing up the requirements over the holiday weekend.

Would that be nodes as in different systems? In that case you should
check glusterfs and provide a raincloud module for it.

On the other hand if nodes is just local disks glusterfs might still
be a good way to implement and test your algorithm before putting it
into the kernel.

MfG
        Goswin

PS: Isn't the Reed Solomon for x+1 disks == XOR and x+2 disks p+q
parity? I.e. raid4/5/6 are Reed Solomon are just the first 2 cases for
Reed Solomon.

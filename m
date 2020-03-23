From: Glenn Greibesland <glenngreibesland@gmail.com>
Subject: Re: Raid6 recovery
Date: Mon, 23 Mar 2020 13:35:19 +0100
Message-ID: <CA+9eyihM0pAZXY4MwqDr3FSD7FAp+3oFFU4-7U3n7MVSKi+o7A@mail.gmail.com>
References: <CA+9eyijuUEJ7Y8BuxkKaZ=v8zbPpwixOezngPjtJzaLsBd+A4Q@mail.gmail.com>
 <5E75163B.2050602@youngman.org.uk> <CA+9eyigMV-E=FwtXDWZszSsV6JOxxFOFVh6WzmeH=OC3heMUHw@mail.gmail.com>
 <ab2a40b6-b4ab-9ff8-aef6-02d8cce8d587@youngman.org.uk> <CA+9eyig8U2Tzi1wF97k7eDu5vKg5Jc2sRXKaw0OCy7Cbc9HMog@mail.gmail.com>
 <c55be05d-22ee-4676-7878-5bf99ccc80f9@turmel.org> <CA+9eyiicKrPh9YTrGN5FjOU7zMVMqO3=8yGszWkV67fJxrtKrw@mail.gmail.com>
 <50fc13d2-bd5f-d3c3-09f6-f7274aeaf917@turmel.org> <5E788014.3080203@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5E788014.3080203@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org, NeilBrown <neilb@suse.com>
List-Id: linux-raid.ids

man. 23. mar. 2020 kl. 10:23 skrev Wols Lists <antlists@youngman.org.uk>:

> And note that the website does tell you always to use the latest version
> of mdadm when trying to recover an array ... because it's linux-only
> it's pretty easy to build from source if you have to.

I was probably using verison 3.3-2 when I ran --re-add and the problem
started. That is the latest version available for the verison of
Ubuntu Server I am running.
I then upgraded to v4.0 and later to v4.1-65 by building from source.
Lesson learned.

Question about mdadm documentation:
Should the man page be updated to reflect the support for using
sectors as units in addition to K M G and T?

Glenn

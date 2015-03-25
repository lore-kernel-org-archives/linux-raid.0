From: Phil Turmel <philip@turmel.org>
Subject: Re: missing arrays after OS upgrade
Date: Tue, 24 Mar 2015 20:03:07 -0400
Message-ID: <5511FB3B.8030607@turmel.org>
References: <CAHscji03jWu3EF0KUG45Hv4Y2t5beJmEoe9uWMfR=wGz_dkBbw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAHscji03jWu3EF0KUG45Hv4Y2t5beJmEoe9uWMfR=wGz_dkBbw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Daniel Sanabria <sanabria.d@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 03/24/2015 06:48 PM, Daniel Sanabria wrote:
> Hi,
> 
> One of our servers went trough an OS upgrade (from fedora20 to
> fedora21) and althou some of the arrays seem to be auto-detected one
> of them seem to be missing.

You may have had some device names reordered.  Building a config that
relies on the names is common but unwise.

With such a thin report, there's not much to go on.  Please run lsdrv
[1] and paste its output in a reply.

Then add the contents of /proc/mdstat, the relevant-looking parts of
dmesg, and your mdadm.conf file.

We may need more later, but this will permit intelligent follow-up
questions.

Phil

[1] https://github.com/pturmel/lsdrv

From: Phil Turmel <philip@turmel.org>
Subject: Re: array went wonky
Date: Fri, 03 May 2013 10:24:06 -0400
Message-ID: <5183C886.5000607@turmel.org>
References: <474B6DA3-FED2-4674-9707-1BC43378CB90@gmail.com> <DC0F689B-F5E5-41F3-9CD4-74813E4A6108@bingner.com>,<F29438B9-DA12-40B1-8382-30886C95B5BD@gmail.com> <71F985BA-11B9-45E8-A17B-03F9CB5C8F52@bingner.com> <517FD8FB.7000006@turmel.org> <59BD334D-D9B3-4856-AEF3-F033E511B0DD@gmail.com> <15E1BF3C-2361-4FC7-8D19-AA319C187AF5@gmail.com> <CF52FDBB-A0DA-4912-9352-3A742BBC273B@gmail.com> <724CACBC-1D7E-4EE0-91FE-97D5ADC0CD59@gmail.com> <91F4D0DD-926D-4337-B79C-08BA1141EF78@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <91F4D0DD-926D-4337-B79C-08BA1141EF78@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Gimpbully <gimpbully@gmail.com>
Cc: Sam Bingner <sam@bingner.com>, "<linux-raid@vger.kernel.org>" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 05/03/2013 02:47 AM, Gimpbully wrote:
> Anyone?  I'm so close I can taste it.  It looks like the superblocks
> on the other disks think that sdf1 is still defined as a spare, but
> it's a ddrescue of what used to be /dev/sdc.  Is there a way to
> update the superblocks?

Sorry, been busy.

Unfortunately, once a member is marked "spare", it simply doesn't know
any more what role it used to have.  So "--assemble" won't get you there.

You will need to use "--create --assume-clean" or directly edit the
offending superblock.

> *Complete* output of "mdadm -E" for the array members is needed before
> any "--create" operation is attempted.  Plus the distro info, kernel
> version, and mdadm version .

I would also like to see "smartctl -x" output for each underlying disk.
 It would be good if we understood *why* your array "went wonky" so that
it doesn't happen again after reassembling your array.  Your situation
"smells" like a timeout mismatch and/or lack of scrubbing.

Finally, in the interest of helping others help you, please don't
top-post, and *do* trim your quotes.  It greatly helps when coming back
to a thread after a few days.

Phil

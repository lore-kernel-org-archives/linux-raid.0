From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: sata badness in 2.6.20-rc1? [Was: Re: md patches in -mm]
Date: Tue, 19 Dec 2006 15:26:00 -0800 (PST)
Message-ID: <362582.18476.qm@web31811.mail.mud.yahoo.com>
References: <20061217160056.GA3555@amd64.of.nowhere>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20061217160056.GA3555@amd64.of.nowhere>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Jeff Garzik <jeff@garzik.org>, Neil Brown <neilb@suse.de>, Jurriaan <thunder7@xs4all.nl>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, Tejun Heo <htejun@gmail.com>, Alan <alan@lxorguk.ukuu.org.uk>, Luben Tuikov <ltuikov@yahoo.com>
List-Id: linux-raid.ids

--- thunder7@xs4all.nl wrote:
> From: Andrew Morton <akpm@osdl.org>
> Date: Sun, Dec 17, 2006 at 03:05:39AM -0800
> > On Sun, 17 Dec 2006 12:00:12 +0100
> > "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > 
> > > Okay, I have identified the patch that causes the problem to appear, which is
> > > 
> > > fix-sense-key-medium-error-processing-and-retry.patch
> > > 
> > > With this patch reverted -rc1-mm1 is happily running on my test box.
> > 
> > That was rather unexpected.   Thanks.
> >
> I can confirm that 2.6.20-rc1-mm1 with this patch reverted mounts my
> raid6 partition without problems. This is x86_64 with SMP.
> 

The reason was that my dev tree was tainted by this bug:

        if (good_bytes &&
-           scsi_end_request(cmd, 1, good_bytes, !!result) == NULL)
+           scsi_end_request(cmd, 1, good_bytes, result == 0) == NULL)
                return;

in scsi_io_completion().  I had there !!result which is wrong, and when
I diffed against master, it produced a bad patch.

As James mentioned one of the chunks is good and can go in.

    Luben


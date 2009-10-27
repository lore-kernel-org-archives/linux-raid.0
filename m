From: adfas asd <chimera_god@yahoo.com>
Subject: Re: Is My Data DESTROYED?!
Date: Tue, 27 Oct 2009 13:31:08 -0700 (PDT)
Message-ID: <472064.4204.qm@web38802.mail.mud.yahoo.com>
References: <1256656849.15137.126.camel@poledra.romunt.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1256656849.15137.126.camel@poledra.romunt.nl>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--- On Tue, 10/27/09, Rudy Zijlstra <rudy@grumpydevil.homelinux.org> wrote:
> NFS/Samba are "bloated" as you call it, because

In my opinion they are bloated because they are outmoded and ancient.  FUSE instantly rendered them obsolete.

So sine iSCSI is out my next avenue of investigation is clustering filesystems.  They should have the file-locking problem solved, and should perform better than sshfs, much less NFS or SAMBA.


--- On Tue, 10/27/09, Ryan Wagoner <rswagoner@gmail.com> wrote:
> No NFS and Samba are not ancient bloatware. What other
> protocol would
> you use for a company file server? Rsync and SSH are not
> replacements for group file sharing.

As I say, sshfs.  Be officially turned on to FUSE and sshfs.  If you continue to decline, feel free to remain in the old-timey days grandpa.  (PS, I'm 55)


--- On Tue, 10/27/09, Bill Davidsen <davidsen@tmr.com> wrote:
> What's the problem? You generate a list of file
> checksums AND SIZES and
> do some percentage of it daily, or all of it weekly, or
> whatever
> pleases you. And every time you change or add a file you
> update the
> checksum file on the master, and send it off to the backup
> machine. Of
> course you verify on the master as well as the backup, just
> in case a
> file is damaged on the master. The nice thing about this is
> that it can
> all be automated and can send you email saying that some
> number of
> files were checked and were okay, or were not okay.
> 
> If it were my problem I would invest in two Gbit cards per
> machine, two
> *good* cables, and configure for jumbo frames. That gives
> you over
> 200MB/s transfer rate using rsync, runs over ssh by default
> for
> security, does checksums by default for reliability, should
> give you a
> nice safe copy which you can verify using the checksum
> file.

Very nice Bill, but I don't know the best way to go about these things.  This is why I keep asking for specifics.  Maybe if you pretend that I'm a dumb real estate developer...




      

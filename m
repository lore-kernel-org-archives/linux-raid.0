From: Neil Brown <neilb@suse.de>
Subject: Re: question about --assume-clean
Date: Sun, 10 Jun 2007 08:31:34 +1000
Message-ID: <18027.10822.429848.873647@notabene.brown>
References: <466AE61A.1000107@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Peter Rabbitson on Saturday June 9
Sender: linux-raid-owner@vger.kernel.org
To: Peter Rabbitson <rabbit@rabbit.us>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday June 9, rabbit@rabbit.us wrote:
> Hi,
> 
> I am about to create a large raid10 array, and I know for a fact that 
> all the components are identical (dd if=/dev/zero of=/dev/sdXY). Is it 
> safe to pass --assume-clean and spare 6 hours of reconstruction, or are 
> there some hidden dangers in doing so?

No, there are no hidden dangers.

--assume-clean is generally quite safe with mirroring levels (raid1,
raid10).  The only issue is that if you do a regular 'check', then it
will reports lots of issues.  If do a 'repair' it will fix the issues.

With raid4/5/6, --assume-clean is *not* safe if there is any doubt that
the drive are not already in an in-sync state.

NeilBrown


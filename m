From: Neil Brown <neilb@suse.de>
Subject: Re: md: md6_raid5 crash 2.6.20
Date: Tue, 13 Feb 2007 19:44:17 +1100
Message-ID: <17873.31329.972230.498090@notabene.brown>
References: <200702121628.l1CGSwhJ019548@cichlid.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andrew Burgess on Monday February 12
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Burgess <aab@cichlid.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Monday February 12, aab@cichlid.com wrote:
> >However
> >this "kernel BUG" is something newly introduced in 2.6.20 which should
> >be fixed in 2.6.20.1.  Patch is below.
> 
> I am using raid6. Am I at risk after applying this patch?

I'm not going to say "you are not at risk after applying this patch"
as one never knows about hidden bugs until one finds them.

However this patch is equally applicable to raid6 and if you apply it
you should be able to continue using your raid6 with as much
confidence as before...

NeilBrown

From: "NeilBrown" <neilb@suse.de>
Subject: Re: [mdadm PATCH] Introduce a commandline option for setting
 RebuildNN increment size
Date: Fri, 16 Oct 2009 10:37:31 +1100
Message-ID: <5f78d97bd4f9e3e646f7e375fa91d626.squirrel@neil.brown.name>
References: <4AD730CC.2010701@matfyz.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AD730CC.2010701@matfyz.cz>
Sender: linux-raid-owner@vger.kernel.org
To: Zdenek Behan <rain@matfyz.cz>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, October 16, 2009 1:25 am, Zdenek Behan wrote:
> Hi folks,
>
>
> I have been facing a problem of making a simple cgi GUI for working with
> md raid, and reporting back the information. I ended up using the
> monitor mode event mechanism for various things including updating the
> rebuild percentage. Soon after, people started complaining that 20%
> increments in progress are rather silly.
>
> I noticed long ago in the list the thought/request that those increments
> may be a bit smaller. So, here's a patch (attachment) to allow sending
> RebuildNN events at any percent increment, specified on mdadm commandline.
>
> Any comments? Is this a desirable feature? Anything I should change to
> make it acceptable?

Thanks for the patch.
Yes, I think it is a feature worth having.
Three improvements you can make to make the patch completely acceptable:
1/ Update mdadm.8 to document this feature
2/ The second argument to snprintf is the size of the buffer, not the
   expected string length.  To me it looks odd that you give different
   numbers for the same buffer.
   I would probably use
         snprintf(percentalert, sizeof(percentalert), ....)
   in both cases, but I would except a literal '15'.
3/ In the switch statement in main() you have removed the blank line
   following 'continue', where you should have added a blank line following
   the 'continue' that you added.

If you resubmit with those changes I will apply the patch.

Thanks,
NeilBrown


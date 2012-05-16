From: Oliver Martin <oliver@volatilevoid.net>
Subject: Re: Hot-replace for RAID5
Date: Thu, 17 May 2012 01:34:15 +0200
Message-ID: <4FB43977.8020607@volatilevoid.net>
References: <CAAOsTS=4+eqRJXVrw2OaYibgNTEaGxJx4x1PPN4iU49tUO9zOg@mail.gmail.com> <4FAB6758.5050109@hesbynett.no> <CAAOsTSm9RH1c6OzFdAGf8hSag35YBD5Y1SuH4Tq-4GXnWgJpAw@mail.gmail.com> <20120511105027.34e95833@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120511105027.34e95833@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: patrik@dsl.sk, David Brown <david.brown@hesbynett.no>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

Am 11.05.2012 02:50, schrieb NeilBrown:
> Doing an in-place reshape with the new 3.3 code should work, though with a
> softer "should" than above.  We will only know that it is "stable" when enough
> people (such as yourself) try it and report success.  If anything does go
> wrong I would of course help you to put the array back together but I can
> never guarantee no data loss.  You wouldn't be the first to test the code on
> live data, but you would be the second that I have heard of.

I guess I'll be taking 2nd place then. I just used it on three live 
raid6 arrays, and it worked perfectly.

Thanks for your all your awesome work!

Oliver

PS: I wasn't subscribed to the list before, so I'm trying to reply to 
this via gmane. No idea if this preserves all the list headers - if I 
break the thread, that's probably the cause.

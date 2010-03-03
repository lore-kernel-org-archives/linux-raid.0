From: Robert Minvielle <robert@lite3d.com>
Subject: Re: mdadm question
Date: Tue, 2 Mar 2010 21:05:53 -0600 (CST)
Message-ID: <1002081872.2738.1267585553566.JavaMail.root@mail1>
References: <2127483366.2736.1267585385014.JavaMail.root@mail1>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2127483366.2736.1267585385014.JavaMail.root@mail1>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

----- "Neil Brown" <neilb@suse.de> wrote:

> On Tue, 2 Mar 2010 19:15:04 -0600 (CST)
> Using old software on new hardware....
> When using Debian, I would recommend the -testing version for new
> hardware....
> (not that I am prepared to back-up that recommendation with support).
> 
> However I suspect Debian5 should be able to be made to work with your
> setup.

Hrmm, will look into that. 

> 
> The default metadata layout has a maximum of 28 devices.  If you want
> more,
> add
>    --metadata=1.0
> 
> You won't be able to use in-kernel autodetect, but you shouldn't need
> to with
> Debian, even at that vintage.
> 

Argh, I see the note now in the man page. I missed it. Funny that google
did not return that/man page/etc when I searched for things like "maximum number of
drives in mdadm array" etc. 



> I'm surprised it didn't work with '2', or did you mean "42" ?
> 

Yes, sorry for the confusion. 

Thanks. 
